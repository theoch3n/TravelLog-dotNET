﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class ProductTicket
{
    /// <summary>
    /// 訂單 ID
    /// </summary>
    public int? OrderId { get; set; }

    /// <summary>
    /// 票券 ID
    /// </summary>
    public int? TicketId { get; set; }

    /// <summary>
    /// 商品 ID
    /// </summary>
    public int? ProductId { get; set; }
}