﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TravelLogAPI.Models
{
    public partial class get_LocationResult
    {
        public int Itinerary_ID { get; set; }
        [StringLength(50)]
        public string Itinerary_Title { get; set; }
        [StringLength(50)]
        public string Itinerary_Location { get; set; }
        [StringLength(2147483647)]
        public string Itinerary_Image { get; set; }
        public DateTime Itinerary_StartDate { get; set; }
        public DateTime Itinerary_EndDate { get; set; }
        public int? ItineraryDetail_ID { get; set; }
        public int? ItineraryDetail_Day { get; set; }
        public int? ItineraryDetail_MapID { get; set; }
        public DateTime? ItineraryDetail_StartDate { get; set; }
        public DateTime? ItineraryDetail_EndDate { get; set; }
        [StringLength(500)]
        public string ItineraryDetail_Memo { get; set; }
        public int? Id { get; set; }
        public DateOnly? date { get; set; }
        public int? scheduleId { get; set; }
        [StringLength(255)]
        public string Name { get; set; }
        [StringLength(255)]
        public string Address { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        [StringLength(2147483647)]
        public string img { get; set; }
        [StringLength(10)]
        public string rating { get; set; }
    }
}
