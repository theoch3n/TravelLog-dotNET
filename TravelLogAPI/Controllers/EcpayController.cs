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
    [EnableCors("AllowVueApp")]
    public class EcpayController : Controller {

        private readonly string HashKey = "5294y06JbISpM5x9";
        private readonly string HashIV = "v77hoKGq4kWxNNIS";
        private readonly string MerchantID = "2000132";
        private readonly string ApiAddress = "https://localhost:7092"; // API server url
        private readonly string VueAddress = "https://localhost:5173"; // Vue url

        // 產生訂單
        // POST: Ecpay/CreateOrder
        [HttpPost("CreateOrder")]
        public async Task<IActionResult> CreateOrder([FromBody] OrderRequest request) {
            try {
                using (var dbContext = new TravelLogContext()) {
                    var merchantTradeNo = GenerateMerchantTradeNo(); // 產生 MerchantTradeNo

                    // 建立訂單
                    var newOrder = new Order {
                        OrderTime = DateTime.Now,
                        OrderTotalAmount = request.TotalAmount,
                        UserId = 1, // TODO: 要改成從前端傳入的 UserId
                        //UserId = request.UserId, // 前端傳入的 UserId
                        OrderStatus = 1, // 1 = 進行中
                        OrderPaymentStatus = 1, // 1 = 未付款
                        MerchantTradeNo = merchantTradeNo
                    };

                    dbContext.Orders.Add(newOrder);
                    await dbContext.SaveChangesAsync();

                    var orderParams = new Dictionary<string, string>
                    {
                        { "MerchantTradeNo", newOrder.MerchantTradeNo },
                        { "MerchantTradeDate", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") },
                        { "TotalAmount", request.TotalAmount.ToString() },
                        { "TradeDesc", HttpUtility.UrlEncode(request.TradeDesc ?? "測試交易") },
                        { "ItemName", request.ItemName },
                        { "MerchantID", MerchantID },
                        { "PaymentType", "aio" },
                        { "ChoosePayment", "ALL" },
                        { "EncryptType", "1" },
                        { "ReturnURL", $"{ApiAddress}/Ecpay/PaymentResult" },
                        { "ClientBackURL", $"{VueAddress}/payment?MerchantTradeNo={newOrder.MerchantTradeNo}" },
                        { "OrderResultURL", $"{VueAddress}/payment?MerchantTradeNo={newOrder.MerchantTradeNo}" }
                    };

                    orderParams["CheckMacValue"] = GetCheckMacValue(orderParams);

                    return Ok(new {
                        orderId = newOrder.OrderId,
                        merchantTradeNo = newOrder.MerchantTradeNo,
                        orderParams = orderParams
                    });
                }
            }
            catch (Exception ex) {
                return BadRequest(new { message = ex.Message });
            }
        }

        // 產生唯一的 MerchantTradeNo
        private string GenerateMerchantTradeNo() {
            return $"T{DateTime.Now:yyyyMMddHHmmss}{Guid.NewGuid().ToString("N").Substring(0, 6)}";
        }


        private string GetCheckMacValue(Dictionary<string, string> order) {
            var param = order.OrderBy(x => x.Key).Select(x => $"{x.Key}={x.Value}");
            var checkValue = $"HashKey={HashKey}&{string.Join("&", param)}&HashIV={HashIV}";
            checkValue = HttpUtility.UrlEncode(checkValue).ToLower();
            checkValue = GetSHA256(checkValue);
            return checkValue.ToUpper();
        }

        private string GetSHA256(string value) {
            var result = new StringBuilder();
            using (var sha256 = SHA256.Create()) {
                var bytes = Encoding.UTF8.GetBytes(value);
                var hash = sha256.ComputeHash(bytes);
                for (int i = 0; i < hash.Length; i++) {
                    result.Append(hash[i].ToString("x2"));
                }
            }
            return result.ToString();
        }

        // 付款結果
        // POST: Ecpay/PaymentResult
        [HttpPost("PaymentResult")]
        public async Task<IActionResult> PaymentResult([FromForm] Dictionary<string, string> formData) {
            try {
                if (!ValidateCheckMacValue(formData)) {
                    return BadRequest(new { message = "付款驗證失敗" });
                }

                string merchantTradeNo = formData["MerchantTradeNo"];
                string ecpayTradeNo = formData["TradeNo"];
                string paymentStatus = formData["RtnCode"];
                string paymentType = formData.ContainsKey("PaymentType") ? formData["PaymentType"] : "未知";

                using (var dbContext = new TravelLogContext()) {
                    var order = await dbContext.Orders.FirstOrDefaultAsync(o => o.MerchantTradeNo == merchantTradeNo);
                    if (order == null) {
                        return NotFound(new { message = "找不到對應的訂單" });
                    }

                    // 記錄付款資訊
                    var payment = new Payment {
                        OrderId = order.OrderId,
                        PaymentTime = (paymentStatus == "1") ? DateTime.Now : (DateTime?)null,
                        PaymentMethod = GetPaymentMethodId(paymentType),
                        PaymentStatusId = (paymentStatus == "1") ? 2 : 3,
                        EcpayTransactionId = ecpayTradeNo
                    };

                    dbContext.Payments.Add(payment);

                    // 更新訂單付款狀態
                    order.OrderPaymentStatus = payment.PaymentStatusId;
                    await dbContext.SaveChangesAsync();
                }

                return Content("1|OK", "text/plain");
            }
            catch (Exception ex) {
                return BadRequest(new { message = ex.Message });
            }
        }

        // 取得付款方式 ID
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

        // 取得訂單資訊
        // GET: Ecpay/GetOrder
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
                        PaymentStatus = o.OrderPaymentStatusNavigation.PsPaymentStatus,
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
            // 複製一份 formData 進行驗證
            var validationDict = new Dictionary<string, string>(formData);

            // 移除 CheckMacValue 進行驗證
            string receivedCheckMacValue = validationDict["CheckMacValue"];
            validationDict.Remove("CheckMacValue");

            // 重新計算 CheckMacValue
            var calculatedCheckMacValue = GetCheckMacValue(validationDict);

            // 比較是否相同
            return calculatedCheckMacValue == receivedCheckMacValue;
        }
    }

    public class OrderRequest {
        public decimal TotalAmount { get; set; }
        public string ItemName { get; set; }
        public string TradeDesc { get; set; }
        public int UserId { get; set; }
    }

}
