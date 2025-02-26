using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace TravelLog.MVC.Controllers
{
    public class ChatController : Controller
    {

        

        // 顯示聊天室畫面
        public IActionResult Index()
        {
            return View();
        }

    }
}
