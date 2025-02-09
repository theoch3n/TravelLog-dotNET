using System;
using System.Collections.Generic;
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

        [DisplayName("訂單狀態 ID")]
        public int OrderStatus {
            get { return _order.OrderStatus; }
            set { _order.OrderStatus = value; }
        }

        [DisplayName("訂單狀態名稱")]
        public string StatusName { get; set; }

        [DisplayName("付款狀態名稱")]
        public string PaymentStatusName { get; set; }

        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
    }
}
