using System.ComponentModel;

namespace TravelLog.Models {
    public class OrderWrap {

        private Order _order;
        public Order order {
            get { return _order; }
            set { _order = value; }
        }

        public OrderWrap() {
            _order = new Order();
        }

        [DisplayName("訂單 ID")]
        public int OrderId {
            get { return _order.OrderId; }
            set { _order.OrderId = value; }
        }

        [DisplayName("綠界訂單交易編號")]
        public string? MerchantTradeNo {
            get { return _order.MerchantTradeNo; }
            set { _order.MerchantTradeNo = value; }
        }

        [DisplayName("訂單時間")]
        public DateTime OrderTime {
            get { return _order.OrderTime; }
            set { _order.OrderTime = value; }
        }

        [DisplayName("總金額")]
        public decimal OrderTotalAmount {
            get { return _order.OrderTotalAmount; }
            set { _order.OrderTotalAmount = value; }
        }

        [DisplayName("取消時間")]
        public DateTime? DeleteAt {
            get { return _order.DeleteAt; }
            set { _order.DeleteAt = value; }
        }

        [DisplayName("用戶 ID")]
        public int UserId {
            get { return _order.UserId; }
            set { _order.UserId = value; }
        }

        [DisplayName("訂單狀態")]
        public int OrderStatus {
            get { return _order.OrderStatus; }
            set { _order.OrderStatus = value; }
        }

        [DisplayName("付款狀態")]
        public int OrderPaymentStatus {
            get { return _order.OrderPaymentStatus; }
            set { _order.OrderPaymentStatus = value; }
        }

        [DisplayName("訂單狀態")]
        public string StatusName {
            get { return _order.OrderStatusNavigation?.OsOrderStatus ?? "未知"; }
            set { _order.OrderStatusNavigation.OsOrderStatus = value; }
        }

        [DisplayName("付款狀態名稱")]
        public string PaymentStatusName {
            get { return _order.OrderPaymentStatusNavigation?.PaymentStatus1 ?? "未知"; }
            set { _order.OrderPaymentStatusNavigation.PaymentStatus1 = value; }
        }

        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
        public virtual ICollection<OrderStatus> OrderStatuses { get; set; } = new List<OrderStatus>();
        public virtual ICollection<PaymentStatus> PaymentStatuses { get; set; } = new List<PaymentStatus>();

        //public virtual ICollection<MemberInformation> MemberInformation { get; set; } = new List<MemberInformation>();
    }
}
