﻿using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class PaymentMethod
{
    /// <summary>
    /// 付款方式 ID
    /// </summary>
    public int PmId { get; set; }

    /// <summary>
    /// 付款方式
    /// </summary>
    public string PaymentMethod1 { get; set; } = null!;

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
