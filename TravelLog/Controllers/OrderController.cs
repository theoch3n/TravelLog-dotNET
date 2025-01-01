using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace TravelLog.Controllers {
    public class OrderController : Controller {

        private readonly TravelLogContext _context;

        public OrderController(TravelLogContext context) {
            _context = context;
        }

        TravelLogContext cont = new TravelLogContext();

        //TODO: 加入其他資料表並顯示對應Value

        // 訂單管理頁面
        // GET: Order/OrderManage
        [HttpGet]
        public async Task<IActionResult> OrderManage() {
            var orders = await _context.Orders.ToListAsync(); // 確保這裡獲取的資料不為 null
            List<OrderWrap> list = new List<OrderWrap>();
            foreach (var item in orders) {
                list.Add(new OrderWrap { order = item });
            }
            return View(list);
        }

        // 訂單詳細資料
        // GET: Order/OrderDetail
        [HttpGet]
        public async Task<IActionResult> OrderDetail(int? id) {
            if (id == null) {
                return RedirectToAction("OrderManage");
            }
            var data = await _context.Orders.FindAsync(id);
            if (data == null) {
                return RedirectToAction("OrderManage");
            }
            var orderWrap = new OrderWrap { order = data };
            return View(orderWrap);
        }

        // 訂單修改頁面
        // GET: Order/OrderEdit
        [HttpGet]
        public async Task<IActionResult> OrderEdit(int? id) {
            if (id == null) {
                return RedirectToAction("OrderManage");
            }

            var data = await _context.Orders.FindAsync(id);
            if (data == null) {
                return RedirectToAction("OrderManage");
            }
            var orderWrap = new OrderWrap() { order = data };
            return View(orderWrap);
        }

        // 儲存修改的訂單資料
        // POST: Order/SaveEdit
        [HttpPost]
        public async Task<IActionResult> SaveEdit(OrderWrap orderWrap) {
            if (ModelState.IsValid) {
                _context.Update(orderWrap.order);
                await _context.SaveChangesAsync();
                return RedirectToAction("OrderManage");
            }
            return View(orderWrap);
        }

        // 取消訂單 (更改訂單狀態為已取消並新增取消時間)
        // POST: Order/SaveEdit
        [HttpPost]
        public async Task<IActionResult> Cancel([FromBody] int? id) {
            if (id == null) {
                return Json(new { success = false, message = "無效的訂單 ID" });
            }

            Console.WriteLine("取消訂單 ID: " + id); // 日誌輸出

            var data = await _context.Orders.FindAsync(id);
            if (data == null) {
                return Json(new { success = false, message = "找不到訂單" });
            }

            // 更新訂單狀態與取消時間
            data.OrderStatus = 4; // 訂單取消
            data.DeleteAt = DateTime.Now;

            try {
                // 保存更改
                _context.Update(data);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "訂單已取消" });
            }
            catch (Exception ex) {
                Console.WriteLine("取消訂單時出錯: " + ex.Message);
                return Json(new { success = false, message = "取消訂單失敗，請稍後再試" });
            }
        }

    }
}
