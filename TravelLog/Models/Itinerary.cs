using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Itinerary
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Address { get; set; } = null!;

    public double Latitude { get; set; }

    public double Longitude { get; set; }

    public DateTime? CreatedAt { get; set; }
}
