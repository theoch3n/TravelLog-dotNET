using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using TravelLogAPI.Models;
using TravelLogAPI.Helpers;


namespace TravelLogAPI.Controllers
{
    public class AccountController : Controller
    {
        private readonly TravelLogContext _context;
        private readonly PasswordHasher<User> _passwordHasher;

        public AccountController(TravelLogContext context)
        {
            _context = context;
            _passwordHasher = new PasswordHasher<User>();
        }

        // GET: /Account/ForgotPassword
        [HttpGet]
        public IActionResult ForgotPassword()
        {
            return View();
        }

        // POST: /Account/ForgotPassword
        [HttpPost]
        public async Task<IActionResult> ForgotPassword(string email)
        {
            // 依 Email 查詢使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == email);
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
                        UserPdPasswordHash = "" // 先保持空字串
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

                // 組成重設密碼連結，假設 ResetPassword 動作會處理重設頁面
                string resetLink = Url.Action("ResetPassword", "Account", new { token = token }, Request.Scheme);
                string subject = "密碼重置通知";
                string body = $"請點擊以下連結來重設您的密碼：{resetLink}\n此連結有效 1 小時。";

                // 呼叫 Gmail API 發送郵件
                GmailServiceHelper.SendEmail(user.UserEmail, subject, body);
            }

            // 統一回覆訊息，避免洩漏使用者資訊
            ViewBag.Message = "如果該 Email 已註冊，我們將發送重置連結。";
            return View();
        }

        // GET: /Account/ResetPassword?token=xxx
        [HttpGet]
        public async Task<IActionResult> ResetPassword(string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                ViewBag.Error = "無效的連結";
                return View("Error");
            }

            // 根據 token 查詢 UserPd 記錄，並檢查是否在 1 小時內
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == token);
            if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
            {
                ViewBag.Error = "此連結已失效或不正確。";
                return View("Error");
            }

            ViewBag.Token = token;
            return View();
        }

        // POST: /Account/ResetPassword
        [HttpPost]
        public async Task<IActionResult> ResetPassword(string token, string newPassword, string confirmPassword)
        {
            if (newPassword != confirmPassword)
            {
                ViewBag.Error = "密碼與確認密碼不一致";
                ViewBag.Token = token;
                return View();
            }

            // 根據 token 查詢使用者密碼記錄
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserPdToken == token);
            if (userPd == null || userPd.TokenCreateDate.AddHours(1) < DateTime.Now)
            {
                ViewBag.Error = "此連結已失效或不正確。";
                return View("Error");
            }

            // 根據 UserId 取得使用者資訊
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userPd.UserId);
            if (user == null)
            {
                ViewBag.Error = "找不到使用者";
                return View("Error");
            }

            // 使用 PasswordHasher 加密新密碼並更新
            userPd.UserPdPasswordHash = _passwordHasher.HashPassword(user, newPassword);
            // 清除 token 以防重複使用
            userPd.UserPdToken = null;
            await _context.SaveChangesAsync();

            ViewBag.Message = "密碼重置成功，請使用新密碼登入。";
            return View("Success");
        }
    }
}
