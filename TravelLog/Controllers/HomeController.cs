using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using TravelLog.Models;

namespace TravelLog.Controllers {
    public class HomeController : Controller {
        private readonly ILogger<HomeController> _logger;
        TravelLogContext _context;

        public HomeController(ILogger<HomeController> logger, TravelLogContext context) {
            _logger = logger;
            _context = context;
        }

        public IActionResult Index() {
            return View();
        }

        public IActionResult Privacy() {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error() {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

    }
}
