﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class Order
{
    /// <summary>
    /// 訂單 ID
    /// </summary>
    public int OrderId { get; set; }

    /// <summary>
    /// 綠界訂單交易編號
    /// </summary>
    public string MerchantTradeNo { get; set; }

    /// <summary>
    /// 訂單建立時間
    /// </summary>
    public DateTime OrderTime { get; set; }

    /// <summary>
    /// 訂單總金額
    /// </summary>
    public decimal OrderTotalAmount { get; set; }

    /// <summary>
    /// 刪除時間（可為 NULL）
    /// </summary>
    public DateTime? DeleteAt { get; set; }

    /// <summary>
    /// 使用者 ID（未來可接 User 表）
    /// </summary>
    public int UserId { get; set; }

    /// <summary>
    /// 訂單當前狀態
    /// </summary>
    public int OrderStatus { get; set; }

    /// <summary>
    /// 訂單付款狀態
    /// </summary>
    public int OrderPaymentStatus { get; set; }

    public virtual PaymentStatus OrderPaymentStatusNavigation { get; set; }

    public virtual OrderStatus OrderStatusNavigation { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}