using Microsoft.AspNetCore.Mvc;

namespace TravelLog.Controllers
{
    public class TemplateController : Controller
    {
        public IActionResult Index2()
        {
            return View();
        }
    }
}
