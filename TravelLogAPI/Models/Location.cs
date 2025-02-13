namespace TravelLogAPI.Models
{
    public class Location
    {
        public int Itinerary_ID { get; set; }
        public string? Itinerary_Title { get; set; }
        public string? Itinerary_Location { get; set; }
        public string? Itinerary_Image { get; set; }
        public DateTime Itinerary_StartDate { get; set; }
        public DateTime Itinerary_EndDate { get; set; }
        public int ItineraryDetail_ID { get; set; }
        public int ItineraryDetail_Day { get; set; }
        public int ItineraryDetail_MapID { get; set; }
        public DateTime ItineraryDetail_StartDate { get; set; }
        public DateTime ItineraryDetail_EndDate { get; set; }
        public string? ItineraryDetail_Memo { get; set; }
        public int Id { get; set; }
        public int date { get; set; }
        public int scheduleId { get; set; }
        public string? Name { get; set; }
        public string? Address { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string? img { get; set; }
        public string? rating { get; set; }
    }
}
