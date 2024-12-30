﻿using System;
using System.Collections.Generic;

namespace TravelLog.Models;

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

    public virtual Order? Order { get; set; }
}
