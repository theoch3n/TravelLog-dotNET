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
    public class TicketsController : Controller
    {
        private readonly TravelLogContext _context;

        public TicketsController(TravelLogContext context)
        {
            _context = context;
        }

        // GET: Tickets
        public async Task<IActionResult> List()
        {
            var data = await _context.Tickets.ToListAsync();
            List<TicketWrap> list = new List<TicketWrap>();
            foreach (var t in data)
            {
                list.Add(new TicketWrap { ticket = t });
            }
            return View(list);
        }

        // GET: Tickets/Create
        public IActionResult Create()
        {
            var ticketWrap = new TicketWrap { IsAvailable = true };
            return View(ticketWrap);
        }

        // POST: Tickets/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("TicketsId,TicketsName,TicketsType,Price,IsAvailable,Description,RefundPolicy,CreatedAt")] TicketWrap ticketWrap)
        {
            if (ModelState.IsValid)
            {
                _context.Add(ticketWrap.ticket);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(List));
            }
            return View(ticketWrap);
        }

        // GET: Tickets/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return RedirectToAction("List");
            }

            var data = await _context.Tickets.FindAsync(id);
            if (data == null)
            {
                return RedirectToAction("List");
            }
            var ticketWrap = new TicketWrap() { ticket = data ,IsAvailable = data.IsAvailable};
            return View(ticketWrap);
        }

        // POST: Tickets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit([Bind("TicketsId,TicketsName,TicketsType,Price,IsAvailable,Description,RefundPolicy,CreatedAt")] TicketWrap ticketWrap)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(ticketWrap.ticket);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!TicketExists(ticketWrap.TicketsId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(List));
            }
            return View(ticketWrap);
        }

        // GET: Tickets/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return RedirectToAction("List");
            }

            var ticket = await _context.Tickets.FirstOrDefaultAsync(m => m.TicketsId == id);
            if (ticket == null)
            {
                return NotFound();
            }
            _context.Tickets.Remove(ticket);
            await _context.SaveChangesAsync();
            return RedirectToAction("List");
        }

        private bool TicketExists(int id)
        {
            return _context.Tickets.Any(e => e.TicketsId == id);
        }
    }
}
