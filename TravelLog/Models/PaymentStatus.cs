using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class PaymentStatus
{
    /// <summary>
    /// 付款狀態 ID
    /// </summary>
    public int PsId { get; set; }

    /// <summary>
    /// 付款狀態
    /// </summary>
    public string PaymentStatus1 { get; set; } = null!;

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
