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
        private readonly TravelLogContextProcedures _procedures;


        public ItineraryController(TravelLogContext context, TravelLogContextProcedures procedures)
        {
            _context = context;
            _procedures = procedures;
        }

        //public async Task<List<Map>> GetLocationAsync(int id)
        //{
        //    // 假設這裡是執行儲存程序的邏輯
        //    // 這裡使用 Entity Framework Core 的 FromSqlRaw 方法來執行儲存程序
        //    return await _procedures.Maps.FromSqlRaw("EXEC GetLocation @Id = {0}", id).ToListAsync();
        //}

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

        // GET api/Itinerary/5
        [HttpGet("ItineraryGroup/{id}")]
        public async Task<ActionResult<ItineraryGroup>> GetItineraryGroup(int id)
        {
            var itinerarygroups = await _context.ItineraryGroups.FindAsync(id);

            if (itinerarygroups == null)
            {
                return NotFound();
            }

            return itinerarygroups;
        }

        // POST api/Itinerary/Itinerary
        [HttpPost("Itinerary")]
        public async Task<ActionResult<Itinerary>> PostItinerary(Itinerary itinerary)
        {
            _context.Itineraries.Add(itinerary);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetItinerary", new { id = itinerary.ItineraryId }, itinerary);
        }

        // POST api/Itinerary/ItineraryDetail
        [HttpPost("ItineraryDetail")]
        public async Task<ActionResult<ItineraryDetail>> PostItinerary(ItineraryDetail itinerarydetail)
        {
            _context.ItineraryDetails.Add(itinerarydetail);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetItineraryDetail", new { id = itinerarydetail.ItineraryId }, itinerarydetail);
        }

        // POST api/Itinerary/ItineraryGroup
        [HttpPost("ItineraryGroup")]
        public async Task<ActionResult<ItineraryGroup>> PostItinerarGroup(ItineraryGroup itinerarygroups)
        {
            _context.ItineraryGroups.Add(itinerarygroups);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetItineraryGroup", new { id = itinerarygroups.ItineraryGroupId }, itinerarygroups);
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
        
        // GET api/Itinerary/getLocation/5
        [HttpGet("getLocation/{id}")]
        public async Task<IActionResult> GetLocation(int id, DateOnly starddate, DateOnly enddate)
        {
            var location = await _procedures.get_LocationAsync(id, starddate, enddate);

            if (location == null)
            {
                return NotFound();
            }
            return Ok(location);
        }


        // GET api/Itinerary/getitineraryData
        [HttpGet("getitineraryData")]
        public async Task<ActionResult<IEnumerable<Itinerary>>> getitineraryData(int id)
        {
            var itineraries = await _context.Itineraries.ToListAsync();

            if (itineraries == null || !itineraries.Any())
            {
                return NotFound();
            }

            return Ok(itineraries);
        }

        // GET api/Itinerary/ByUser/{uid}
        [HttpGet("ByUser/{uid}")]
        public async Task<ActionResult<IEnumerable<Itinerary>>> GetItinerariesByUser(int uid)
        {
            var itineraries = await _context.Itineraries
                .Where(i => i.ItineraryCreateUser == uid)
                .ToListAsync();

            return Ok(itineraries);
        }

        // GET api/Itinerary/ByEmail/{email}
        [HttpGet("ByEmail/{email}")]
        public async Task<ActionResult<IEnumerable<Itinerary>>> GetItinerariesByEmail(string email)
        {
            var itineraryGroups = await _context.ItineraryGroups
                .Where(ig => ig.ItineraryGroupUserEmail == email)
                .ToListAsync();

            if (itineraryGroups == null || !itineraryGroups.Any())
            {
                return Ok(new List<Itinerary>());
            }

            var itineraryIds = itineraryGroups.Select(ig => ig.ItineraryGroupItineraryId).ToList();
            var itineraries = await _context.Itineraries
                .Where(i => itineraryIds.Contains(i.ItineraryId))
                .ToListAsync();

            return Ok(itineraries);
        }
    }
}
