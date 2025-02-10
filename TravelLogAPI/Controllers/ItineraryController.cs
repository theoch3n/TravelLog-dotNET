using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;
//using TravelLog.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace TravelLogAPI.Controllers
{
    [EnableCors("VueSinglePage")]
    [Route("api/[controller]")]
    [ApiController]
    public class ItineraryController : ControllerBase
    {
        private readonly TravelLogContext _context;

        public ItineraryController(TravelLogContext context)
        {
            _context = context;
        }

        // GET api/Itinerary/5
        [HttpGet("Itinerary/{id}")]
        public async Task<ActionResult<Itinerary>> GetItinerary(int id)
        {
            var itinerary = await _context.Itineraries.FindAsync(id);

            if (itinerary == null)
            {
                return NotFound();
            }

            return itinerary;
        }

        // GET api/itinerarydetail/5
        [HttpGet("itinerarydetail/{id}")]
        public async Task<ActionResult<ItineraryDetail>> GetItineraryDetail(int id)
        {
            var itinerarydetail = await _context.ItineraryDetails.FindAsync(id);

            if (itinerarydetail == null)
            {
                return NotFound();
            }

            return itinerarydetail;
        }

        // POST api/Itinerary
        [HttpPost("Itinerary")]
        public async Task<ActionResult<Itinerary>> PostItinerary(Itinerary itinerary)
        {
            _context.Itineraries.Add(itinerary);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetItinerary", new { id = itinerary.ItineraryId }, itinerary);
        }

        // POST api/ItineraryDetail
        [HttpPost("ItineraryDetail")]
        public async Task<ActionResult<ItineraryDetail>> PostItinerary(ItineraryDetail itinerarydetail)
        {
            _context.ItineraryDetails.Add(itinerarydetail);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetItineraryDetail", new { id = itinerarydetail.ItineraryId }, itinerarydetail);
        }

        // PUT api/<ItineraryController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<ItineraryController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
