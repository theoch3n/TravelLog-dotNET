using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;
using System.Globalization; // 確保加上這個命名空間
using Humanizer;



namespace TravelLogAPI.Controllers
{
    [EnableCors("VueSinglePage")]
    [Route("api/[controller]")]
    [ApiController]
    public class PlacesController : Controller
    {
        private readonly TravelLogContext _context;

        public PlacesController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: api/Places
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Place>>> GetPlace()
        {
            return await _context.Places.ToListAsync();
        }

        // GET: api/Places/2025-02-11
        [HttpGet("by-date/{date}")]
        public async Task<IActionResult> GetPlacesByDate([FromRoute] string date)
        {
            if (string.IsNullOrEmpty(date))
            {
                return BadRequest("請提供日期");
            }

            // 使用 "yyyy-MM-dd" 明確解析日期
            if (!DateTime.TryParseExact(date, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime selectedDate))
            {
                return BadRequest("日期格式錯誤，請使用 YYYY-MM-DD 格式");
            }

            var places = await _context.Places
                .Where(p => p.Date == selectedDate.Date) // 確保比較時只使用日期部分
                .ToListAsync();

            if (!places.Any())
            {
                return NotFound("沒有找到符合的資料");
            }

            return Ok(places);
        }


        // GET: api/Places/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Place>> GetPlace(int id)
        {
            var place = await _context.Places.FindAsync(id);

            if (place == null)
            {
                return NotFound();
            }

            return place;
        }

        // PUT: api/Places/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPlace(int id, Place place)
        {
            if (id != place.Id)
            {
                return BadRequest();
            }

            _context.Entry(place).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PlaceExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Places
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Place>> PostPlace(Place place)
        {



            // 新增 place
            _context.Places.Add(place);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPlace", new { id = place.Id }, place);
        }

        // DELETE: api/Places/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePlace(int id)
        {
            var place = await _context.Places.FindAsync(id);
            if (place == null)
            {
                return NotFound();
            }

            _context.Places.Remove(place);
            await _context.SaveChangesAsync();

            // 回傳一個成功的 JSON 回應
            return Ok(new { placeId = id });
        }

        private bool PlaceExists(int id)
        {
            return _context.Places.Any(e => e.Id == id);
        }
    }
}
