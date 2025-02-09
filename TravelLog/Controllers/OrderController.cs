using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;

namespace TravelLog.Controllers {
    public class OrderController : Controller {
        private readonly TravelLogContext _context;

        public OrderController(TravelLogContext context) {
            _context = context;
        }

        // 訂單管理頁面
        // GET: Order/OrderManage
        [HttpGet]
        public async Task<IActionResult> OrderManage(
            int? status = null,
            int? paymentStatus = null,
            DateTime? startDate = null,
            DateTime? endDate = null,
            string sortBy = "OrderTime",
            bool descending = true,
            int page = 1,
            int pageSize = 10)
        {
            var orderManageWrap = new OrderManageWrap {
                FilterStatus = status,
                FilterPaymentStatus = paymentStatus,
                FilterStartDate = startDate,
                FilterEndDate = endDate,
                SortBy = sortBy,
                SortDescending = descending,
                CurrentPage = page,
                PageSize = pageSize
            };
            // 查詢訂單
            var query = _context.Orders
                .Include(o => o.OrderStatusNavigation)
                .Include(o => o.OrderPaymentStatusNavigation)
                .Include(o => o.Payments)
                .AsQueryable();
            // 篩選條件
            if (status.HasValue) {
                query = query.Where(o => o.OrderStatus == status.Value);
            }
            if (paymentStatus.HasValue) {
                query = query.Where(o => o.OrderPaymentStatus == paymentStatus.Value);
            }
            if (startDate.HasValue) {
                query = query.Where(o => o.OrderTime >= startDate.Value);
            }
            if (endDate.HasValue) {
                query = query.Where(o => o.OrderTime <= endDate.Value);
            }
            // 訂單排序
            query = sortBy switch {
                "OrderTotalAmount" => descending
                    ? query.OrderByDescending(o => o.OrderTotalAmount)
                    : query.OrderBy(o => o.OrderTotalAmount),
                _ => descending
                    ? query.OrderByDescending(o => o.OrderTime)
                    : query.OrderBy(o => o.OrderTime)
            };
            // 分頁
            orderManageWrap.TotalOrders = await query.CountAsync();
            orderManageWrap.TotalPages = (int)Math.Ceiling((double)orderManageWrap.TotalOrders / orderManageWrap.PageSize);
            var orders = await query
                // Skip() 跳過前面 pageSize * (page - 1) 筆資料
                .Skip((orderManageWrap.CurrentPage - 1) * orderManageWrap.PageSize)
                // Take() 只取 pageSize 筆資料
                .Take(orderManageWrap.PageSize)
                .ToListAsync();
            orderManageWrap.Orders = orders.Select(o => new OrderWrap {
                order = o,
                StatusName = o.OrderStatusNavigation?.OsOrderStatus,
                PaymentStatusName = o.OrderPaymentStatusNavigation?.PsPaymentStatus
            }).ToList();

            return View(orderManageWrap);
        }

        // 訂單詳細資料
        // GET: Order/OrderDetail
        [HttpGet]
        public async Task<IActionResult> OrderDetail(int? id) {
            if (id == null) {
                return RedirectToAction("OrderManage");
            }

            try {
                var data = await _context.Orders
                    .Include(o => o.OrderStatusNavigation)
                    .Include(o => o.OrderPaymentStatusNavigation)
                    .Include(o => o.Payments)
                    .FirstOrDefaultAsync(o => o.OrderId == id);

                if (data == null) {
                    return RedirectToAction("OrderManage");
                }

                var orderWrap = new OrderWrap {
                    order = data,
                    StatusName = data.OrderStatusNavigation?.OsOrderStatus,
                    PaymentStatusName = data.OrderPaymentStatusNavigation?.PsPaymentStatus,
                    Payments = data.Payments.ToList()
                };

                return View(orderWrap);
            }
            catch (Exception ex) {
                return View("Error", new ErrorViewModel {
                    RequestId = HttpContext.TraceIdentifier
                });
            }
        }


        // 訂單編輯頁面
        // GET: Order/OrderEdit
        [HttpGet]
        public async Task<IActionResult> OrderEdit(int? id) {
            if (id == null) {
                return RedirectToAction("OrderManage");
            }

            try {
                var data = await _context.Orders.FindAsync(id);
                if (data == null) {
                    return RedirectToAction("OrderManage");
                }
                var orderWrap = new OrderWrap {
                    order = data
                };
                return View(orderWrap);
            }
            catch (Exception ex) {
                return View("Error", new ErrorViewModel {
                    RequestId = HttpContext.TraceIdentifier
                });
            }
        }

        // 儲存編輯的訂單
        // POST: Order/SaveEdit
        [HttpPost]
        public async Task<IActionResult> SaveEdit(OrderWrap orderWrap) {
            try {
                if (ModelState.IsValid) {
                    _context.Update(orderWrap.order);
                    await _context.SaveChangesAsync();
                    return RedirectToAction("OrderManage");
                }
                return View(orderWrap);
            }
            catch (Exception ex) {
                return View("Error", new ErrorViewModel {
                    RequestId = HttpContext.TraceIdentifier
                });
            }
        }

        // 取消訂單
        // POST: Order/Cancel
        [HttpPost]
        public async Task<IActionResult> Cancel([FromBody] int? id) {
            if (id == null) {
                return Json(new { success = false, message = "無效的訂單 ID" });
            }

            try {
                var data = await _context.Orders
                    .Include(o => o.OrderStatusNavigation)
                    .FirstOrDefaultAsync(o => o.OrderId == id);

                if (data == null) {
                    return Json(new { success = false, message = "找不到訂單" });
                }

                if (data.OrderStatus == 3) {
                    return Json(new { success = false, message = "訂單已取消" });
                }

                data.OrderStatus = 3;
                data.DeleteAt = DateTime.Now;

                _context.Update(data);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "訂單已取消" });
            }
            catch (Exception ex) {
                return Json(new { success = false, message = "取消訂單失敗，請稍後再試" });
            }
        }

    }
}