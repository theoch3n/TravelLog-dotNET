using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;

namespace TravelLog.Controllers {
    public class TicketsController : Controller {
        private readonly TravelLogContext _context;

        public TicketsController(TravelLogContext context) {
            _context = context;
        }

        // GET: Tickets
        public async Task<IActionResult> List() {
            return View(await _context.Tickets.ToListAsync());
        }

        // GET: Tickets/Create
        public IActionResult Create() {
            return View();
        }

        // POST: Tickets/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("TicketsId,TicketsName,TicketsType,Price,IsAvailable,Description,RefundPolicy,CreatedAt")] Ticket ticket) {
            if (ModelState.IsValid) {
                _context.Add(ticket);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(List));
            }
            return View(ticket);
        }

        // GET: Tickets/Edit
        public async Task<IActionResult> Edit(int ticketId) {
            //if (ticketId == null)
            //{
            //    return RedirectToAction("List");
            //}

            var ticket = await _context.Tickets.FindAsync(ticketId);
            if (ticket == null) {
                return NotFound();
            }
            return View(ticket);
        }

        // POST: Tickets/Edit
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        //[ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(Ticket ticket) {
            //if (id != ticket.TicketsId) {
            //    return NotFound();
            //}

            if (ModelState.IsValid) {
                try {
                    _context.Update(ticket);
                    await _context.SaveChangesAsync();
                    return RedirectToAction("List");
                }
                catch (DbUpdateConcurrencyException) {
                    if (!TicketExists(ticket.TicketsId)) {
                        return NotFound();
                    }
                    else {
                        throw;
                    }
                }
            }
            return View("Edit", ticket);
        }

        // GET: Tickets/Delete/5
        public async Task<IActionResult> Delete(int? id) {
            if (id == null) {
                return RedirectToAction("List");
            }

            var ticket = await _context.Tickets.FirstOrDefaultAsync(m => m.TicketsId == id);
            if (ticket == null) {
                return NotFound();
            }
            _context.Tickets.Remove(ticket);
            await _context.SaveChangesAsync();
            return RedirectToAction("List");
        }

        private bool TicketExists(int id) {
            return _context.Tickets.Any(e => e.TicketsId == id);
        }
    }
}
