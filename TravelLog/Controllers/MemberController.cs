using Microsoft.AspNetCore.Mvc;
using TravelLog.Models;
using System;
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
        public IActionResult Register(TravelLog.ViewModels.UserRegisterViewModel model)
        {
            // 檢查密碼與確認密碼是否一致
            if (model.Password != model.ConfirmPassword)
            {
                ModelState.AddModelError("PasswordMismatch", "密碼與確認密碼不符。");
                return View(model);
            }

            // 驗證 Email 是否唯一
            if (_context.Users.Any(u => u.UserEmail == model.Email))
            {
                ModelState.AddModelError("EmailExists", "此 Email 已經註冊。");
                return View(model);
            }

            if (ModelState.IsValid)
            {
                try
                {
                    // 將 ViewModel 的資料映射到 User 資料庫實體
                    var newUser = new User
                    {
                        UserName = model.Name,
                        UserEmail = model.Email,
                        UserPhone = model.Phone,
                        UserEnabled = true,
                        UserCreateDate = DateTime.Now,
                        IsEmailVerified = false,
                        UserRole = model.Role
                    };

                    // 建立並設定密碼資料，這裡我們透過 HashPassword 將密碼加密後儲存
                    var newUserPd = new UserPd
                    {
                        UserPdPasswordHash = HashPassword(model.Password),
                        UserPdCreateDate = DateTime.Now,
                        TokenCreateDate = DateTime.MinValue
                    };

                    // 將密碼資料加入到 User 的關聯集合中
                    newUser.UserPds.Add(newUserPd);

                    // 將 User 實體加入到資料庫上下文中
                    _context.Users.Add(newUser);
                    // 儲存變更，資料就會被寫入資料庫
                    _context.SaveChanges();

                    TempData["SuccessMessage"] = "註冊成功！您現在可以登入。";
                    return RedirectToAction("Login");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("DatabaseError", "處理您的請求時發生錯誤。");
                    Console.WriteLine(ex.Message);
                }
            }
            return View(model);
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
        public IActionResult Login(string userEmail, string password)
        {
            if (string.IsNullOrEmpty(userEmail) || string.IsNullOrEmpty(password))
            {
                ModelState.AddModelError("EmptyFields", "Email 與密碼為必填項目。");
                return View();
            }

            var hashedPassword = HashPassword(password);

            // 先依 Email 找出啟用的使用者
            var user = _context.Users.FirstOrDefault(u => u.UserEmail == userEmail && u.UserEnabled);
            if (user == null || !user.UserPds.Any(pd => pd.UserPdPasswordHash == hashedPassword))
            {
                ModelState.AddModelError("InvalidCredentials", "Email 或密碼錯誤。");
                return View();
            }

            // 設定 Session
            HttpContext.Session.SetString("LoggedUserId", user.UserId.ToString());
            HttpContext.Session.SetString("UserName", user.UserName);

            TempData["SuccessMessage"] = $"歡迎回來，{user.UserName}！";
            return RedirectToAction("Profile");
        }

        // 顯示個人資料頁面
        [HttpGet]
        public IActionResult Profile()
        {
            if (!HttpContext.Session.TryGetValue("LoggedUserId", out var userIdBytes))
            {
                return RedirectToAction("Login");
            }

            var userId = int.Parse(Encoding.UTF8.GetString(userIdBytes));
            var user = _context.Users.FirstOrDefault(u => u.UserId == userId);

            if (user == null)
            {
                return RedirectToAction("Login");
            }

            return View(user);
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
            var user = _context.Users.FirstOrDefault(u => u.UserEmail == email);
            if (user == null)
            {
                TempData["ErrorMessage"] = "沒有帳號與此 Email 綁定。";
                return View();
            }

            // 取得使用者的 UserPd，如果不存在則建立新的
            var userPd = user.UserPds.FirstOrDefault();
            if (userPd == null)
            {
                userPd = new UserPd();
                user.UserPds.Add(userPd);
            }
            var resetToken = Guid.NewGuid().ToString();
            userPd.UserPdToken = resetToken;
            userPd.TokenCreateDate = DateTime.Now;
            _context.SaveChanges();

            // 將 Email 與 Token 存入 Session（實際上您也可改成寄信機制）
            HttpContext.Session.SetString("Email", email);
            HttpContext.Session.SetString("Token", resetToken);

            TempData["SuccessMessage"] = "密碼重設連結已寄至您的信箱。";
            return RedirectToAction("ResetPassword");
        }

        // 顯示重設密碼頁面
        [HttpGet]
        public IActionResult ResetPassword()
        {
            string email = HttpContext.Session.GetString("Email");
            string token = HttpContext.Session.GetString("Token");

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(token))
            {
                TempData["ErrorMessage"] = "重設密碼連結無效或已過期。";
                return RedirectToAction("ResetPasswordRequest");
            }

            // 驗證 Email 與 Token 是否存在
            var user = _context.Users.FirstOrDefault(u => u.UserEmail == email && u.UserPds.Any(pd => pd.UserPdToken == token));
            if (user == null)
            {
                TempData["ErrorMessage"] = "無效或過期的重設密碼連結。";
                return RedirectToAction("ResetPasswordRequest");
            }

            return View(user);
        }

        // 處理重設密碼提交
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ResetPassword(string email, string token, string newPassword, string confirmPassword)
        {
            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 6)
            {
                ModelState.AddModelError("InvalidPassword", "密碼至少需 6 個字元。");
                return View();
            }

            if (newPassword != confirmPassword)
            {
                ModelState.AddModelError("PasswordMismatch", "新密碼與確認密碼不符。");
                return View();
            }

            var user = _context.Users.FirstOrDefault(u => u.UserEmail == email && u.UserPds.Any(pd => pd.UserPdToken == token));
            if (user == null)
            {
                TempData["ErrorMessage"] = "無效或過期的重設密碼連結。";
                return RedirectToAction("ResetPasswordRequest");
            }

            // 更新密碼並清除 Token
            var userPd = user.UserPds.First(pd => pd.UserPdToken == token);
            userPd.UserPdPasswordHash = HashPassword(newPassword);
            userPd.UserPdToken = null;
            _context.SaveChanges();

            TempData["SuccessMessage"] = "密碼已重設成功。";
            return RedirectToAction("Login");
        }

        // 密碼加密方法 (採用 SHA256)
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
