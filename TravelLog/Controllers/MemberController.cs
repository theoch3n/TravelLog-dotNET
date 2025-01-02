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
                    member.MiIsActive = true; // 默認啟用

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
        public IActionResult Login(string email, string password)
        {
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ModelState.AddModelError("EmptyFields", "Email and Password are required.");
                return View();
            }

            // 驗證用戶憑據
            var hashedPassword = HashPassword(password);
            var member = _context.MemberInformations
                .FirstOrDefault(m => m.MiEmail == email && m.MiPasswordHash == hashedPassword && m.MiIsActive == true);

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
    }
}