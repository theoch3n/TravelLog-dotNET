using System.ComponentModel;

namespace TravelLog.Models {
    public class TicketWrap {
        private Ticket _ticket;
        public Ticket ticket {
            get { return _ticket; }
            set { _ticket = value; }
        }
        public TicketWrap() {
            _ticket = new Ticket();
        }
        [DisplayName("票券編號")]
        public int TicketsId {
            get { return _ticket.TicketsId; }
            set { _ticket.TicketsId = value; }
        }

        [DisplayName("票券名稱")]
        public string TicketsName {
            get { return _ticket.TicketsName; }
            set { _ticket.TicketsName = value; }
        }
        [DisplayName("票卷類型")]
        public string TicketsType {
            get { return _ticket.TicketsType; }
            set { _ticket.TicketsType = value; }
        }
        [DisplayName("票券價格")]
        public int Price {
            get { return _ticket.Price; }
            set { _ticket.Price = value; }
        }
        [DisplayName("狀態")]
        public bool IsAvailable {
            get { return _ticket.IsAvailable; }
            set { _ticket.IsAvailable = value; }
        }
        [DisplayName("商品描述")]
        public string? Description {
            get { return _ticket.Description; }
            set { _ticket.Description = value; }
        }
        [DisplayName("退款政策")]
        public string RefundPolicy {
            get { return _ticket.RefundPolicy; }
            set { _ticket.RefundPolicy = value; }
        }
        [DisplayName("創建日期")]
        public DateTime? CreatedAt {
            get { return _ticket.CreatedAt; }
            set { _ticket.CreatedAt = value; }
        }
    }


}

