using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;

namespace TravelLog.Controllers
{
    public class ItineraryController : Controller
    {
        private readonly TravelLogContext _context;
        public ItineraryController(TravelLogContext context) {
            _context = context;
        }
        public async Task<IActionResult> List()
        {
            var data = await _context.Itineraries.ToListAsync();

            List<ItineraryWrap> list = new List<ItineraryWrap>();

            foreach (var t in data)
            {
                list.Add(new ItineraryWrap { itinerary = t });
            }

            return View(list);
        }
    }
}
