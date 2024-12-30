using Microsoft.AspNetCore.Mvc;

namespace TravelLog.Controllers
{
    public class ItineraryController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
