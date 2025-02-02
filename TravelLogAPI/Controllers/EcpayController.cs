using System.Collections.Generic;
using System.Diagnostics;
using System.Dynamic;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace TravelLogAPI.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("AllowVueApp")]
    public class EcpayController : Controller {

        private readonly string HashKey = "5294y06JbISpM5x9";
        private readonly string HashIV = "v77hoKGq4kWxNNIS";
        private readonly string MerchantID = "2000132";
        private readonly string Website = "https://localhost:7092"; // API server url

        [HttpPost("CreateOrder")]
        public IActionResult CreateOrder([FromBody] OrderRequest request) {
            try {
                var orderId = Guid.NewGuid().ToString().Replace("-", "").Substring(0, 20);
                var order = new Dictionary<string, string>
                {
            { "MerchantTradeNo", orderId },
            { "MerchantTradeDate", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") },
            { "TotalAmount", request.TotalAmount.ToString() },
            { "TradeDesc", HttpUtility.UrlEncode(request.TradeDesc ?? "測試交易") },
            { "ItemName", request.ItemName },
            { "MerchantID", MerchantID },
            { "PaymentType", "aio" }, // 一站式付款
            { "ChoosePayment", "ALL" }, // 允許所有支付方式
            { "EncryptType", "1" }, // 加密類型
            { "ReturnURL", "https://localhost:7092/Ecpay/PaymentResult" },
            { "ClientBackURL", "https://localhost:5173/payment" }, // 返回商店的網址
            { "OrderResultURL", "https://localhost:5173/payment" }, // 交易結果返回網址
        };

                order["CheckMacValue"] = GetCheckMacValue(order);

                //var formHtml = GenerateEcpayForm(order);

                return Ok(new {
                    orderId = orderId,
                    //formHtml = formHtml
                    orderParams = order
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

        [HttpPost("PaymentResult")]
        public IActionResult PaymentResult([FromForm] Dictionary<string, string> formData) {
            try {
                // 驗證 CheckMacValue
                if (!ValidateCheckMacValue(formData)) {
                    return BadRequest(new { message = "付款驗證失敗" });
                }

                // 解析付款狀態
                string paymentStatus = formData.ContainsKey("RtnCode") ? formData["RtnCode"] : "";
                string tradeNo = formData.ContainsKey("MerchantTradeNo") ? formData["MerchantTradeNo"] : "";
                string ecpayTradeNo = formData.ContainsKey("TradeNo") ? formData["TradeNo"] : "";

                // 根據付款狀態處理
                switch (paymentStatus) {
                    case "1": // 付款成功
                              // TODO: 更新訂單狀態為已付款
                              // 可以在這裡呼叫服務層進行訂單狀態更新
                        break;
                    case "10100073": // ATM 轉帳已完成
                        break;
                    default:
                        // 其他狀態，可能需要特別處理
                        break;
                }

                // 回傳 "1|OK" 告知 ECPay 已成功接收
                return Content("1|OK", "text/plain");
            }
            catch (Exception ex) {
                // 記錄錯誤
                return BadRequest(new { message = ex.Message });
            }
        }

        private bool ValidateCheckMacValue(Dictionary<string, string> formData) {
            // 複製一份 formData 以進行驗證
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
        //public string MerchantID { get; set; }
    }
}
