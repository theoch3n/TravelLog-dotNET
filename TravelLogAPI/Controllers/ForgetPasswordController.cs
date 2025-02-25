using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using TravelLogAPI.Helpers;

namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ForgetPasswordController : ControllerBase
    {
        private readonly TravelLogContext _context;

        public ForgetPasswordController(TravelLogContext context)
        {
            _context = context;
        }

        // POST: api/ForgetPassword
        [HttpPost]
        public async Task<IActionResult> Post(string email)
        {
            // 查詢是否有此 email 的使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == email);
            if (user != null)
            {
                string token = Guid.NewGuid().ToString();
                DateTime createTime = DateTime.Now;

                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
                if (userPd == null)
                {
                    userPd = new UserPd
                    {
                        UserId = user.UserId,
                        UserPdToken = token,
                        UserPdCreateDate = createTime,
                        UserPdPasswordHash = ""
                    };
                    _context.UserPds.Add(userPd);
                }
                else
                {
                    userPd.UserPdToken = token;
                    userPd.UserPdCreateDate = createTime;
                }
                await _context.SaveChangesAsync();

                string resetLink = Url.Action("Index", "ResetPassword", new { token = token }, Request.Scheme);
                string subject = "密碼重置通知";
                string body = $"請點擊以下連結來重設您的密碼：{resetLink}\n注意：此連結有效 1 小時。";

                GmailServiceHelper.SendEmail(user.UserEmail, subject, body);
            }

            // 統一回覆訊息，避免洩漏資訊
            return Ok(new { message = "如果該 Email 已註冊，我們將發送重置連結。" });
        }
    }
}
