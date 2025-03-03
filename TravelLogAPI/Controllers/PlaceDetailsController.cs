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
    public class PlaceDetailsController : ControllerBase
    {
        private readonly TravelLogContext _context;
        public PlaceDetailsController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: api/PlaceDetails
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PlaceDetail>>> GetPlaceDetails()
        {
            return await _context.PlaceDetails.ToListAsync();
        }

        // GET: api/PlaceDetails/id
        [HttpGet("{id}")]
        public async Task<ActionResult<PlaceDetail>> GetPlaceDetails(int id)
        {
            var PlaceDetails = await _context.PlaceDetails.FindAsync(id);

            if (PlaceDetails == null)
            {
                return NotFound();
            }

            return PlaceDetails;
        }

        // GET: api/PlaceDetails/GetPlaceImgs/id
        [HttpGet("[action]/{id}")]
        public async Task<ActionResult<List<PlaceImage>>> GetPlaceImgs(int id)
        {
            var PlaceImgs = await _context.PlaceImages.Where(p => p.PlaceId == id).ToListAsync();

            if (PlaceImgs == null)
            {
                return NotFound();
            }

            return PlaceImgs;
        }



    }
}
