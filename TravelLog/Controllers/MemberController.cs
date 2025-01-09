using Microsoft.AspNetCore.Mvc;
using TravelLog.Models;
using System.Linq;
using System.Security.Cryptography;
using System.Text;


namespace TravelLog.Controllers
{
    public class MemberController : Controller
    {
        private readonly TravelLogContext _context;

        public MemberController(TravelLogContext context)
        {
            _context = context;
        }

        // 顯示註冊頁面
        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        // 處理註冊請求
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Register(MemberInformation member, string confirmPassword)
        {
            if (member.MiPasswordHash != confirmPassword)
            {
                ModelState.AddModelError("PasswordMismatch", "Password and Confirm Password do not match.");
                return View(member);
            }

            // 驗證 Email 是否唯一
            if (_context.MemberInformations.Any(m => m.MiEmail == member.MiEmail))
            {
                ModelState.AddModelError("EmailExists", "This email is already registered.");
                return View(member);
            }

            if (ModelState.IsValid)
            {
                try
                {
                    // 設置默認值
                    member.MiPasswordHash = HashPassword(member.MiPasswordHash); // 密碼加密
                    member.MiRegistrationDate = DateTime.Now; // 註冊日期
                    member.MiIsActive = false; // 默認"不"啟用

                    // 新增會員
                    _context.MemberInformations.Add(member);
                    _context.SaveChanges();

                    // 註冊成功提示
                    TempData["SuccessMessage"] = "Registration successful! You can now log in.";
                    return RedirectToAction("Login");
                }
                catch (Exception ex)
                {
                    // 處理異常
                    ModelState.AddModelError("DatabaseError", "An error occurred while processing your request.");
                    Console.WriteLine(ex.Message); // 日誌記錄
                }
            }

            // 返回包含錯誤的表單
            return View(member);
        }

        // 顯示登入頁面
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        // 處理登入請求
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Login(string MiEmail, string MiPassword)
        {
            // 檢查輸入字段
            if (string.IsNullOrEmpty(MiEmail) || string.IsNullOrEmpty(MiPassword))
            {
                ModelState.AddModelError("EmptyFields", "Email and Password are required.");
                return View();
            }

            // 驗證用戶憑據
            var hashedPassword = HashPassword(MiPassword);
            var member = _context.MemberInformations
                .FirstOrDefault(m => m.MiEmail == MiEmail && m.MiPasswordHash == hashedPassword && m.MiIsActive == true);

            if (member == null)
            {
                ModelState.AddModelError("InvalidCredentials", "Invalid email or password.");
                return View();
            }

            // 登入成功，設置 Session
            HttpContext.Session.SetString("UserId", member.MiMemberId.ToString());
            HttpContext.Session.SetString("UserName", member.MiAccountName);

            // 重定向至 Profile 頁面
            return RedirectToAction("Profile");
        }

        // 顯示用戶資料頁面
        [HttpGet]
        public IActionResult Profile()
        {
            if (!HttpContext.Session.TryGetValue("UserId", out var userIdBytes))
            {
                return RedirectToAction("Login");
            }

            var userId = int.Parse(Encoding.UTF8.GetString(userIdBytes));
            var member = _context.MemberInformations.FirstOrDefault(m => m.MiMemberId == userId);

            if (member == null)
            {
                return RedirectToAction("Login");
            }

            return View(member);
        }

        // 密碼加密方法
        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                var bytes = Encoding.UTF8.GetBytes(password);
                var hash = sha256.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }
        // 顯示重設密碼請求頁面
        [HttpGet]
        public IActionResult ResetPasswordRequest()
        {
            return View();
        }

        // 處理重設密碼請求
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ResetPasswordRequest(string email)
        {
            // 檢查 Email 是否存在
            var member = _context.MemberInformations.FirstOrDefault(m => m.MiEmail == email);
            if (member == null)
            {
                TempData["ErrorMessage"] = "No account is associated with this email.";
                return View();
            }

            // 生成唯一的 Token，並保存到模型中
            var resetToken = Guid.NewGuid().ToString();
            member.MiEmailConfirmationToken = resetToken;
            _context.SaveChanges();

            // 將 Email 和 Token 存入 Session
            HttpContext.Session.SetString("Email", email);
            HttpContext.Session.SetString("Token", resetToken);

            TempData["SuccessMessage"] = "A password reset link has been sent to your email.";
            return RedirectToAction("ResetPassword");
        }

        // 顯示重設密碼頁面
        [HttpGet]
        public IActionResult ResetPassword()
        {
            // 從 Session 中檢索 Email 和 Token
            string email = HttpContext.Session.GetString("Email");
            string token = HttpContext.Session.GetString("Token");

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(token))
            {
                TempData["ErrorMessage"] = "Reset password link is invalid or expired.";
                return RedirectToAction("ResetPasswordRequest");
            }

            // 驗證 Email 和 Token 是否有效
            var member = _context.MemberInformations
                .FirstOrDefault(m => m.MiEmail == email && m.MiEmailConfirmationToken == token);

            if (member == null)
            {
                TempData["ErrorMessage"] = "Invalid or expired password reset link.";
                return RedirectToAction("ResetPasswordRequest");
            }

            return View(member);
        }

        // 處理重設密碼提交
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ResetPassword(MemberInformation member, string newPassword, string confirmPassword)
        {
            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 6)
            {
                ModelState.AddModelError("InvalidPassword", "Password must be at least 6 characters long.");
                return View(member);
            }

            if (newPassword != confirmPassword)
            {
                ModelState.AddModelError("PasswordMismatch", "New Password and Confirm Password do not match.");
                return View(member);
            }

            var existingMember = _context.MemberInformations
                .FirstOrDefault(m => m.MiEmail == member.MiEmail && m.MiEmailConfirmationToken == member.MiEmailConfirmationToken);

            if (existingMember == null)
            {
                TempData["ErrorMessage"] = "Invalid or expired password reset link.";
                return RedirectToAction("ResetPasswordRequest");
            }

            // 更新密碼並清除 Token
            existingMember.MiPasswordHash = HashPassword(newPassword);
            existingMember.MiEmailConfirmationToken = null;
            _context.SaveChanges();

            // 設置成功消息並重導向
            TempData["SuccessMessage"] = "Your password has been reset successfully.";
            return RedirectToAction("Login");
        }
    }
}