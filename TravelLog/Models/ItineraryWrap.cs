using System.ComponentModel;

namespace TravelLog.Models {
    public class ItineraryWrap {
        private Itinerary _itinerary;

        public ItineraryWrap() {
            _itinerary = new Itinerary();
        }

        public Itinerary itinerary {
            get { return _itinerary; }
            set { _itinerary = value; }
        }

        [DisplayName("行程編號")]
        public int ItineraryId {
            get { return _itinerary.ItineraryId; }
            set { _itinerary.ItineraryId = value; }
        }

        [DisplayName("行程名稱")]
        public string ItineraryTitle {
            get { return _itinerary.ItineraryTitle; }
            set { _itinerary.ItineraryTitle = value; }
        }

        [DisplayName("行程地點")]
        public string ItineraryLocation {
            get { return _itinerary.ItineraryLocation; }
            set { _itinerary.ItineraryLocation = value; }
        }

        [DisplayName("行程座標")]
        public string ItineraryCoordinate {
            get { return _itinerary.ItineraryCoordinate; }
            set { _itinerary.ItineraryCoordinate = value; }
        }

        [DisplayName("行程圖片")]
        public string ItineraryImage {
            get { return _itinerary.ItineraryImage; }
            set { _itinerary.ItineraryImage = value; }
        }

        [DisplayName("行程起始時間")]
        public DateTime ItineraryStartDate {
            get { return _itinerary.ItineraryStartDate; }
            set { _itinerary.ItineraryStartDate = value; }
        }

        [DisplayName("行程結束時間")]
        public DateTime ItineraryEndDate {
            get { return _itinerary.ItineraryEndDate; }
            set { _itinerary.ItineraryEndDate = value; }
        }

        [DisplayName("創建使用者")]
        public int? ItineraryCreateUser {
            get { return _itinerary.ItineraryCreateUser; }
            set { _itinerary.ItineraryCreateUser = value; }
        }
    }
}
