using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using TravelLogAPI.Models;
using TravelLogAPI.Helpers;

namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly TravelLogContext _context;
        private readonly PasswordHasher<User> _passwordHasher;

        public AccountController(TravelLogContext context)
        {
            _context = context;
            _passwordHasher = new PasswordHasher<User>();
        }

        // POST: api/Account/ForgotPassword
        [HttpPost("ForgotPassword")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest(new { message = "Email 不可為空" });
            }

            // 根據 Email 查詢使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user != null)
            {
                // 產生 token 與記錄建立時間
                string token = Guid.NewGuid().ToString();
                DateTime now = DateTime.Now;

                // 取得或建立使用者密碼相關記錄 (存放在 UserPds 表)
                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
                if (userPd == null)
                {
                    userPd = new UserPd
                    {
                        UserId = user.UserId,
                        UserPdToken = token,
                        UserPdCreateDate = now,
                        TokenCreateDate = now,
                        UserPdPasswordHash = "" // 初始保持空字串
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

                // 組成重設密碼連結，假設 ResetPassword 動作會處理重設密碼（可回傳前端供顯示提示）
                string resetLink = Url.Action("ResetPassword", "Account", new { token = token }, Request.Scheme);
                string subject = "密碼重置通知";
                string body = $"請點擊以下連結來重設您的密碼：{resetLink}\n此連結有效 1 小時。";

                // 呼叫 Gmail API 發送郵件
                GmailServiceHelper.SendEmail(user.UserEmail, subject, body);
            }

            // 統一回覆訊息，避免洩漏使用者資訊
            return Ok(new { message = "如果該 Email 已註冊，我們將發送重置連結。" });
        }

        // GET: api/Account/ResetPassword?token=xxx
        [HttpGet("ResetPassword")]
        public async Task<IActionResult> ResetPassword([FromQuery] string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                return BadRequest(new { message = "無效的連結" });
            }

            // 根據 token 查詢 UserPd 記錄，並檢查是否在 1 小時內有效
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == token);
            if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
            {
                return BadRequest(new { message = "此連結已失效或不正確。" });
            }

            // 將 token 回傳給前端，前端可利用此 token 進行重設密碼動作
            return Ok(new { token = token });
        }

        // POST: api/Account/ResetPassword
        [HttpPost("ResetPassword")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request)
        {
            if (request.NewPassword != request.ConfirmPassword)
            {
                return BadRequest(new { message = "密碼與確認密碼不一致" });
            }

            // 根據 token 查詢使用者密碼記錄
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == request.Token);
            if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
            {
                return BadRequest(new { message = "此連結已失效或不正確。" });
            }

            // 根據 UserId 取得使用者資訊
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userPd.UserId);
            if (user == null)
            {
                return NotFound(new { message = "找不到使用者" });
            }

            // 使用 PasswordHasher 加密新密碼並更新
            userPd.UserPdPasswordHash = _passwordHasher.HashPassword(user, request.NewPassword);
            // 清除 token 以防重複使用
            userPd.UserPdToken = null;
            await _context.SaveChangesAsync();

            return Ok(new { message = "密碼重置成功，請使用新密碼登入。" });
        }
    }

    // 忘記密碼請求資料傳輸物件
    public class ForgotPasswordRequest
    {
        public string Email { get; set; }
    }

    // 重設密碼請求資料傳輸物件
    public class ResetPasswordRequest
    {
        public string Token { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
    }
}
