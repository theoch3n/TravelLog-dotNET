﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class Schedule
{
    /// <summary>
    /// ScheduleID
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// 會員 ID
    /// </summary>
    public int UserId { get; set; }

    /// <summary>
    /// 行程名稱
    /// </summary>
    public string Name { get; set; }

    /// <summary>
    /// 目的地
    /// </summary>
    public string Destination { get; set; }

    /// <summary>
    /// 開始日期
    /// </summary>
    public DateOnly StartDate { get; set; }

    /// <summary>
    /// 結束日期
    /// </summary>
    public DateOnly EndDate { get; set; }

    public virtual ICollection<Location> Locations { get; set; } = new List<Location>();

    public virtual ICollection<Place> Places { get; set; } = new List<Place>();
}