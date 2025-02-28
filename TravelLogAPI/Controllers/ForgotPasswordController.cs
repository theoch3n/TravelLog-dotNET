using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using Microsoft.Extensions.Configuration;
using TravelLogAPI.Services;
using TravelLogAPI.DTOs;


namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ForgotPasswordController : ControllerBase
    {
        private readonly TravelLogContext _context;
        private readonly IConfiguration _configuration;

        public ForgotPasswordController(TravelLogContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        // POST: api/ForgotPassword
        // 此端點負責寄送六位數驗證碼 (你已經有的程式碼)
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ForgotPasswordRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest(new { message = "Email 不可為空" });
            }

            // 根據 Email 查詢使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user != null)
            {
                // 生成六位數驗證碼
                string verificationCode = new Random().Next(100000, 1000000).ToString();
                DateTime now = DateTime.Now;

                // 取得或建立使用者密碼相關記錄 (存放在 UserPds 表)
                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
                if (userPd == null)
                {
                    userPd = new UserPd
                    {
                        UserId = user.UserId,
                        UserPdToken = verificationCode,
                        UserPdCreateDate = now,
                        TokenCreateDate = now,
                        UserPdPasswordHash = ""
                    };
                    _context.UserPds.Add(userPd);
                }
                else
                {
                    userPd.UserPdToken = verificationCode;
                    userPd.UserPdCreateDate = now;
                    userPd.TokenCreateDate = now;
                }
                await _context.SaveChangesAsync();

                // 組成 email 內容，這裡直接顯示驗證碼
                string subject = "密碼重置驗證碼";
                string body = $"您的驗證碼是：{verificationCode}\n注意：此驗證碼有效 1 小時。";

                // 呼叫 Gmail API 發送 email (GmailServiceHelper 這邊維持不變)
                await GmailServiceHelper.SendEmailAsync(_configuration, user.UserEmail, "david39128332@gmail.com", subject, body);
            }
            // 統一回覆訊息，避免洩漏使用者是否存在的資訊
            return Ok(new { message = "如果該 Email 已註冊，我們將發送驗證碼。" });
        }

        // 新增一個 API 端點來驗證使用者輸入的驗證碼
        // POST: api/ForgotPassword/ValidateCode
        [HttpPost("ValidateCode")]
        public async Task<IActionResult> ValidateCode([FromBody] VerificationCodeRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.VerificationCode))
            {
                return BadRequest(new { message = "Email 與驗證碼都必須提供。" });
            }

            // 依據 Email 找到使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user == null)
            {
                return NotFound(new { message = "找不到使用者。" });
            }

            // 根據使用者 ID 查詢 UserPds 中的記錄
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
            if (userPd == null)
            {
                return BadRequest(new { message = "請先發送驗證碼。" });
            }

            // 檢查驗證碼是否正確且在有效期內
            if (userPd.UserPdToken != request.VerificationCode || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
            {
                return BadRequest(new { message = "驗證碼錯誤或已過期。" });
            }

            // 驗證成功後，可以選擇返回一個新的 token（例如可以用來進行重設密碼），或直接返回成功訊息。
            // 這裡我們直接返回成功訊息。
            return Ok(new { message = "驗證成功，請繼續進行密碼重置。" });
        }
    }


    public class VerificationCodeRequest
    {
        public string Email { get; set; }
        public string VerificationCode { get; set; }
    }
}
