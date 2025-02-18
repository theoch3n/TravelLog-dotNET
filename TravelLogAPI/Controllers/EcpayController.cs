using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using TravelLog.Models;

namespace TravelLogAPI.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("VueSinglePage")]
    public class EcpayController : Controller {

        //private readonly TravelLogContext _dbContext;

        //public EcpayController(TravelLogContext dbContext){
        //    _dbContext = dbContext;
        //}

        private readonly string HashKey = "5294y06JbISpM5x9";
        private readonly string HashIV = "v77hoKGq4kWxNNIS";
        private readonly string MerchantID = "2000132";
        private readonly string ApiAddress = "https://localhost:7092"; // API server url
        private readonly string VueAddress = "https://localhost:5173"; // Vue url

        // 產生訂單
        [HttpPost("CreateOrder")]
        public async Task<IActionResult> CreateOrder([FromBody] OrderRequest request) {
            try {
                using (var dbContext = new TravelLogContext()) {
                    var merchantTradeNo = GenerateMerchantTradeNo();
                    var newOrder = new Order {
                        OrderTime = DateTime.Now,
                        OrderTotalAmount = request.TotalAmount,
                        UserId = request.UserId,
                        OrderStatus = 1,
                        OrderPaymentStatus = 1,
                        MerchantTradeNo = merchantTradeNo
                    };

                    dbContext.Orders.Add(newOrder);
                    await dbContext.SaveChangesAsync();

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
                        { "ClientRedirectURL", $"{VueAddress}/paymentResult/{merchantTradeNo}" }
                    };

                    orderParams["CheckMacValue"] = GetCheckMacValue(orderParams);

                    return Ok(new {
                        orderId = newOrder.OrderId,
                        merchantTradeNo = merchantTradeNo,
                        orderParams = orderParams
                    });
                }
            }
            catch (Exception ex) {
                // 錯誤日誌+
                Console.WriteLine($"❌ 發生錯誤：{ex.Message}");
                return StatusCode(500, new { message = $"CreateOrder 錯誤：{ex.Message}" });
            }
        }


        private string GenerateMerchantTradeNo() {
            return $"T{DateTime.Now:yyyyMMddHHmmss}{Guid.NewGuid().ToString("N").Substring(0, 5)}";
        }

        //private string GetCheckMacValue(Dictionary<string, string> order) {
        //    var param = order.OrderBy(x => x.Key).Select(x => $"{x.Key}={x.Value}");
        //    var checkValue = $"HashKey={HashKey}&{string.Join("&", param)}&HashIV={HashIV}";
        //    checkValue = HttpUtility.UrlEncode(checkValue).ToLower();
        //    checkValue = GetSHA256(checkValue);
        //    return checkValue.ToUpper();
        //}
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
        //private string GetSHA256(string value) {
        //    var result = new StringBuilder();
        //    using (var sha256 = SHA256.Create()) {
        //        var bytes = Encoding.UTF8.GetBytes(value);
        //        var hash = sha256.ComputeHash(bytes);
        //        for (int i = 0; i < hash.Length; i++) {
        //            result.Append(hash[i].ToString("x2"));
        //        }
        //    }
        //    return result.ToString();
        //}
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

        [HttpPost("PaymentResult")]
        public async Task<IActionResult> PaymentResult([FromForm] Dictionary<string, string> formData) {
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

                using (var dbContext = new TravelLogContext()) {
                    var order = await dbContext.Orders.FirstOrDefaultAsync(o => o.MerchantTradeNo == merchantTradeNo);
                    if (order == null) {
                        return NotFound(new { message = "找不到對應的訂單" });
                    }

                    var payment = new Payment {
                        OrderId = order.OrderId,
                        PaymentTime = isSuccess ? DateTime.Now : null,
                        PaymentMethod = GetPaymentMethodId(paymentType),
                        PaymentStatusId = isSuccess ? 2 : 3,
                        EcpayTransactionId = ecpayTradeNo
                    };

                    dbContext.Payments.Add(payment);
                    order.OrderPaymentStatus = payment.PaymentStatusId;
                    await dbContext.SaveChangesAsync();
                }

                return Content("1|OK", "text/plain");
            }
            catch (Exception ex) {
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

        [HttpGet("GetOrder")]
        public async Task<IActionResult> GetOrder([FromQuery] string merchantTradeNo) {
            using (var dbContext = new TravelLogContext()) {
                var order = await dbContext.Orders
                    .Where(o => o.MerchantTradeNo == merchantTradeNo)
                    .Select(o => new {
                        o.OrderId,
                        o.MerchantTradeNo,
                        TradeDate = o.OrderTime.ToString("yyyy/MM/dd HH:mm:ss"),
                        o.OrderTotalAmount,
                        o.OrderPaymentStatus,
                        PaymentStatus = o.OrderPaymentStatusNavigation.PaymentStatus1,
                        PaymentInfo = dbContext.Payments
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
    }
}
