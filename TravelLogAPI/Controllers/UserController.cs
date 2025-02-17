using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using TravelLogAPI.Models;  // 反向工程生成的模型所在的命名空間

namespace TravelLogAPI.Controllers
{
    [EnableCors("VueSinglePage")]
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
            var secretKey = "your_secret_key_here"; // 請確保此密鑰足夠複雜並保存在安全位置（例如 appsettings.json）
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            // 2. 定義 Token 所包含的 claims（這裡可以根據需求加入更多資訊）
            var claims = new[]
            {
        new Claim(JwtRegisteredClaimNames.Sub, user.UserId.ToString()),
        new Claim(JwtRegisteredClaimNames.UniqueName, user.UserName),
        new Claim(JwtRegisteredClaimNames.Email, user.UserEmail),
        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
    };

            // 3. 生成 JWT Token
            var token = new JwtSecurityToken(
                issuer: "MyAppIssuer",           // 發行者，請根據需求設定
                audience: "MyAppAudience",       // 受眾，請根據需求設定
                claims: claims,
                expires: DateTime.UtcNow.AddHours(1), // Token 過期時間
                signingCredentials: creds
            );

            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

            // 回傳 JWT Token 給前端
            return Ok(new
            {
                message = "登入成功！",
                token = tokenString
            });
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
