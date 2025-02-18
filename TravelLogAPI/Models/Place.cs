﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class Place
{
    /// <summary>
    /// 地點ID
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// 第幾天的行程
    /// </summary>
    public DateTime Date { get; set; }

    /// <summary>
    /// 連接行程id
    /// </summary>
    public int ScheduleId { get; set; }

    /// <summary>
    /// 景點名稱
    /// </summary>
    public string Name { get; set; }

    /// <summary>
    /// 地址
    /// </summary>
    public string Address { get; set; }

    /// <summary>
    /// 經度
    /// </summary>
    public double Latitude { get; set; }

    /// <summary>
    /// 緯度
    /// </summary>
    public double Longitude { get; set; }
}