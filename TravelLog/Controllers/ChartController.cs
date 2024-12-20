using Microsoft.AspNetCore.Mvc;

namespace TravelLog.Controllers {
  public class ChartController : Controller {
    public IActionResult Index() {
      return View();
    }
  }
}
