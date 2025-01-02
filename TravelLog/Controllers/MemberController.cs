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
            // 確認密碼是否匹配
            if (member.MiPasswordHash != confirmPassword)
            {
                ModelState.AddModelError("PasswordMismatch", "Password and Confirm Password do not match.");
            }

            // 驗證 Email 是否唯一
            if (_context.MemberInformations.Any(m => m.MiEmail == member.MiEmail))
            {
                ModelState.AddModelError("EmailExists", "This email is already registered.");
            }

            if (ModelState.IsValid)
            {
                // 將密碼加密
                member.MiPasswordHash = HashPassword(member.MiPasswordHash);

                // 新增會員
                _context.MemberInformations.Add(member);
                _context.SaveChanges();

                TempData["SuccessMessage"] = "Registration successful!";
                return RedirectToAction("Login");
            }

            return View(member);
        }
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        // 處理登入請求
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Login(string email, string password)
        {
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ModelState.AddModelError("EmptyFields", "Email and Password are required.");
                return View();
            }

            var hashedPassword = HashPassword(password);
            var member = _context.MemberInformations
                .FirstOrDefault(m => m.MiEmail == email && m.MiPasswordHash == hashedPassword);

            if (member == null)
            {
                ModelState.AddModelError("InvalidCredentials", "Invalid email or password.");
                return View();
            }

            // 登入成功，設定 Session
            HttpContext.Session.SetString("UserId", member.MiMemberId.ToString());
            HttpContext.Session.SetString("UserName", member.MiAccountName);

            return RedirectToAction("Profile");
        }

        // 密碼加密方法
        private string HashPassword(string password)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                var bytes = System.Text.Encoding.UTF8.GetBytes(password);
                var hash = sha256.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }
    }
}