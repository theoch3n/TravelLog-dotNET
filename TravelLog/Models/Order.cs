﻿using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Order
{
    /// <summary>
    /// 訂單 ID
    /// </summary>
    public int OrderId { get; set; }

    /// <summary>
    /// 下訂時間
    /// </summary>
    public DateTime OrderTime { get; set; }

    /// <summary>
    /// 訂單總金額
    /// </summary>
    public decimal OrderTotalAmount { get; set; }

    /// <summary>
    /// 取消訂單時間
    /// </summary>
    public DateTime? DeleteAt { get; set; }

    /// <summary>
    /// 連接用戶 ID
    /// </summary>
    public int UserId { get; set; }

    /// <summary>
    /// 連接訂單狀態 ID
    /// </summary>
    public int? OrderStatus { get; set; }

    public virtual OrderStatus? OrderStatusNavigation { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
