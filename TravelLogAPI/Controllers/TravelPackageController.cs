using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

namespace TravelLogAPI.Controllers
{
    [EnableCors("VueSinglePage")]
    [Route("api/[controller]")]
    [ApiController]
    public class TravelPackageController : ControllerBase
    {
        private readonly TravelLogContext _context;

        public TravelPackageController(TravelLogContext context) 
        {
            _context = context;
        }

        // GET: api/TravelPackage
        [HttpGet]
        public async Task<ActionResult<List<Itinerary>>> GetItinerary()
        {
            var itinerary = await _context.Itineraries.ToListAsync();
            if (itinerary == null)
            {
                return NotFound();
            }

            return itinerary;
        }

        // Post: api/TravelPackage/GetTravelPackageByKeyword
        [HttpPost("[action]")]
        public async Task<IEnumerable<Itinerary>> GetTravelPackageByKeyword([FromBody] Itinerary itineraryData)
        {
            var result = await _context.Itineraries.Where(
                t => 
                    t.ItineraryTitle.Contains(itineraryData.ItineraryTitle) &&
                    t.ItineraryCreateUser == null
            ).ToListAsync();
            return result;
        }

        // Get: api/TravelPackage/GetTravelPackageInfo
        [HttpGet("[action]")]
        public async Task<List<ItineraryPrice>> GetTravelPackageInfo()
        {
            var result = await _context.ItineraryPrices.ToListAsync();
            return result;
        }

        // Get: api/TravelPackage/GetTravelPackageInfo/id
        [HttpGet("[action]/{id}")]
        public async Task<ItineraryPrice> GetTravelPackageInfo(int id)
        {
            var result = await _context.ItineraryPrices.FindAsync(id);
            return result;
        }
    }
}
