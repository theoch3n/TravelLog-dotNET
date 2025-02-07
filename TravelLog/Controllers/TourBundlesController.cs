using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;

namespace TravelLog.Controllers
{
    public class TourBundlesController : Controller
    {
        private readonly TravelLogContext _context;

        public TourBundlesController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: TourBundles
        public async Task<IActionResult> Index()
        {
            var datas = await _context.TourBundles.ToListAsync();
            List<TourBundleWrap> list = new List<TourBundleWrap>();
            foreach (var data in datas)
            {
                list.Add(new TourBundleWrap { tourBundle = data });
            }
            return View(list);
        }

        // GET: TourBundles/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var tourBundle = await _context.TourBundles
                .FirstOrDefaultAsync(m => m.Id == id);
            if (tourBundle == null)
            {
                return NotFound();
            }

            return View(tourBundle);
        }

        // GET: TourBundles/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: TourBundles/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,EventName,StartingPoint,Destination,FirstDate,LastDate,Duration,Price,EventDescription,Ratings,ContactInfo")] TourBundle tourBundle)
        {
            if (ModelState.IsValid)
            {
                _context.Add(tourBundle);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(tourBundle);
        }

        // GET: TourBundles/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var tourBundle = await _context.TourBundles.FindAsync(id);
            if (tourBundle == null)
            {
                return NotFound();
            }
            return View(tourBundle);
        }

        // POST: TourBundles/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,EventName,StartingPoint,Destination,FirstDate,LastDate,Duration,Price,EventDescription,Ratings,ContactInfo")] TourBundle tourBundle)
        {
            if (id != tourBundle.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(tourBundle);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!TourBundleExists(tourBundle.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(tourBundle);
        }

        // GET: TourBundles/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var tourBundle = await _context.TourBundles
                .FirstOrDefaultAsync(m => m.Id == id);
            if (tourBundle == null)
            {
                return NotFound();
            }

            return View(tourBundle);
        }

        // POST: TourBundles/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var tourBundle = await _context.TourBundles.FindAsync(id);
            if (tourBundle != null)
            {
                _context.TourBundles.Remove(tourBundle);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool TourBundleExists(int id)
        {
            return _context.TourBundles.Any(e => e.Id == id);
        }
    }
}
