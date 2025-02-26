using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using TravelLogAPI.Models;

namespace TravelLogAPI.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("VueSinglePage")]
    public class EcpayController : Controller {

        private readonly TravelLogContext _dbContext;

        public EcpayController(TravelLogContext dbContext) {
            _dbContext = dbContext;
        }

        private readonly string HashKey = "5294y06JbISpM5x9";
        private readonly string HashIV = "v77hoKGq4kWxNNIS";
        private readonly string MerchantID = "2000132";
        private readonly string ApiAddress = "https://localhost:7092"; // API server url
        private readonly string VueAddress = "https://localhost:5173"; // Vue url

        // 產生訂單
        // POST: /api/Ecpay/CreateOrder
        [HttpPost("CreateOrder")]
        public async Task<IActionResult> CreateOrder([FromBody] OrderRequest request) {
            try {
                //using (var dbContext = new TravelLogContext()) {
                var merchantTradeNo = GenerateMerchantTradeNo();
                var newOrder = new Order {
                    OrderTime = DateTime.Now,
                    OrderTotalAmount = request.TotalAmount,
                    UserId = request.UserId,
                    OrderStatus = 1,
                    OrderPaymentStatus = 1,
                    MerchantTradeNo = merchantTradeNo,
                    ProductId = request.ProductId
                };

                _dbContext.Orders.Add(newOrder);
                await _dbContext.SaveChangesAsync();

                var orderParams = new Dictionary<string, string> {
                        { "MerchantTradeNo", merchantTradeNo },
                        { "MerchantTradeDate", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") },
                        { "TotalAmount", request.TotalAmount.ToString() },
                        { "TradeDesc", HttpUtility.UrlEncode(request.TradeDesc ?? "測試交易", Encoding.UTF8) },
                        { "ItemName", request.ItemName },
                        { "MerchantID", MerchantID },
                        { "PaymentType", "aio" },
                        { "ChoosePayment", "ALL" },
                        { "EncryptType", "1" },
                        { "ReturnURL", $"{ApiAddress}/Ecpay/PaymentResult" },
                        //{ "OrderResultURL", $"{VueAddress}/paymentResult/{merchantTradeNo}" },
                        //{ "ClientRedirectURL", $"{VueAddress}/paymentResult/{merchantTradeNo}" },
                        //{ "ClientBackURL", $"{VueAddress}/paymentResult/{merchantTradeNo}" }
                        { "ClientBackURL", $"{VueAddress}/myorder" }
                    };

                orderParams["CheckMacValue"] = GetCheckMacValue(orderParams);

                return Ok(new {
                    orderId = newOrder.OrderId,
                    merchantTradeNo = merchantTradeNo,
                    orderParams = orderParams
                });
                //}
            }
            catch (Exception ex) {
                Console.WriteLine($"發生錯誤：{ex.Message}");
                return StatusCode(500, new { message = $"CreateOrder 錯誤：{ex.Message}" });
            }
        }


        private string GenerateMerchantTradeNo() {
            return $"T{DateTime.Now:yyyyMMddHHmmss}{Guid.NewGuid().ToString("N").Substring(0, 5)}";
        }

        private string GetCheckMacValue(Dictionary<string, string> order) {
            var param = order.Keys.OrderBy(x => x).Select(key => key + "=" + order[key]).ToList();
            var checkValue = string.Join("&", param);
            //測試用的 HashKey
            var hashKey = "5294y06JbISpM5x9";
            //測試用的 HashIV
            var HashIV = "v77hoKGq4kWxNNIS";
            checkValue = $"HashKey={hashKey}" + "&" + checkValue + $"&HashIV={HashIV}";
            checkValue = HttpUtility.UrlEncode(checkValue).ToLower();
            checkValue = GetSHA256(checkValue);
            return checkValue.ToUpper();
        }

        private string GetSHA256(string value) {
            var result = new StringBuilder();
            var sha256 = SHA256.Create();
            var bts = Encoding.UTF8.GetBytes(value);
            var hash = sha256.ComputeHash(bts);
            for (int i = 0; i < hash.Length; i++) {
                result.Append(hash[i].ToString("X2"));
            }
            return result.ToString();
        }

        // 綠界付款通知
        // POST: /api/Ecpay/PaymentResult
        [HttpPost("PaymentResult")]
        public async Task<IActionResult> PaymentResult([FromForm] Dictionary<string, string> formData) {
            Console.WriteLine("收到綠界的付款通知");

            try {
                if (!ValidateCheckMacValue(formData)) {
                    return BadRequest(new { message = "付款驗證失敗：CheckMacValue 不符" });
                }

                if (!formData.TryGetValue("MerchantTradeNo", out var merchantTradeNo) ||
                    !formData.TryGetValue("TradeNo", out var ecpayTradeNo) ||
                    !formData.TryGetValue("RtnCode", out var paymentStatus) ||
                    !formData.TryGetValue("PaymentType", out var paymentType)) {
                    return BadRequest(new { message = "缺少必要的參數" });
                }

                bool isSuccess = paymentStatus == "1";

                var order = await _dbContext.Orders.FirstOrDefaultAsync(o => o.MerchantTradeNo == merchantTradeNo);
                if (order == null) {
                    return NotFound(new { message = "找不到對應的訂單" });
                }

                var payment = new Payment {
                    OrderId = order.OrderId,
                    PaymentTime = isSuccess ? DateTime.Now : null,
                    PaymentMethod = GetPaymentMethodId(paymentType),
                    PaymentStatusId = isSuccess ? 2 : 3, // 付款成功為 2，失敗為 3
                    EcpayTransactionId = ecpayTradeNo
                };

                Console.WriteLine($"收到 RtnCode：{paymentStatus}");
                _dbContext.Payments.Add(payment);
                Console.WriteLine($"更新前 OrderPaymentStatus: {order.OrderPaymentStatus}");
                order.OrderPaymentStatus = isSuccess ? 2 : 1;
                Console.WriteLine($"更新後 OrderPaymentStatus: {order.OrderPaymentStatus}");

                await _dbContext.SaveChangesAsync();
                Console.WriteLine("資料庫更新成功");

                return Content("1|OK", "text/plain"); // 綠界需要這個回應
            }
            catch (Exception ex) {
                Console.WriteLine($"發生錯誤: {ex.Message}");
                return BadRequest(new { message = $"處理付款結果時發生錯誤：{ex.Message}" });
            }
        }

        private int GetPaymentMethodId(string paymentType) {
            return paymentType switch {
                "Credit" => 1,
                "WebATM" => 2,
                "ATM" => 3,
                "CVS" => 4,
                "BARCODE" => 5,
                "ALL" => 6,
                _ => 7,
            };
        }

        // 取得訂單資料
        // GET: /api/Ecpay/GetOrderInfo?merchantTradeNo=xxxx
        [HttpGet("GetOrderInfo")]
        public async Task<IActionResult> GetOrderInfo([FromQuery] string merchantTradeNo) {
            var order = await _dbContext.Orders
                .Where(o => o.MerchantTradeNo == merchantTradeNo)
                .Select(o => new {
                    o.OrderId,
                    o.MerchantTradeNo,
                    TradeDate = o.OrderTime.ToString("yyyy/MM/dd HH:mm:ss"),
                    o.OrderTotalAmount,
                    o.OrderPaymentStatus,
                    PaymentStatus = o.OrderPaymentStatusNavigation.PaymentStatus1,
                    PaymentInfo = _dbContext.Payments
                        .Where(p => p.OrderId == o.OrderId)
                        .Select(p => new {
                            p.PaymentTime,
                            p.EcpayTransactionId
                        })
                        .FirstOrDefault()
                })
                .FirstOrDefaultAsync();

            if (order == null) {
                return NotFound(new { message = "找不到訂單" });
            }

            return Ok(order);
        }

        // 取得 User 所有訂單
        // GET: /api/Ecpay/GetOrdersByUser/x
        [HttpGet("GetOrdersByUser/{userId}")]
        public async Task<IActionResult> GetOrdersByUser(int userId) {
            var orders = await _dbContext.Orders
                .Where(o => o.UserId == userId)
                .Select(o => new {
                    o.OrderId,
                    o.MerchantTradeNo,
                    TradeDate = o.OrderTime.ToString("yyyy/MM/dd HH:mm:ss"),
                    o.OrderTotalAmount,
                    o.OrderPaymentStatus,
                    PaymentStatus = o.OrderPaymentStatusNavigation.PaymentStatus1,
                    PaymentInfo = _dbContext.Payments
                        .Where(p => p.OrderId == o.OrderId)
                        .Select(p => new {
                            p.PaymentTime,
                            p.EcpayTransactionId
                        })
                        .FirstOrDefault(),
                    Product = _dbContext.TourBundles
                        .Where(p => p.Id == o.ProductId)
                        .Select(p => new {
                            p.Id,
                            p.EventName
                        })
                        .FirstOrDefault()
                })
                .ToListAsync();

            if (orders == null || !orders.Any()) {
                return NotFound(new { message = "找不到訂單" });
            }
            return Ok(orders);
        }

        private bool ValidateCheckMacValue(Dictionary<string, string> formData) {
            var validationDict = new Dictionary<string, string>(formData);

            if (!validationDict.Remove("CheckMacValue")) {
                return false;
            }

            var sortedParams = validationDict.OrderBy(x => x.Key)
                                             .Select(x => $"{x.Key}={x.Value}")
                                             .ToList();

            var checkString = $"HashKey={HashKey}&{string.Join("&", sortedParams)}&HashIV={HashIV}";

            var encodedString = HttpUtility.UrlEncode(checkString).ToLower();
            var calculatedCheckMacValue = GetSHA256(encodedString).ToUpper();

            return calculatedCheckMacValue == formData["CheckMacValue"];
        }
    }

    public class OrderRequest {
        public decimal TotalAmount { get; set; }
        public string ItemName { get; set; }
        public string TradeDesc { get; set; }
        public int UserId { get; set; }
        public int ProductId { get; set; }
    }
}
