﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
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
    public string PaymentMethod1 { get; set; }

    /// <summary>
    /// 綠界付款方式代碼（例：Credit、ATM、CVS）
    /// </summary>
    public string PaymentMethodName { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}