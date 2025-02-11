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

            // 根據 Email 從 User 表中查詢使用者（假設模型中的屬性名稱為 User_Email 和 UserId）
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user == null)
            {
                return NotFound(new { message = "找不到該使用者。" });
            }

            // 根據使用者的 ID 從 UserPd 表中查詢密碼資訊
            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
            if (userPd == null)
            {
                return Unauthorized(new { message = "使用者密碼資訊錯誤。" });
            }

            // 驗證密碼 (注意：這裡直接比對明文，實際上請使用安全的密碼雜湊驗證)
            if (request.Password != userPd.UserPdPasswordHash)
            {
                return Unauthorized(new { message = "密碼不正確。" });
            }

            // 登入成功，回傳成功訊息或產生 JWT Token 等
            return Ok(new { message = "登入成功！" });
        }
    }

    // LoginRequest 用於接收前端傳來的登入資料
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
