using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using TravelLog.Models;

namespace TravelLog.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class ChartController : ControllerBase {
        private readonly TravelLogContext _context;

        public ChartController(TravelLogContext context) {
            _context = context;
        }

        // 今日營業額
        [HttpGet("TodayRevenue")]
        public ActionResult<object> GetTodayRevenue() {
            try {
                var today = DateTime.Today;
                var tomorrow = today.AddDays(1);

                var totalAmount = _context.Orders
                    .Where(o => o.OrderTime >= today && o.OrderTime < tomorrow)
                    .Sum(o => o.OrderTotalAmount);

                return new { amount = totalAmount };
            }
            catch (Exception ex) {
                return StatusCode(500,
                    new { error = "獲取今日營業額時發生錯誤", message = ex.Message });
            }
        }

        // 營業額統計 (Revenue)
        [HttpGet("Revenue")]
        public ActionResult<IEnumerable<object>> GetRevenue(DateTime startDate, DateTime endDate) {
            try {
                // endDate 設定為當日的 23:59:59
                endDate = endDate.Date.AddDays(1).AddSeconds(-1);

                var orders = _context.Orders
                    .Where(o => o.OrderTime >= startDate && o.OrderTime <= endDate)
                    .Select(o => new {
                        // 只要年月日
                        OrderDate = new DateTime(
                            o.OrderTime.Year,
                            o.OrderTime.Month,
                            o.OrderTime.Day
                        ),
                        o.OrderTotalAmount
                    })
                    .ToList();

                var result = orders
                    .GroupBy(x => x.OrderDate)
                    .Select(g => new {
                        date = g.Key.ToString("yyyy-MM-dd"),
                        amount = g.Sum(x => x.OrderTotalAmount)
                    })
                    .OrderBy(x => x.date)
                    .ToList();

                return Ok(result);
            }
            catch (Exception ex) {
                return StatusCode(500,
                    new { error = "獲取營業額數據時發生錯誤", message = ex.Message });
            }
        }

        // 用戶增長 (UserGrowth)
        [HttpGet("UserGrowth")]
        public ActionResult<IEnumerable<object>> GetUserGrowth(DateTime startDate, DateTime endDate) {
            try {
                if (!_context.Database.CanConnect()) {
                    return StatusCode(500, new { error = "無法連接資料庫" });
                }

                endDate = endDate.Date.AddDays(1).AddSeconds(-1);

                // 同理，先抓出年月日
                var userList = _context.Users
                    .Where(u => u.UserCreateDate >= startDate && u.UserCreateDate <= endDate)
                    .Select(u => new {
                        CreateDate = new DateTime(
                            u.UserCreateDate.Year,
                            u.UserCreateDate.Month,
                            u.UserCreateDate.Day
                        )
                    })
                    .ToList();

                var result = userList
                    .GroupBy(u => u.CreateDate)
                    .Select(g => new {
                        date = g.Key.ToString("yyyy-MM-dd"),
                        newUsers = g.Count()
                    })
                    .OrderBy(x => x.date)
                    .ToList();

                return Ok(result);
            }
            catch (Exception ex) {
                return StatusCode(500,
                    new { error = "獲取用戶增長數據時發生錯誤", message = ex.Message });
            }
        }

        // 銷售概況 (SalesOverview)
        [HttpGet("SalesOverview")]
        public ActionResult<IEnumerable<object>> GetSalesOverview(DateTime startDate, DateTime endDate) {
            try {
                endDate = endDate.Date.AddDays(1).AddSeconds(-1);

                var orderList = _context.Orders
                    .Where(oi => oi.OrderTime >= startDate && oi.OrderTime <= endDate)
                    .Select(oi => new {
                        category = oi.Product.ItineraryTitle,
                        amount = oi.OrderTotalAmount
                    })
                    .ToList();

                var result = orderList
                    .GroupBy(x => x.category)
                    .Select(g => new {
                        category = g.Key ?? "未指定",
                        sales = g.Sum(x => x.amount)
                    })
                    .OrderByDescending(x => x.sales)
                    .ToList();

                return Ok(result);
            }
            catch (Exception ex) {
                return StatusCode(500,
                    $"獲取銷售概況數據時發生錯誤: {ex.Message}");
            }
        }

        // 熱門地點 (PopularPlaces)
        [HttpGet("PopularPlaces")]
        public ActionResult<IEnumerable<object>> GetPopularPlaces(DateTime startDate, DateTime endDate) {
            try {
                endDate = endDate.Date.AddDays(1).AddSeconds(-1);

                var mapList = _context.Maps
                    .Where(b => b.MapCreateDate >= startDate && b.MapCreateDate <= endDate)
                    .Select(b => new {
                        b.MapPlaceName
                    })
                    .ToList();

                var result = mapList
                    .GroupBy(b => b.MapPlaceName)
                    .Select(g => new {
                        place = g.Key,
                        count = g.Count()
                    })
                    .OrderByDescending(x => x.count)
                    .Take(10)
                    .ToList();

                return Ok(result);
            }
            catch (Exception ex) {
                return StatusCode(500,
                    $"獲取熱門地點數據時發生錯誤: {ex.Message}");
            }
        }
    }
}
