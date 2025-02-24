using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using TravelLogAPI.Models;
using TravelLogAPI.Helpers;


namespace TravelLogAPI.Controllers
{
    public class ForgetPasswordController : Controller
    {
        private readonly TravelLogContext _context;

        public ForgetPasswordController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: 顯示忘記密碼表單頁面
        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        // POST: 接收表單送出的 Email 並發送重設密碼信
        [HttpPost]
        public async Task<IActionResult> Index(string email)
        {
            // 查詢是否有此 email 的使用者
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserEmail == email);
            if (user != null)
            {
                // 產生一個唯一 token 及記錄產生時間
                string token = Guid.NewGuid().ToString();
                DateTime createTime = DateTime.Now;

                // 取得使用者密碼相關記錄 (假設資料存放在 UserPds 表)
                var userPd = await _context.UserPds.FirstOrDefaultAsync(pd => pd.UserId == user.UserId);
                if (userPd == null)
                {
                    // 若不存在，則新增一筆
                    userPd = new UserPd
                    {
                        UserId = user.UserId,
                        UserPdToken = token,
                        UserPdCreateDate = createTime,
                        UserPdPasswordHash = "" // 先保持空字串
                    };
                    _context.UserPds.Add(userPd);
                }
                else
                {
                    // 更新 token 與建立時間
                    userPd.UserPdToken = token;
                    userPd.UserPdCreateDate = createTime;
                }
                await _context.SaveChangesAsync();

                // 組成重設密碼連結，這裡假設 ResetPasswordController 的 Index 動作會處理重設密碼頁面
                string resetLink = Url.Action("Index", "ResetPassword", new { token = token }, Request.Scheme);
                string subject = "密碼重置通知";
                string body = $"請點擊以下連結來重設您的密碼：{resetLink}\n注意：此連結有效 1 小時。";

                // 呼叫 Gmail API 發送郵件 (請確認 GmailServiceHelper 已正確實作)
                GmailServiceHelper.SendEmail(user.UserEmail, subject, body);
            }

            // 為避免洩漏資訊，不論是否找到 email 均顯示相同訊息
            ViewBag.Message = "如果該 Email 已註冊，我們將發送重置連結。";
            return View();
        }
    }
}
