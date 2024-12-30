using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class OrderStatus
{
    /// <summary>
    /// 訂單狀態 ID
    /// </summary>
    public int OsId { get; set; }

    /// <summary>
    /// 訂單狀態
    /// </summary>
    public string OsOrderStatus { get; set; } = null!;

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
}
