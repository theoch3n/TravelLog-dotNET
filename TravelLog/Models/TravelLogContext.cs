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

    public virtual DbSet<Member> Members { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderStatus> OrderStatuses { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<PaymentMethod> PaymentMethods { get; set; }

    public virtual DbSet<PaymentStatus> PaymentStatuses { get; set; }

    public virtual DbSet<ProductTicket> ProductTickets { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Member>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Members__1788CC4C8541171F");

            entity.HasIndex(e => e.Email, "UQ__Members__A9D1053438A2A77A").IsUnique();

            entity.Property(e => e.Account).HasMaxLength(50);
            entity.Property(e => e.Birthday).HasColumnType("datetime");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Password).HasMaxLength(255);
            entity.Property(e => e.Phone).HasMaxLength(20);
            entity.Property(e => e.UserName).HasMaxLength(50);
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Order__46466601A91F1684");

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
            entity.Property(e => e.UserId)
                .HasComment("連接用戶 ID")
                .HasColumnName("user_Id");

            entity.HasOne(d => d.OrderStatusNavigation).WithMany(p => p.Orders)
                .HasForeignKey(d => d.OrderStatus)
                .HasConstraintName("FK__Order__order_Sta__6C190EBB");
        });

        modelBuilder.Entity<OrderStatus>(entity =>
        {
            entity.HasKey(e => e.OsId).HasName("PK__Order_St__85A5060D157E2AA6");

            entity.ToTable("Order_Status");

            entity.Property(e => e.OsId)
                .HasComment("訂單狀態 ID")
                .HasColumnName("OS_Id");
            entity.Property(e => e.OsOrderStatus)
                .HasMaxLength(20)
                .HasComment("訂單狀態")
                .HasColumnName("OS_OrderStatus");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__Payment__ED10C462454BA82D");

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
                .HasConstraintName("FK__Payment__order_i__74AE54BC");

            entity.HasOne(d => d.PaymentMethodNavigation).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentMethod)
                .HasConstraintName("FK__Payment__payment__75A278F5");

            entity.HasOne(d => d.PaymentStatus).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentStatusId)
                .HasConstraintName("FK__Payment__payment__76969D2E");
        });

        modelBuilder.Entity<PaymentMethod>(entity =>
        {
            entity.HasKey(e => e.PmId).HasName("PK__Payment___8E8EC76B4C93703B");

            entity.ToTable("Payment_Method");

            entity.Property(e => e.PmId)
                .HasComment("付款方式 ID")
                .HasColumnName("PM_Id");
            entity.Property(e => e.PaymentMethod1)
                .HasMaxLength(20)
                .HasComment("付款方式")
                .HasColumnName("payment_Method");
        });

        modelBuilder.Entity<PaymentStatus>(entity =>
        {
            entity.HasKey(e => e.PsId).HasName("PK__Payment___011947ACED95A9E7");

            entity.ToTable("Payment_Status");

            entity.Property(e => e.PsId)
                .HasComment("付款狀態 ID")
                .HasColumnName("PS_Id");
            entity.Property(e => e.PaymentStatus1)
                .HasMaxLength(20)
                .HasComment("付款狀態")
                .HasColumnName("payment_Status");
        });

        modelBuilder.Entity<ProductTicket>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Product_Ticket");

            entity.Property(e => e.OrderId)
                .HasComment("訂單 ID")
                .HasColumnName("order_Id");
            entity.Property(e => e.ProductId)
                .HasComment("商品 ID")
                .HasColumnName("product_Id");
            entity.Property(e => e.TicketId)
                .HasComment("票券 ID")
                .HasColumnName("ticket_Id");

            entity.HasOne(d => d.Order).WithMany()
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("FK__Product_T__order__71D1E811");
        });

        modelBuilder.Entity<Ticket>(entity =>
        {
            entity.HasKey(e => e.TicketsId).HasName("PK__Tickets__EE5BBABB2748BF9A");

            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.IsAvailable).HasDefaultValue(true);
            entity.Property(e => e.RefundPolicy).HasMaxLength(255);
            entity.Property(e => e.TicketsName).HasMaxLength(100);
            entity.Property(e => e.TicketsType).HasMaxLength(20);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
