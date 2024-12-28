﻿using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Payment
{
    /// <summary>
    /// 付款 ID
    /// </summary>
    public int PaymentId { get; set; }

    /// <summary>
    /// 付款期限
    /// </summary>
    public DateTime PaymentDeadline { get; set; }

    /// <summary>
    /// 付款時間
    /// </summary>
    public DateTime? PaymentTime { get; set; }

    /// <summary>
    /// 連接付款方式 ID
    /// </summary>
    public int? PaymentMethod { get; set; }

    /// <summary>
    /// 連接訂單 ID
    /// </summary>
    public int? OrderId { get; set; }

    /// <summary>
    /// 連接付款狀態 ID
    /// </summary>
    public int? PaymentStatusId { get; set; }

    public virtual Order? Order { get; set; }

    public virtual PaymentMethod? PaymentMethodNavigation { get; set; }

    public virtual PaymentStatus? PaymentStatus { get; set; }
}
