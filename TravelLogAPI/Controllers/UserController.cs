using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using TravelLogAPI.Models;  // 反向工程生成的模型所在的命名空間

namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly TravelLogContext _context;

        public UserController(TravelLogContext context)
        {
            _context = context;
        }

        // POST: api/User/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            // 檢查傳入資料是否完整
            if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new { message = "請提供完整的登入資訊。" });
            }

            // 根據 Email 從 Users 表中查詢使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user == null)
            {
                return NotFound(new { message = "找不到該使用者。" });
            }

            // 根據使用者的 ID 從 UserPds 表中查詢密碼資訊
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
            if (userPd == null)
            {
                return Unauthorized(new { message = "使用者密碼資訊錯誤。" });
            }

            // 使用 PasswordHasher 驗證密碼，避免直接比對明文
            var passwordHasher = new PasswordHasher<User>();
            var verifyResult = passwordHasher.VerifyHashedPassword(user, userPd.UserPdPasswordHash, request.Password);
            if (verifyResult != PasswordVerificationResult.Success)
            {
                return Unauthorized(new { message = "密碼不正確。" });
            }

            // 登入成功後，可產生 JWT Token 或回傳其他資料（此處僅示範回傳成功訊息）
            return Ok(new { message = "登入成功！" });
        }

        // POST: api/User/register
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            // 驗證輸入是否完整
            if (string.IsNullOrWhiteSpace(request.Email) ||
                string.IsNullOrWhiteSpace(request.Password) ||
                string.IsNullOrWhiteSpace(request.UserName))
            {
                return BadRequest(new { message = "請提供完整的註冊資訊。" });
            }

            // 檢查電子郵件是否已存在
            var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (existingUser != null)
            {
                return BadRequest(new { message = "此電子郵件已被使用。" });
            }

            // 建立新的 User 資料
            var user = new User
            {
                UserName = request.UserName,
                UserEmail = request.Email,
                UserPhone = request.Phone,  // 若沒有提供可以為 null 或空字串
                UserEnabled = true,
                UserCreateDate = DateTime.Now
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();  // 儲存後，user.UserId 會被自動產生

            // 使用 PasswordHasher 對密碼進行雜湊處理
            var passwordHasher = new PasswordHasher<User>();
            string hashedPassword = passwordHasher.HashPassword(user, request.Password);

            // 建立對應的 UserPd 資料
            var userPd = new UserPd
            {
                UserId = user.UserId,   // 使用剛生成的 UserId
                UserPdPasswordHash = hashedPassword, // 儲存雜湊後的密碼
                UserPdToken = "",       // 預設空字串，可根據需求產生 Token
                UserPdCreateDate = DateTime.Now
            };

            _context.UserPds.Add(userPd);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "註冊成功！",
                userId = user.UserId,
                userName = user.UserName
            });
        }
    }

    // 用於登入請求的資料傳輸物件
    public class LoginRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public bool RememberMe { get; set; }
    }

    public class RegisterRequest
    {
        // 使用者名稱，例如 "TestUser"
        public string UserName { get; set; }
        // 使用者電子郵件，例如 "Test@gmail.com"
        public string Email { get; set; }
        // 使用者電話，若有需要
        public string Phone { get; set; }
        // 密碼（注意：此處示範直接儲存明文，實際應使用安全的密碼雜湊）
        public string Password { get; set; }
    }
}
