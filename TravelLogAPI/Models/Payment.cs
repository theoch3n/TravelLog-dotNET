﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class Payment
{
    public int PaymentId { get; set; }

    public DateTime? PaymentTime { get; set; }

    public int PaymentMethod { get; set; }

    /// <summary>
    /// 綠界回傳付款方式
    /// </summary>
    public int? PaymentMethodName { get; set; }

    /// <summary>
    /// 關聯的訂單
    /// </summary>
    public int OrderId { get; set; }

    public int PaymentStatusId { get; set; }

    public string EcpayTransactionId { get; set; }

    public virtual Order Order { get; set; }

    public virtual PaymentMethod PaymentMethodNavigation { get; set; }

    public virtual PaymentStatus PaymentStatus { get; set; }
}