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
                    _logger.LogInformation("Request.Scheme: {Scheme}, Request.Host: {Host}", Request.Scheme, Request.Host);
                    resetLink = Url.Action("ResetPasswordGet", "Account", new { token = token }, Request.Scheme);
                    if (string.IsNullOrEmpty(resetLink))
                    {
                        _logger.LogWarning("Url.Action returned null, falling back to manual URL generation.");
                        resetLink = $"{Request.Scheme}://{Request.Host}/api/Account/ResetPassword?token={token}";
                    }
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



        // 為 GET ResetPassword 動作加上命名路由，避免歧義
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

            return Ok(new { token = token });
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
