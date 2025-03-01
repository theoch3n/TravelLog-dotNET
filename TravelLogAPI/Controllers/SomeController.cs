using Google.Apis.Gmail.v1;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using TravelLogAPI.Helpers;

namespace TravelLogAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SomeController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public SomeController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("SendTestEmail")]
        public IActionResult SendTestEmail()
        {
            // 從 appsettings.json 中取得 Gmail 設定，並取得 GmailService 物件
            var gmailService = GmailApiProvider.GetGmailService(_configuration);

            // 在這裡你可以使用 gmailService 發送郵件
            // 例如：呼叫 GmailServiceHelper.SendEmailAsync(...)

            return Ok("Test email function triggered.");
        }

        // 內部示範一個服務類別，從 DI 中取得 GmailService
        public class SomeService
        {
            private readonly GmailService _gmailService;

            public SomeService(IConfiguration configuration)
            {
                _gmailService = GmailApiProvider.GetGmailService(configuration);
            }

            // 可以在這裡實作使用 _gmailService 的方法
        }
    }
}
