using System.ComponentModel;

namespace TravelLog.Models
{
    public class TourBundleWrap
    {
        private TourBundle _tourBundle;
        public TourBundle tourBundle
        { 
            get { return _tourBundle; }
            set { _tourBundle = value; }
        }
        public TourBundleWrap()
        {
            _tourBundle = new TourBundle();
        }
        [DisplayName("")]
        public int Id 
        {
            get { return _tourBundle.Id; }
            set { _tourBundle.Id = value; } 
        }
        [DisplayName("活動名稱")]
        public string EventName
        {
            get { return _tourBundle.EventName; }
            set { _tourBundle.EventName = value; }
        }
        [DisplayName("起始點")]
        public string StartingPoint 
        {
            get { return _tourBundle.StartingPoint; }
            set { _tourBundle.StartingPoint = value; } 
        }
        [DisplayName("目的地")]
        public string Destination
        {
            get { return _tourBundle.Destination; }
            set { _tourBundle.Destination = value; }
        }
        [DisplayName("開始日")]
        public DateTime FirstDate {

            get { return _tourBundle.FirstDate; }
            set { _tourBundle.FirstDate = value; } 
        }
        [DisplayName("結束日")]
        public DateTime LastDate {
 
            get { return _tourBundle.LastDate; }
            set { _tourBundle.LastDate = value; } 
        }
        [DisplayName("天數")]
        public int Duration {
      
            get { return _tourBundle.Duration; }
            set { _tourBundle.Duration = value; } 
        }
        [DisplayName("價格")]
        public int Price {
         
            get { return _tourBundle.Price; }
            set { _tourBundle.Price = value; } 
        }
        [DisplayName("活動敘述")]
        public string EventDescription 
        {
            get { return _tourBundle.EventDescription; }
            set { _tourBundle.EventDescription = value; } 
        }
        [DisplayName("評分")]
        public int? Ratings {
      
            get { return _tourBundle.Ratings; }
            set { _tourBundle.Ratings = value; } 
        }
        [DisplayName("聯絡方式")]
        public string ContactInfo {

            get { return _tourBundle.ContactInfo; }
            set { _tourBundle.ContactInfo = value; } 
        }
    }
}
