﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class PlaceDetail
{
    public int Id { get; set; }

    public int? ItineraryId { get; set; }

    public int? PlaceId { get; set; }

    public string Detail { get; set; }

    public virtual Itinerary Itinerary { get; set; }

    public virtual Place Place { get; set; }
}