using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;

namespace TravelLog.Controllers {
    public class OrderController : Controller {

        private readonly TravelLogContext _context;

        public OrderController(TravelLogContext context) {
            _context = context;
        }

        TravelLogContext cont = new TravelLogContext();

        // 訂單管理頁面
        // GET: Order/OrderManage
        [HttpGet]
        public async Task<IActionResult> OrderManage() {
            var orders = await _context.Orders.ToListAsync(); // 確保這裡獲取的資料不為 null
            return View(orders);
        }

        // 訂單修改頁面
        // GET: Order/OrderEdit
        [HttpGet]
        public async Task<IActionResult> OrderEdit(int orderId) {
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null) {
                return NotFound();
            }
            return View(order);
        }

        // 儲存修改的訂單資料
        // POST: Order/SaveEdit
        [HttpPost]
        public async Task<IActionResult> SaveEdit(Order order) {
            if (ModelState.IsValid) {
                _context.Update(order);
                await _context.SaveChangesAsync();
                return RedirectToAction("OrderManage");
            }
            return View("OrderEdit", order);
        }

        //BUG: 無法取消訂單
        [HttpPost]
        public async Task<IActionResult> Cancel(int orderId) {
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null) {
                return Json(new { success = false, message = "找不到訂單" });
            }

            // 更新訂單狀態與取消時間
            order.OrderStatus = 4; // 訂單取消
            order.DeleteAt = DateTime.Now;

            // 保存更改
            _context.Update(order);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "訂單已取消" });
        }

    }
}
