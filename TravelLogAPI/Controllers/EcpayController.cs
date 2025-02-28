using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Newtonsoft.Json.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

//using TravelLog.Models;
using TravelLogAPI.Models;

namespace TravelLogAPI.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("VueSinglePage")]
    public class EcpayController : Controller {

        private readonly TravelLogContext _dbContext;
        private readonly IMemoryCache _memoryCache;

        public EcpayController(TravelLogContext dbContext, IMemoryCache memoryCache) {
            _dbContext = dbContext;
            _memoryCache = memoryCache;
        }

        private readonly string HashKey = "5294y06JbISpM5x9";
        private readonly string HashIV = "v77hoKGq4kWxNNIS";
        private readonly string MerchantID = "2000132";
        // private readonly string ApiAddress = "https://localhost:7092"; // API server url
        private readonly string ApiAddress = "https://213f-2407-4b00-6c00-143c-99b3-23bf-5b0f-4984.ngrok-free.app"; // API server url
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
                        { "ReturnURL",  $"{ApiAddress}/api/Ecpay/PaymentResult"},
                        // { "OrderResultURL", $"{ApiAddress}/api/Ecpay/PaymentResult" },
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

        // 綠界付款通知
        // POST: /api/Ecpay/PaymentResult
        [HttpPost("PaymentResult")]
public async Task<IActionResult> PaymentResult([FromForm] IFormCollection formData) {
    Console.WriteLine("=== PaymentResult: 收到綠界的付款通知 ===");
    Console.WriteLine($"收到時間: {DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}");
    Console.WriteLine($"請求來源 IP: {HttpContext.Connection.RemoteIpAddress}");
    Console.WriteLine($"請求內容大小: {formData?.Count ?? 0} 個參數");

    if (formData == null || formData.Count == 0) {
        Console.WriteLine("錯誤：未收到請求內容！");
        return BadRequest(new { message = "未收到請求內容" });
    }

    var data = formData.Keys.ToDictionary(key => key, key => formData[key].ToString());

    foreach (var kvp in data) {
        Console.WriteLine($"  Key = {kvp.Key}, Value = {kvp.Value}");
    }

    try {
        // 直接等待處理完成
        await ProcessPaymentAsync(data);
        return Content("1|OK", "text/plain");
    }
    catch (Exception ex) {
        Console.WriteLine($"處理付款時發生錯誤：{ex.Message}");
        Console.WriteLine($"錯誤堆疊：{ex.StackTrace}");
        // 即使發生錯誤，仍然回傳 1|OK 給綠界
        return Content("1|OK", "text/plain");
    }
}

        // 背景處理付款 & 存儲到資料庫
        private async Task ProcessPaymentAsync(Dictionary<string, string> formData) {
    try {
        // 驗證 CheckMacValue
        if (!ValidateCheckMacValue(formData)) {
            Console.WriteLine("付款驗證失敗：CheckMacValue 不符");
            return;
        }

        // 檢查必要欄位
        if (!formData.TryGetValue("MerchantTradeNo", out var merchantTradeNo) ||
            !formData.TryGetValue("TradeNo", out var ecpayTradeNo) ||
            !formData.TryGetValue("RtnCode", out var paymentStatus) ||
            !formData.TryGetValue("PaymentType", out var paymentType)) {
            Console.WriteLine("缺少必要的參數");
            return;
        }

        bool isSuccess = paymentStatus == "1";
        Console.WriteLine($"付款狀態：{(isSuccess ? "成功" : "失敗")}");

            // 查詢訂單
            var order = await _dbContext.Orders
                .FirstOrDefaultAsync(o => o.MerchantTradeNo == merchantTradeNo);

            if (order == null) {
                Console.WriteLine($"找不到訂單：{merchantTradeNo}");
                return;
            }

            Console.WriteLine($"找到訂單：{order.OrderId}");

            // 建立付款記錄
            var payment = new Payment {
                OrderId = order.OrderId,
                PaymentTime = isSuccess ? DateTime.Now : null,
                PaymentMethod = GetPaymentMethodId(paymentType),
                PaymentStatusId = isSuccess ? 2 : 3,
                EcpayTransactionId = ecpayTradeNo
            };

            // 更新訂單付款狀態
            order.OrderPaymentStatus = isSuccess ? 2 : 1;
            order.OrderStatus = isSuccess ? 2 : 1;

            // 儲存到資料庫
            _dbContext.Payments.Add(payment);
            await _dbContext.SaveChangesAsync();

            Console.WriteLine($"付款記錄已保存，訂單號：{merchantTradeNo}, 狀態：{order.OrderPaymentStatus}");
    }
    catch (Exception ex) {
        Console.WriteLine($"處理付款結果時發生錯誤：{ex.Message}");
        Console.WriteLine($"錯誤堆疊：{ex.StackTrace}");
        throw; // 重新拋出異常以便上層捕獲
    }
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

        private bool ValidateCheckMacValue(Dictionary<string, string> formData) {
            if (!formData.TryGetValue("CheckMacValue", out var originalCheckMacValue)) {
                Console.WriteLine("CheckMacValue 不存在！");
                return false;
            }

            var validationDict = new Dictionary<string, string>(formData);
            validationDict.Remove("CheckMacValue");

            var sortedParams = validationDict
                .OrderBy(x => x.Key)
                .Select(x => $"{x.Key}={x.Value}")
                .ToList();

            var checkString = $"HashKey={HashKey}&{string.Join("&", sortedParams)}&HashIV={HashIV}";
            Console.WriteLine($"組合字串: {checkString}");

            var encoded = HttpUtility.UrlEncode(checkString).ToLower();
            Console.WriteLine($"UrlEncode 後: {encoded}");

            var calculated = GetSHA256(encoded).ToUpper();
            Console.WriteLine($"計算出的 CheckMacValue: {calculated}");
            Console.WriteLine($"綠界提供的 CheckMacValue: {originalCheckMacValue}");

            if (calculated != originalCheckMacValue) {
                Console.WriteLine("CheckMacValue 不一致，驗證失敗!");
                return false;
            }

            return true;
        }

        private int GetPaymentMethodId(string paymentType) {
            return paymentType switch {
                "Credit" => 1,
                "ATM" => 2,
                "CVS" => 3,
                _ => 4,
            };
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
