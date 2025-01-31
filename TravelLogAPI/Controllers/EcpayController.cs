using System.Collections.Generic;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;

namespace TravelLogAPI.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("AllowVueApp")]
    public class EcpayController : Controller {

        private readonly string HashKey = "5294y06JbISpM5x9";
        private readonly string HashIV = "v77hoKGq4kWxNNIS";
        private readonly string MerchantID = "2000132";
        private readonly string Website = "https://localhost:7276"; // API server url

        [HttpPost("CreateOrder")]
        public IActionResult CreateOrder([FromBody] OrderRequest request) {
            try {
                string merchantID = "2000132"; // 固定商店代號
                var orderId = Guid.NewGuid().ToString().Replace("-", "").Substring(0, 20);
                var order = new Dictionary<string, string>
                {
            { "MerchantTradeNo", orderId },
            { "MerchantTradeDate", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") },
            { "TotalAmount", request.TotalAmount.ToString() },
            { "TradeDesc", HttpUtility.UrlEncode(request.TradeDesc ?? "測試交易") },
            { "ItemName", request.ItemName },
            { "MerchantID", merchantID },

            // 新增這些必要參數
            { "ReturnURL", "https://localhost:7276/Home/PaymentReturn" },
            { "PaymentType", "aio" }, // 一站式付款
            { "ChoosePayment", "ALL" }, // 允許所有支付方式
            { "EncryptType", "1" }, // 加密類型
            { "ClientBackURL", "https://localhost:5174/payment" }, // 返回商店的網址
            { "OrderResultURL", "https://localhost:5174/payment?step=3" }, // 交易結果返回網址
        };

                order["CheckMacValue"] = GetCheckMacValue(order);

                var formHtml = GenerateEcpayForm(order);

                return Ok(new {
                    orderId = orderId,
                    formHtml = formHtml
                });
            }
            catch (Exception ex) {
                return BadRequest(new { message = ex.Message });
            }
        }


        private string GenerateEcpayForm(Dictionary<string, string> order) {
            var formBuilder = new StringBuilder();
            formBuilder.Append("<form id='ecpay-form' action='https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5' method='post'>");

            foreach (var item in order) {
                formBuilder.Append($"<input type='hidden' name='{item.Key}' value='{item.Value}' />");
            }

            formBuilder.Append("</form>");
            return formBuilder.ToString();
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

    }

    public class OrderRequest {
        public decimal TotalAmount { get; set; }
        public string ItemName { get; set; }
        public string TradeDesc { get; set; }
        public string MerchantID { get; set; } // 新增此欄位
    }
}
