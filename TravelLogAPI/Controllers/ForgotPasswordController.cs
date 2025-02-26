using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using TravelLogAPI.Services; // 加入 GmailServiceHelper 的命名空間
using Microsoft.Extensions.Configuration;  // 確保加入這個 using


namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ForgotPasswordController : ControllerBase
    {
        private readonly TravelLogContext _context;
        private readonly IConfiguration _configuration;

        public ForgotPasswordController(TravelLogContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }
        // POST: api/ForgotPassword
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ForgotPasswordRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest(new { message = "Email 不可為空" });
            }

            // 根據 Email 查詢使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == request.Email);
            if (user != null)
            {
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
                        UserPdPasswordHash = "" // 初始保持空字串
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

                // 組成重設密碼連結 (請確保 ResetPasswordController 中的路由與此相符)
                string resetLink = Url.Action("Index", "ResetPassword", new { token = token }, Request.Scheme);
                string subject = "密碼重置通知";
                string body = $"請點擊以下連結來重設您的密碼：{resetLink}\n注意：此連結有效 1 小時。";

                // 呼叫 Gmail API 發送郵件
                await GmailServiceHelper.SendEmailAsync(_configuration, user.UserEmail, "david39128332@gmail.com", subject, body);


            }

            // 統一回覆訊息，避免洩漏使用者是否存在的資訊
            return Ok(new { message = "如果該 Email 已註冊，我們將發送重置連結。" });
        }
    }
}