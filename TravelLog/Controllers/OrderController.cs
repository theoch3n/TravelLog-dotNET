using Microsoft.AspNetCore.Mvc;

namespace TravelLog.Controllers {
    public class OrderController : Controller {

        // GET: Order/Index
        [HttpGet]
        public IActionResult Index() {
            return View();
        }
    }
}
