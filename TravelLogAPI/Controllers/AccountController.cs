using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using TravelLogAPI.Services; // 假設 GmailServiceHelper 在此命名空間

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
                string token = Guid.NewGuid().ToString();
                DateTime now = DateTime.Now;

                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
                if (userPd == null)
                {
                    userPd = new UserPd
                    {
                        UserId = user.UserId,
                        UserPdToken = token,
                        UserPdCreateDate = now,
                        TokenCreateDate = now,
                        UserPdPasswordHash = ""
                    };
                    _context.UserPds.Add(userPd);
                }
                else
                {
                    userPd.UserPdToken = token;
                    userPd.UserPdCreateDate = now;
                    userPd.TokenCreateDate = now;
                }
                await _context.SaveChangesAsync();

                string resetLink = "";
                try
                {
                    // 這裡將重設連結直接指向前端 URL (例如 Vue 應用中的 /reset-password 路由)
                    resetLink = $"{Request.Scheme}://localhost:5173/reset-password?token={token}";
                    _logger.LogInformation("Manual reset link generated: {ResetLink}", resetLink);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to generate reset link for token: {Token}", token);
                    resetLink = "ERROR: Unable to generate reset link. Please contact support.";
                }

                string subject = "密碼重置通知";
                // 使用 HTML 格式包裝連結
                string body = $"<p>請點擊以下連結來重設您的密碼：</p><p><a href=\"{resetLink}\">{resetLink}</a></p><p>注意：此連結有效 1 小時。</p>";

                await GmailServiceHelper.SendEmailAsync(_configuration, user.UserEmail, "david39128332@gmail.com", subject, body);
            }

            return Ok(new { message = "如果該 Email 已註冊，我們將發送重置連結。" });
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
                if (request.NewPassword != request.ConfirmPassword)
                {
                    return BadRequest(new { message = "密碼與確認密碼不一致" });
                }

                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == request.Token);
                if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
                {
                    return BadRequest(new { message = "此連結已失效或不正確。" });
                }

                var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userPd.UserId);
                if (user == null)
                {
                    return NotFound(new { message = "找不到使用者" });
                }

                var passwordHasher = new PasswordHasher<User>();
                userPd.UserPdPasswordHash = passwordHasher.HashPassword(user, request.NewPassword);
                userPd.UserPdToken = "";
                await _context.SaveChangesAsync();

                return Ok(new { message = "密碼重置成功，請使用新密碼登入。" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting password for token: {Token}", request.Token);
                return StatusCode(500, new { message = "重設密碼失敗，請稍後再試。" });
            }
        }
        

    }

    public class ForgotPasswordRequest
    {
        public string Email { get; set; }
    }

    public class ResetPasswordRequest
    {
        public string Token { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
    }
}
