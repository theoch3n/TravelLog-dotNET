using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using TravelLog.Models;
using Microsoft.Extensions.Caching.Memory;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TravelLogAPI.DTO;
using Humanizer;

namespace TravelLogAPI.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("VueSinglePage")]
    public class EcpayController : Controller {
        private readonly TravelLogContext _dbContext;
        private readonly IMemoryCache _cache;
        public EcpayController(TravelLogContext dbContext, IMemoryCache cache) {
            _dbContext = dbContext;
            _cache = cache;
        }

        [HttpPost("Payment")]
        public IActionResult Payment([FromBody] OrderDto orderDto) {
            var order = orderDto.order;
            if (order == null || orderDto == null || order.OrderTotalAmount <= 0)
                return BadRequest(new { status = "error", message = "無效的訂單" });

            try {
                string orderId = Guid.NewGuid().ToString().Replace("-", "").Substring(0, 20);
                string apiAddress = $"https://localhost:7092";
                string vueAddress = $"https://localhost:5173";

                var orders = new Dictionary<string, string>
                {
                    { "MerchantTradeNo", orderId },
                    { "MerchantTradeDate", DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") },
                    { "TotalAmount", order.OrderTotalAmount.ToString() },
                    { "TradeDesc", "無" },
                    { "ItemName", orderDto.order?.OrderTotalAmount.ToString() ?? "測試商品#測試商品1" },
                    { "ExpireDate", "3" },
                    { "CustomField1", "" },
                    { "CustomField2", "" },
                    { "CustomField3", "" },
                    { "CustomField4", "" },
                    { "ReturnURL", $"{apiAddress}/api/Ecpay/AddPayInfo" },
                    { "OrderResultURL", $"{vueAddress}/paymentResult/{orderId}" },
                    { "PaymentInfoURL", $"{apiAddress}/api/Ecpay/AddAccountInfo" },
                    //{ "ClientRedirectURL", $"{vueAddress}/FrontHome/AccountInfo/{orderId}" },
                    { "MerchantID", "2000132" },
                    { "IgnorePayment", "GooglePay#WebATM#CVS#BARCODE" },
                    { "PaymentType", "aio" },
                    { "ChoosePayment", "ALL" },
                    { "EncryptType", "1" },
                };

                // 計算 CheckMacValue
                orders["CheckMacValue"] = GetCheckMacValue(orders);

                return Ok(orders);
            }
            catch (Exception ex) {
                return StatusCode(500, new { status = "error", message = ex.Message });
            }
        }

        private string GetCheckMacValue(Dictionary<string, string> order) {
            var param = order.Keys.OrderBy(x => x)
                .Select(key => $"{key}={order[key]}")
                .ToList();

            var checkValue = string.Join("&", param);

            var hashKey = "5294y06JbISpM5x9"; // 測試用 HashKey
            var hashIV = "v77hoKGq4kWxNNIS"; // 測試用 HashIV

            checkValue = $"HashKey={hashKey}&{checkValue}&HashIV={hashIV}";
            checkValue = HttpUtility.UrlEncode(checkValue).ToLower();

            using (var sha256 = SHA256.Create()) {
                var hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(checkValue));
                return string.Concat(hash.Select(b => b.ToString("X2")));
            }
        }

        private string GetSHA256(string value) {
            using (var sha256 = SHA256.Create()) {
                var result = new StringBuilder();
                var hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(value));
                foreach (byte b in hash) {
                    result.Append(b.ToString("X2"));
                }
                return result.ToString();
            }
        }


        // 建立訂單
        // POST: api/Ecpay/CreateOrder
        [HttpPost("CreateOrder")]
        public OrderDto CreateOrder([FromBody] OrderDto orderDto) {
            var order = orderDto.order;
            if (order == null || order.OrderTotalAmount <= 0)
                return BadRequest(new { status = "error", message = "無效的訂單" });

            try {
                string tradeNo = Guid.NewGuid().ToString("N").Substring(0, 20);
                var newOrder = new Order {
                    MerchantTradeNo = tradeNo,
                    OrderTime = order.OrderTime,
                    OrderTotalAmount = order.OrderTotalAmount,
                    UserId = order.UserId,
                    OrderStatus = 1,
                    OrderPaymentStatus = 1
                };

                _dbContext.Orders.Add(newOrder);
                _dbContext.SaveChanges();
                //return Ok(new { status = "success", message = "訂單建立成功", MerchantTradeNo = tradeNo });
                return newOrder;
            }
            catch (Exception ex) {
                return StatusCode(500, new { status = "error", message = ex.Message });
            }
        }

        // 綠界回傳付款結果 ( ReturnURL )
        // POST: api/Ecpay/PaymentReturn
        [HttpPost("PaymentReturn")]
        public IActionResult PaymentReturn([FromBody] JObject info) {
            try {
                string tradeNo = info.Value<string>("MerchantTradeNo");
                var order = _dbContext.Orders.FirstOrDefault(o => o.MerchantTradeNo == tradeNo);

                if (order != null) {
                    order.OrderPaymentStatus = 2; // 設為「已付款」

                    var payment = _dbContext.Payments.FirstOrDefault(p => p.OrderId == order.OrderId);
                    if (payment != null) {
                        payment.PaymentTime = DateTime.UtcNow;
                        payment.PaymentStatusId = 2; // 設為「已付款」
                        payment.PaymentMethodName = info.Value<string>("ChoosePayment"); // 儲存綠界回傳的付款方式
                    }

                    _dbContext.SaveChanges();
                    return Ok(new { status = "success", message = "付款資訊已更新" });
                }

                return NotFound(new { status = "error", message = "找不到訂單" });
            }
            catch (Exception ex) {
                return StatusCode(500, new { status = "error", message = ex.Message });
            }
        }

        // 取得單筆訂單資訊
        // POST: api/Ecpay/GetOrderInfo/{tradeNo}
        [HttpGet("GetOrderInfo/{tradeNo}")]
        public IActionResult GetOrderInfo(string tradeNo) {
            var order = _dbContext.Orders.FirstOrDefault(o => o.MerchantTradeNo == tradeNo);

            if (order == null)
                return NotFound(new { status = "error", message = "找不到該筆訂單" });

            return Ok(order);
        }

        // 取得所有訂單資訊
        // POST: api/Ecpay/PaymentReturn
        [HttpGet("GetAllOrders")]
        public IActionResult GetAllOrders() {
            var orders = _dbContext.Orders.ToList();
            return Ok(orders);
        }

        // 接收綠界的付款資訊回傳 (模擬付款用)
        // POST: api/Ecpay/PaymentReturn
        [HttpPost("AddPayInfo")]
        public IActionResult AddPayInfo([FromBody] JObject info) {
            try {
                string tradeNo = info.Value<string>("MerchantTradeNo");
                if (string.IsNullOrEmpty(tradeNo))
                    return ResponseError();

                _cache.Set(tradeNo, info, TimeSpan.FromMinutes(60));
                return ResponseOK();
            }
            catch (Exception) {
                return ResponseError();
            }
        }

        // 接收綠界的虛擬帳號付款資訊 (模擬付款用)
        // POST: api/Ecpay/PaymentReturn
        [HttpPost("AddAccountInfo")]
        public IActionResult AddAccountInfo([FromBody] JObject info) {
            try {
                string tradeNo = info.Value<string>("MerchantTradeNo");
                if (string.IsNullOrEmpty(tradeNo))
                    return ResponseError();

                _cache.Set(tradeNo, info, TimeSpan.FromMinutes(60));
                return ResponseOK();
            }
            catch (Exception) {
                return ResponseError();
            }
        }

        // 綠界金流回傳的標準 Response (失敗)
        // POST: api/Ecpay/PaymentReturn
        private IActionResult ResponseError() {
            return Content("0|Error", "text/html");
        }

        // 綠界金流回傳的標準 Response (成功)
        // POST: api/Ecpay/PaymentReturn
        private IActionResult ResponseOK() {
            return Content("1|OK", "text/html");
        }
    }
}
