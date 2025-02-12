using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using TravelLogAPI.DTO;
using TravelLogAPI.Models;

namespace TravelLogAPI.Controllers
{
    [EnableCors("VueSinglePage")]
    [Route("api/[controller]")]
    [ApiController]
    public class BillController : ControllerBase
    {
        private readonly TravelLogContext _context;
        public BillController(TravelLogContext context)
        {
            _context = context;
        }

        [HttpPost("[action]")]
        public async Task<IActionResult> AddBillWithDetails([FromBody] BillWithDetailsDto dto)
        {
            try
            {
                foreach (var detail in dto.Details)
                {
                    Console.WriteLine($"Detail MemberName: {detail.MemberName}, Amount: {detail.Amount}");
                }

                // 進行資料處理
                var bill = dto.Bill;
                var details = dto.Details;

                using (var transaction = await _context.Database.BeginTransactionAsync())
                {
                    _context.Bills.Add(bill);
                    await _context.SaveChangesAsync();

                    foreach (var detail in details)
                    {
                        detail.BillId = bill.Id;
                        _context.BillDetails.Add(detail);
                    }
                    await _context.SaveChangesAsync();

                    await transaction.CommitAsync();
                    return Ok(new { success = true, message = "Bill、BillDetails 成功新增至資料庫" });
                }
            }
            catch (Exception ex)
            {
                // 返回錯誤訊息
                return StatusCode(500, $"Internal Server Error: {ex.Message}\n{ex.StackTrace}");
            }
        }
    }
}
