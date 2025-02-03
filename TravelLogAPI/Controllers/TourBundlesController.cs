using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
    public class TourBundlesController : ControllerBase
    {
        private readonly TravelLogContext _context;

        public TourBundlesController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: api/TourBundles
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TourBundle>>> GetTourBundles()
        {
            return await _context.TourBundles.ToListAsync();
        }
        // Post: api/TourBundles/GetTourBundlesByKeyword
        [HttpPost("[action]")]
        public async Task<IEnumerable<TourBundle>> GetTourBundlesByKeyword([FromBody] TourBundle bundleData)
        {
            var result = await _context.TourBundles.Where(
                t => /*t.Id == bundleData.Id ||*/
                t.EventName.Contains(bundleData.EventName) ||
                t.Ratings == bundleData.Ratings
                //||t.EventDescription.Contains(bundleData.EventDescription)
            ).ToListAsync();
            return result;
        }

        // GET: api/TourBundles/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TourBundle>> GetTourBundle(int id)
        {
            var tourBundle = await _context.TourBundles.FindAsync(id);

            if (tourBundle == null)
            {
                return NotFound();
            }

            return tourBundle;
        }

        // PUT: api/TourBundles/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTourBundle(int id, TourBundle tourBundle)
        {
            if (id != tourBundle.Id)
            {
                return BadRequest();
            }

            _context.Entry(tourBundle).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TourBundleExists(id))
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

        // POST: api/TourBundles
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TourBundle>> PostTourBundle(TourBundle tourBundle)
        {
            _context.TourBundles.Add(tourBundle);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTourBundle", new { id = tourBundle.Id }, tourBundle);
        }

        // DELETE: api/TourBundles/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTourBundle(int id)
        {
            var tourBundle = await _context.TourBundles.FindAsync(id);
            if (tourBundle == null)
            {
                return NotFound();
            }

            _context.TourBundles.Remove(tourBundle);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TourBundleExists(int id)
        {
            return _context.TourBundles.Any(e => e.Id == id);
        }
    }
}
