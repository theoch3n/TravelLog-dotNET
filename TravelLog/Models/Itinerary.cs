﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Itinerary
{
    /// <summary>
    /// ID
    /// </summary>
    public int ItineraryId { get; set; }

    /// <summary>
    /// 行程名稱
    /// </summary>
    public string ItineraryTitle { get; set; }

    /// <summary>
    /// 行程圖片
    /// </summary>
    public string ItineraryImage { get; set; }

    /// <summary>
    /// 創建時間
    /// </summary>
    public DateTime ItineraryCreateDate { get; set; }

    public virtual ICollection<ItineraryDetail> ItineraryDetails { get; set; } = new List<ItineraryDetail>();
}