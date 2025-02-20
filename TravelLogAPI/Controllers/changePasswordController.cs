using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using Microsoft.AspNetCore.Identity;

namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize] // 只有已登入使用者可以呼叫
    public class ChangePasswordController : ControllerBase
    {
        private readonly TravelLogContext _context;
        private readonly PasswordHasher<User> _passwordHasher;

        public ChangePasswordController(TravelLogContext context)
        {
            _context = context;
            _passwordHasher = new PasswordHasher<User>();
        }

        // PUT: api/ChangePassword
        [HttpPut]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
        {
            // 檢查必填欄位
            if (string.IsNullOrEmpty(request.OldPassword) || string.IsNullOrEmpty(request.NewPassword))
            {
                return BadRequest(new { message = "舊密碼和新密碼皆必填" });
            }

            // 從 JWT 中取得使用者ID（使用 Claim "sub" 或 ClaimTypes.NameIdentifier）
            var userIdClaim = User.FindFirst("sub") ?? User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "無法解析使用者ID" });
            }

            // 從資料庫中讀取使用者與密碼資訊（這裡假設密碼資訊存放於 UserPds 表）
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
            if (user == null)
            {
                return NotFound(new { message = "找不到使用者" });
            }

            var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
            if (userPd == null)
            {
                return Unauthorized(new { message = "無法取得使用者密碼資訊" });
            }

            // 驗證舊密碼是否正確
            var verifyResult = _passwordHasher.VerifyHashedPassword(user, userPd.UserPdPasswordHash, request.OldPassword);
            if (verifyResult != PasswordVerificationResult.Success)
            {
                return Unauthorized(new { message = "舊密碼不正確" });
            }

            // 對新密碼進行雜湊並更新密碼
            userPd.UserPdPasswordHash = _passwordHasher.HashPassword(user, request.NewPassword);
            await _context.SaveChangesAsync();

            return Ok(new { message = "密碼變更成功" });
        }
    }

    // 請求資料傳輸物件
    public class ChangePasswordRequest
    {
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
    }
}
