﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Place
{
    public int Id { get; set; }

    public DateOnly Date { get; set; }

    public int ScheduleId { get; set; }

    public string Name { get; set; }

    public string Address { get; set; }

    public double Latitude { get; set; }

    public double Longitude { get; set; }

    public string Img { get; set; }

    public string Rating { get; set; }
}