using TravelLogAPI.Models;

namespace TravelLogAPI.DTO
{
    public class BillWithDetailsDto
    {
        public Bill Bill { get; set; }
        public List<BillDetail> Details { get; set; }
    }
}
