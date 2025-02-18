using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Threading.Tasks;
using TravelLogAPI.Models;

namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]  // 確保只有已登入的使用者可以存取
    public class ProfileController : ControllerBase
    {
        private readonly TravelLogContext _context;

        public ProfileController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: api/Profile
        [HttpGet]
        public async Task<IActionResult> GetProfile()
        {
            try
            {
                // 從 JWT 中取得使用者ID（sub 或 NameIdentifier）
                var userIdClaim = User.FindFirst(JwtRegisteredClaimNames.Sub)
                                  ?? User.FindFirst(ClaimTypes.NameIdentifier);

                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
                {
                    return Unauthorized(new { message = "無法解析使用者ID" });
                }

                var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
                if (user == null)
                {
                    return NotFound(new { message = "找不到使用者" });
                }

                return Ok(new
                {
                    userId = user.UserId,
                    userName = user.UserName,
                    userEmail = user.UserEmail,
                    userPhone = user.UserPhone
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "伺服器錯誤", detail = ex.ToString() });
            }
            
        }

        // PUT: api/Profile
        [HttpPut]
        public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileRequest request)
        {
            var userIdClaim = User.FindFirst(JwtRegisteredClaimNames.Sub)
                              ?? User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "無法解析使用者ID" });
            }

            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
            if (user == null)
            {
                return NotFound(new { message = "找不到使用者" });
            }

            // 更新資料
            user.UserName = request.UserName;
            user.UserEmail = request.UserEmail;
            user.UserPhone = request.UserPhone;

            await _context.SaveChangesAsync();

            return Ok(new { message = "個人資料更新成功", userId = user.UserId });
        }
    }

    public class UpdateProfileRequest
    {
        public string UserName { get; set; }
        public string UserEmail { get; set; }
        public string UserPhone { get; set; }
    }
}
