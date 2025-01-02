﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace TravelLog.Models;

public partial class TravelLogContext : DbContext
{
    public TravelLogContext(DbContextOptions<TravelLogContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Itinerary> Itineraries { get; set; }

    public virtual DbSet<MemberInformation> MemberInformations { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderStatus> OrderStatuses { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<PaymentMethod> PaymentMethods { get; set; }

    public virtual DbSet<PaymentStatus> PaymentStatuses { get; set; }

    public virtual DbSet<ProductTicket> ProductTickets { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Itinerary>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__itinerar__3213E83F5D1B7128");

            entity.ToTable("itineraries");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Address)
                .IsRequired()
                .HasColumnType("text")
                .HasColumnName("address");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("created_at");
            entity.Property(e => e.Latitude).HasColumnName("latitude");
            entity.Property(e => e.Longitude).HasColumnName("longitude");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("name");
        });

        modelBuilder.Entity<MemberInformation>(entity =>
        {
            entity.HasKey(e => e.MiMemberId).HasName("PK__MemberIn__C80AA26203D706DB");

            entity.ToTable("MemberInformation");

            entity.HasIndex(e => e.MiEmail, "UQ__MemberIn__67B108C07053238D").IsUnique();

            entity.Property(e => e.MiMemberId).HasColumnName("MI_MemberID");
            entity.Property(e => e.MiAccountName)
                .IsRequired()
                .HasMaxLength(50)
                .HasColumnName("MI_AccountName");
            entity.Property(e => e.MiEmail)
                .IsRequired()
                .HasMaxLength(100)
                .HasColumnName("MI_Email");
            entity.Property(e => e.MiIsActive)
                .HasDefaultValue(true)
                .HasColumnName("MI_IsActive");
            entity.Property(e => e.MiPasswordHash)
                .IsRequired()
                .HasMaxLength(255)
                .HasColumnName("MI_PasswordHash");
            entity.Property(e => e.MiRegistrationDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("MI_RegistrationDate");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Order__46466601B81B5156");

            entity.ToTable("Order");

            entity.Property(e => e.OrderId)
                .HasComment("訂單 ID")
                .HasColumnName("order_Id");
            entity.Property(e => e.DeleteAt)
                .HasComment("取消訂單時間")
                .HasColumnType("datetime")
                .HasColumnName("delete_at");
            entity.Property(e => e.OrderStatus)
                .HasComment("連接訂單狀態 ID")
                .HasColumnName("order_Status");
            entity.Property(e => e.OrderTime)
                .HasComment("下訂時間")
                .HasColumnType("datetime")
                .HasColumnName("order_Time");
            entity.Property(e => e.OrderTotalAmount)
                .HasComment("訂單總金額")
                .HasColumnType("decimal(18, 0)")
                .HasColumnName("order_TotalAmount");
            entity.Property(e => e.UserId).HasColumnName("user_Id");

            entity.HasOne(d => d.OrderStatusNavigation).WithMany(p => p.Orders)
                .HasForeignKey(d => d.OrderStatus)
                .HasConstraintName("FK__Order__order_Sta__398D8EEE");
        });

        modelBuilder.Entity<OrderStatus>(entity =>
        {
            entity.HasKey(e => e.OsId).HasName("PK__Order_St__85A5060D820BBB6C");

            entity.ToTable("Order_Status");

            entity.Property(e => e.OsId).HasColumnName("OS_Id");
            entity.Property(e => e.OsOrderStatus)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnName("OS_OrderStatus");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__Payment__ED10C46231D29BCD");

            entity.ToTable("Payment");

            entity.Property(e => e.PaymentId)
                .HasComment("付款 ID")
                .HasColumnName("payment_Id");
            entity.Property(e => e.OrderId)
                .HasComment("連接訂單 ID")
                .HasColumnName("order_id");
            entity.Property(e => e.PaymentDeadline)
                .HasComment("付款期限")
                .HasColumnType("datetime")
                .HasColumnName("payment_Deadline");
            entity.Property(e => e.PaymentMethod)
                .HasComment("連接付款方式 ID")
                .HasColumnName("payment_Method");
            entity.Property(e => e.PaymentStatusId)
                .HasComment("連接付款狀態 ID")
                .HasColumnName("paymentStatus_Id");
            entity.Property(e => e.PaymentTime)
                .HasComment("付款時間")
                .HasColumnType("datetime")
                .HasColumnName("payment_Time");

            entity.HasOne(d => d.Order).WithMany(p => p.Payments)
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("FK__Payment__order_i__4316F928");

            entity.HasOne(d => d.PaymentMethodNavigation).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentMethod)
                .HasConstraintName("FK__Payment__payment__3F466844");

            entity.HasOne(d => d.PaymentStatus).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentStatusId)
                .HasConstraintName("FK__Payment__payment__440B1D61");
        });

        modelBuilder.Entity<PaymentMethod>(entity =>
        {
            entity.HasKey(e => e.PmId).HasName("PK__Payment___8E8EC76B6F4FC8B4");

            entity.ToTable("Payment_Method");

            entity.Property(e => e.PmId).HasColumnName("PM_Id");
            entity.Property(e => e.PaymentMethod1)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnName("payment_Method");
        });

        modelBuilder.Entity<PaymentStatus>(entity =>
        {
            entity.HasKey(e => e.PsId).HasName("PK__Payment___011947AC4C41BDD8");

            entity.ToTable("Payment_Status");

            entity.Property(e => e.PsId).HasColumnName("PS_Id");
            entity.Property(e => e.PaymentStatus1)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnName("payment_Status");
        });

        modelBuilder.Entity<ProductTicket>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Product_Ticket");

            entity.Property(e => e.OrderId).HasColumnName("order_Id");
            entity.Property(e => e.ProductId).HasColumnName("product_Id");
            entity.Property(e => e.TicketId).HasColumnName("ticket_Id");

            entity.HasOne(d => d.Order).WithMany()
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("FK__Product_T__order__3B75D760");
        });

        modelBuilder.Entity<SerialBase>(entity =>
        {
            entity.HasKey(e => e.SbSystemCode);

            entity.ToTable("SerialBase");

            entity.Property(e => e.SbSystemCode)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("系統代碼")
                .HasColumnName("SB_SystemCode");
            entity.Property(e => e.ModifiedDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("修改日期")
                .HasColumnType("datetime");
            entity.Property(e => e.SbCount)
                .HasComment("取號總數")
                .HasColumnName("SB_Count");
            entity.Property(e => e.SbSerial)
                .ValueGeneratedOnAdd()
                .HasComment("流水號")
                .HasColumnName("SB_Serial");
            entity.Property(e => e.SbSerialNumber)
                .IsRequired()
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("系統編號")
                .HasColumnName("SB_SerialNumber");
            entity.Property(e => e.SbSystemName)
                .IsRequired()
                .HasMaxLength(50)
                .HasDefaultValue("")
                .HasComment("代碼名稱")
                .HasColumnName("SB_SystemName");
        });

        modelBuilder.Entity<Ticket>(entity =>
        {
            entity.HasKey(e => e.TicketsId).HasName("PK__Tickets__EE5BBABB8B79CF4A");

            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.IsAvailable).HasDefaultValue(true);
            entity.Property(e => e.RefundPolicy)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.TicketsName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.TicketsType)
                .IsRequired()
                .HasMaxLength(20);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}