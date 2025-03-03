using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using TravelLogAPI.Services; // 假設 GmailServiceHelper 在此命名空間
using TravelLogAPI.DTOs;


namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly TravelLogContext _context;
        private readonly IConfiguration _configuration;
        private readonly ILogger<AccountController> _logger;

        public AccountController(TravelLogContext context, IConfiguration configuration, ILogger<AccountController> logger)
        {
            _context = context;
            _configuration = configuration;
            _logger = logger;
        }

        [HttpPost("ForgotPassword")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest(new { message = "Email 不可為空" });
            }

            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user != null)
            {
                string verificationCode = new Random().Next(100000, 1000000).ToString();
                DateTime now = DateTime.Now;

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

                // 生成重設密碼的前端連結（將驗證碼作為 token 參數傳遞）
                string resetLink = "";
                try
                {
                    resetLink = $"{Request.Scheme}://localhost:5173/reset-password?token={verificationCode}";
                    _logger.LogInformation("Manual reset link generated: {ResetLink}", resetLink);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to generate reset link for verification code: {VerificationCode}", verificationCode);
                    resetLink = "ERROR: Unable to generate reset link. Please contact support.";
                }

                string subject = "密碼重置通知";
                string body = $"<p>請點擊以下連結來重設您的密碼：</p><p><a href=\"{resetLink}\">{resetLink}</a></p><p>注意：此連結有效 1 小時。</p>";

                await GmailServiceHelper.SendEmailAsync(_configuration, user.UserEmail, "david39128332@gmail.com", subject, body);

            }
            return Ok(new { message = "如果該 Email 已註冊，我們將發送驗證碼。" });

        }


        [HttpGet("ResetPassword", Name = "ResetPasswordGet")]
        public async Task<IActionResult> ResetPassword([FromQuery] string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                return BadRequest(new { message = "無效的連結" });
            }

            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == token);
            if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
            {
                return BadRequest(new { message = "此連結已失效或不正確。" });
            }

            // 此處可回傳 token 供前端重設密碼表單使用
            return Ok(new { token = token });
        }

        [HttpPost("ResetPassword")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request)
        {
            try
            {
                // 1. 檢查新密碼與確認密碼是否一致
                if (request.NewPassword != request.ConfirmPassword)
                {
                    return BadRequest(new { message = "密碼與確認密碼不一致" });
                }

                // 2. 根據傳入的驗證碼（存放在 request.Token 中）查詢 UserPds 資料
                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == request.Token);
                if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
                {
                    return BadRequest(new { message = "此驗證碼已失效或不正確。" });
                }

                // 3. 取得對應的使用者資料
                var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userPd.UserId);
                if (user == null)
                {
                    return NotFound(new { message = "找不到使用者" });
                }

                // 4. 使用 PasswordHasher 產生新密碼的雜湊值並更新
                var passwordHasher = new PasswordHasher<User>();
                // 此處更新密碼雜湊儲存於 userPd 中（若你的設計是更新 User 本身的密碼，也可直接更新 user.PasswordHash）
                userPd.UserPdPasswordHash = passwordHasher.HashPassword(user, request.NewPassword);

                // 5. 清除驗證碼（改為空字串）
                userPd.UserPdToken = "";

                // 6. 儲存更改到資料庫
                await _context.SaveChangesAsync();

                // 7. 返回成功訊息
                return Ok(new { message = "密碼重置成功，請使用新密碼登入。" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting password for token: {Token}", request.Token);
                return StatusCode(500, new { message = "重設密碼失敗，請稍後再試。" });
            }
        }


        [HttpPost("ResendVerificationEmail")]
        public async Task<IActionResult> ResendVerificationEmail([FromBody] ResendVerificationRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest(new { message = "Email 不可為空" });
            }
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user == null)
            {
                return NotFound(new { message = "找不到使用者" });
            }
            if (user.IsEmailVerified)
            {
                return BadRequest(new { message = "您的 Email 已經驗證過了" });
            }

            // 重新產生驗證 token（例如 GUID 或六位數驗證碼）
            user.EmailVerificationToken = Guid.NewGuid().ToString(); // 或改用 new Random().Next(100000, 1000000).ToString();
            user.EmailVerificationSentDate = DateTime.Now;
            await _context.SaveChangesAsync();

            string verificationLink = $"{Request.Scheme}://localhost:5173/verify-email?token={user.EmailVerificationToken}";
            string subject = "Email 驗證通知";
            string body = $"<p>您好，請點擊以下連結以驗證您的 Email：</p>" +
                          $"<p><a href=\"{verificationLink}\">{verificationLink}</a></p>" +
                          $"<p>注意：此連結有效 1 小時。</p>";

            await GmailServiceHelper.SendEmailAsync(_configuration, user.UserEmail, "david39128332@gmail.com", subject, body);

            return Ok(new { message = "驗證信已重新寄出，請檢查您的信箱。" });
        }

        public class ResendVerificationRequest
        {
            public string Email { get; set; }
        }

        [HttpGet("VerifyEmail")]
        public async Task<IActionResult> VerifyEmail([FromQuery] string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                return BadRequest(new { message = "無效的驗證連結" });
            }

            var user = await _context.Users.FirstOrDefaultAsync(u => u.EmailVerificationToken == token);
            if (user == null)
            {
                return BadRequest(new { message = "驗證連結無效" });
            }

            if (user.EmailVerificationSentDate == null || user.EmailVerificationSentDate.Value.AddHours(1) < DateTime.Now)
            {
                return BadRequest(new { message = "驗證連結已過期" });
            }

            user.IsEmailVerified = true;
            user.EmailVerificationToken = null;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Email 驗證成功，您現在可以關閉此頁面。" });
        }



    }


    public class ResetPasswordRequest
    {
        public string Token { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
    }
}
