using TravelLog.Models;

namespace TravelLog.ViewModels {
    public class OrderManageWrap {

        public OrderManageWrap() {
            OrderStatuses = new List<OrderStatus>();
            PaymentStatuses = new List<PaymentStatus>();
        }

        /// <summary>
        /// 訂單狀態列表
        /// </summary>
        public List<OrderStatus> OrderStatuses { get; set; }
        /// <summary>
        /// 付款狀態列表
        /// </summary>
        public List<PaymentStatus> PaymentStatuses { get; set; }

        /// <summary>
        /// 訂單列表
        /// </summary>
        public List<OrderWrap> Orders { get; set; }

        /// <summary>
        /// 付款紀錄
        /// </summary>
        public List<Payment> Payments { get; set; }

        public MemberInformation MemberInformation { get; set; }

        /// <summary>
        /// 總訂單數量
        /// </summary>
        public int TotalOrders { get; set; }

        /// <summary>
        /// 當前頁碼
        /// </summary>
        public int CurrentPage { get; set; }

        /// <summary>
        /// 每頁顯示筆數
        /// </summary>
        public int PageSize { get; set; }

        /// <summary>
        /// 總頁數
        /// </summary>
        public int TotalPages { get; set; }

        /// <summary>
        /// 篩選：訂單狀態
        /// </summary>
        public int? FilterStatus { get; set; }

        /// <summary>
        /// 訂單狀態
        /// </summary>
        public string OrderStatusName { get; set; }

        /// <summary>
        /// 篩選：付款狀態
        /// </summary>
        public int? FilterPaymentStatus { get; set; }

        /// <summary>
        /// 付款狀態
        /// </summary>
        public string PaymentStatusName { get; set; }

        /// <summary>
        /// 篩選：開始日期
        /// </summary>
        public DateTime? FilterStartDate { get; set; }

        /// <summary>
        /// 篩選：結束日期
        /// </summary>
        public DateTime? FilterEndDate { get; set; }

        /// <summary>
        /// 排序欄位
        /// </summary>
        public string SortBy { get; set; } = "OrderTime";

        /// <summary>
        /// 是否降序排序
        /// </summary>
        public bool SortDescending { get; set; } = true;
    }
}