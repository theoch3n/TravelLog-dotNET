﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace TravelLogAPI.Models;

public partial class TravelLogContext : DbContext
{
    public TravelLogContext(DbContextOptions<TravelLogContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Itinerary> Itineraries { get; set; }

    public virtual DbSet<ItineraryDetail> ItineraryDetails { get; set; }

    public virtual DbSet<Place> Places { get; set; }

    public virtual DbSet<MemberInformation> MemberInformations { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderStatus> OrderStatuses { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<PaymentMethod> PaymentMethods { get; set; }

    public virtual DbSet<PaymentStatus> PaymentStatuses { get; set; }

    public virtual DbSet<Place> Places { get; set; }

    public virtual DbSet<ProductTicket> ProductTickets { get; set; }

    public virtual DbSet<Schedule> Schedules { get; set; }

    public virtual DbSet<SerialBase> SerialBases { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    public virtual DbSet<Bill> Bills { get; set; }

    public virtual DbSet<BillDetail> BillDetails { get; set; }

    public virtual DbSet<Place> Places { get; set; }

    public virtual DbSet<TourBundle> TourBundles { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserPd> UserPds { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Itinerary>(entity =>
        {
            entity.ToTable("Itinerary");

            entity.Property(e => e.ItineraryId)
                .HasComment("ID")
                .HasColumnName("Itinerary_ID");
            entity.Property(e => e.ItineraryCoordinate)
                .IsRequired()
                .HasMaxLength(200)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("行程座標")
                .HasColumnName("Itinerary_Coordinate");
            entity.Property(e => e.ItineraryCreateDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("創建時間")
                .HasColumnType("datetime")
                .HasColumnName("Itinerary_CreateDate");
            entity.Property(e => e.ItineraryEndDate)
                .HasComment("行程結束時間")
                .HasColumnType("datetime")
                .HasColumnName("Itinerary_EndDate");
            entity.Property(e => e.ItineraryImage)
                .IsRequired()
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("行程圖片")
                .HasColumnName("Itinerary_Image");
            entity.Property(e => e.ItineraryLocation)
                .IsRequired()
                .HasMaxLength(50)
                .HasDefaultValue("")
                .HasComment("行程地點")
                .HasColumnName("Itinerary_Location");
            entity.Property(e => e.ItineraryStartDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("行程起始時間")
                .HasColumnType("datetime")
                .HasColumnName("Itinerary_StartDate");
            entity.Property(e => e.ItineraryTitle)
                .IsRequired()
                .HasMaxLength(50)
                .HasDefaultValue("")
                .HasComment("行程名稱")
                .HasColumnName("Itinerary_Title");
        });

        modelBuilder.Entity<ItineraryDetail>(entity =>
        {
            entity.ToTable("Itinerary_Detail");

            entity.Property(e => e.ItineraryDetailId)
                .HasComment("ID")
                .HasColumnName("ItineraryDetail_ID");
            entity.Property(e => e.ItineraryDetailAccommodation)
                .HasComment("住宿 關聯 ProductType_ID")
                .HasColumnName("ItineraryDetail_Accommodation");
            entity.Property(e => e.ItineraryDetailCreateDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("創建時間")
                .HasColumnType("datetime")
                .HasColumnName("ItineraryDetail_CreateDate");
            entity.Property(e => e.ItineraryDetailDay)
                .HasComment("第幾天")
                .HasColumnName("ItineraryDetail_Day");
            entity.Property(e => e.ItineraryDetailEndDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("行程結束時間")
                .HasColumnType("datetime")
                .HasColumnName("ItineraryDetail_EndDate");
            entity.Property(e => e.ItineraryDetailGroup)
                .HasComment("群組")
                .HasColumnName("ItineraryDetail_Group");
            entity.Property(e => e.ItineraryDetailMapId)
                .HasComment("地點 關聯 Map_ID")
                .HasColumnName("ItineraryDetail_MapID");
            entity.Property(e => e.ItineraryDetailMemo)
                .IsRequired()
                .HasMaxLength(500)
                .HasDefaultValue("")
                .HasComment("行程備註")
                .HasColumnName("ItineraryDetail_Memo");
            entity.Property(e => e.ItineraryDetailProductTypeId)
                .HasComment("商品類別 關聯 ProductType_ID")
                .HasColumnName("ItineraryDetail_ProductTypeID");
            entity.Property(e => e.ItineraryDetailStartDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("行程起始時間")
                .HasColumnType("datetime")
                .HasColumnName("ItineraryDetail_StartDate");
            entity.Property(e => e.ItineraryId)
                .HasComment("外鍵")
                .HasColumnName("Itinerary_ID");
        });

        modelBuilder.Entity<Place>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Place__3214EC07C59269C5");

            entity.ToTable("Place");

            entity.Property(e => e.Address)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.Date).HasColumnName("date");
            entity.Property(e => e.Img)
                .IsRequired()
                .HasColumnName("img");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.Rating)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("rating");
            entity.Property(e => e.ScheduleId).HasColumnName("scheduleId");
        });

        modelBuilder.Entity<MemberInformation>(entity =>
        {
            entity.HasKey(e => e.MiMemberId).HasName("PK__MemberIn__C80AA262C98FE9E9");

            entity.ToTable("MemberInformation");

            entity.HasIndex(e => e.MiEmail, "UQ__MemberIn__67B108C0C1DD9D24").IsUnique();

            entity.Property(e => e.MiMemberId).HasColumnName("MI_MemberID");
            entity.Property(e => e.MiAccountName)
                .IsRequired()
                .HasMaxLength(50)
                .HasColumnName("MI_AccountName");
            entity.Property(e => e.MiEmail)
                .IsRequired()
                .HasMaxLength(100)
                .HasColumnName("MI_Email");
            entity.Property(e => e.MiEmailConfirmationToken).HasMaxLength(255);
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
            entity.HasKey(e => e.OrderId).HasName("PK__Order__4646660134F098FE");

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
                .HasConstraintName("FK__Order__order_Sta__38996AB5");
        });

        modelBuilder.Entity<OrderStatus>(entity =>
        {
            entity.HasKey(e => e.OsId).HasName("PK__Order_St__85A5060D255E1732");

            entity.ToTable("Order_Status");

            entity.Property(e => e.OsId)
                .HasComment("訂單狀態 ID")
                .HasColumnName("OS_Id");
            entity.Property(e => e.OsOrderStatus)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("訂單狀態")
                .HasColumnName("OS_OrderStatus");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__Payment__ED10C46203F2A115");

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
                .HasConstraintName("FK__Payment__order_i__412EB0B6");

            entity.HasOne(d => d.PaymentMethodNavigation).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentMethod)
                .HasConstraintName("FK__Payment__payment__4222D4EF");

            entity.HasOne(d => d.PaymentStatus).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentStatusId)
                .HasConstraintName("FK__Payment__payment__4316F928");
        });

        modelBuilder.Entity<PaymentMethod>(entity =>
        {
            entity.HasKey(e => e.PmId).HasName("PK__Payment___8E8EC76B96A8980F");

            entity.ToTable("Payment_Method");

            entity.Property(e => e.PmId)
                .HasComment("付款方式 ID")
                .HasColumnName("PM_Id");
            entity.Property(e => e.PaymentMethod1)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("付款方式")
                .HasColumnName("payment_Method");
        });

        modelBuilder.Entity<PaymentStatus>(entity =>
        {
            entity.HasKey(e => e.PsId).HasName("PK__Payment___011947ACDB447E3B");

            entity.ToTable("Payment_Status");

            entity.Property(e => e.PsId)
                .HasComment("付款狀態 ID")
                .HasColumnName("PS_Id");
            entity.Property(e => e.PaymentStatus1)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("付款狀態")
                .HasColumnName("payment_Status");
        });

        modelBuilder.Entity<Place>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Place__3214EC074DA103CD");

            entity.ToTable("Place");

            entity.Property(e => e.Address)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.Date)
                .HasColumnType("datetime")
                .HasColumnName("date");
            entity.Property(e => e.Img)
                .IsRequired()
                .HasColumnName("img");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.Rating)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("rating");
            entity.Property(e => e.ScheduleId).HasColumnName("scheduleId");
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
                .HasConstraintName("FK__Product_T__order__3E52440B");
        });

        modelBuilder.Entity<Schedule>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__schedule__3214EC07FE3BC0FE");

            entity.ToTable("schedule");

            entity.Property(e => e.Id).HasComment("行程ID");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("行程名稱");
            entity.Property(e => e.UserId)
                .HasComment("使用者ID")
                .HasColumnName("userId");
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
            entity.HasKey(e => e.TicketsId).HasName("PK__Tickets__EE5BBABBF725873A");

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

        modelBuilder.Entity<Bill>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Bill__3214EC074730CF58");

            entity.ToTable("Bill");

            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("Created_At");
            entity.Property(e => e.PaidBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Title)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TotalAmount)
                .HasColumnType("decimal(18, 0)")
                .HasColumnName("Total_Amount");
        });

        modelBuilder.Entity<BillDetail>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Bill_Det__3214EC070EE3CCCE");

            entity.ToTable("Bill_Details");

            entity.Property(e => e.Amount).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.BillId).HasColumnName("Bill_Id");
            entity.Property(e => e.MemberName)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnName("Member_Name");

            entity.HasOne(d => d.Bill).WithMany(p => p.BillDetails)
                .HasForeignKey(d => d.BillId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bill_Deta__Bill___498EEC8D");
        });

        modelBuilder.Entity<Place>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Place__3214EC070B0A9BF0");

            entity.ToTable("Place");

            entity.Property(e => e.Id).HasComment("地點ID");
            entity.Property(e => e.Address)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("地址");
            entity.Property(e => e.Date)
                .HasComment("第幾天的行程")
                .HasColumnName("date");
            entity.Property(e => e.Latitude).HasComment("經度");
            entity.Property(e => e.Longitude).HasComment("緯度");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("景點名稱");
            entity.Property(e => e.ScheduleId)
                .HasComment("連接行程id")
                .HasColumnName("scheduleId");
        });

        modelBuilder.Entity<TourBundle>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Tour_Bun__3213E83F8814B1C3");

            entity.ToTable("Tour_Bundles");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ContactInfo)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnName("contactInfo");
            entity.Property(e => e.Destination)
                .IsRequired()
                .HasMaxLength(40)
                .HasColumnName("destination");
            entity.Property(e => e.Duration).HasColumnName("duration");
            entity.Property(e => e.EventDescription)
                .IsRequired()
                .HasMaxLength(500)
                .HasColumnName("eventDescription");
            entity.Property(e => e.EventName)
                .IsRequired()
                .HasMaxLength(40)
                .HasColumnName("eventName");
            entity.Property(e => e.FirstDate)
                .HasColumnType("datetime")
                .HasColumnName("firstDate");
            entity.Property(e => e.LastDate)
                .HasColumnType("datetime")
                .HasColumnName("lastDate");
            entity.Property(e => e.Price).HasColumnName("price");
            entity.Property(e => e.Ratings).HasColumnName("ratings");
            entity.Property(e => e.StartingPoint)
                .IsRequired()
                .HasMaxLength(40)
                .HasColumnName("startingPoint");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("User");

            entity.Property(e => e.UserId)
                .HasComment("ID")
                .HasColumnName("User_ID");
            entity.Property(e => e.UserCreateDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("創建時間")
                .HasColumnType("datetime")
                .HasColumnName("User_CreateDate");
            entity.Property(e => e.UserEmail)
                .IsRequired()
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("信箱")
                .HasColumnName("User_Email");
            entity.Property(e => e.UserEnabled)
                .HasComment("啟用狀態  0 = 啟用, 1 = 關閉 ")
                .HasColumnName("User_Enabled");
            entity.Property(e => e.UserName)
                .IsRequired()
                .HasMaxLength(50)
                .HasDefaultValue("")
                .HasComment("使用者姓名")
                .HasColumnName("User_Name");
            entity.Property(e => e.UserPhone)
                .IsRequired()
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("手機")
                .HasColumnName("User_Phone");
        });

        modelBuilder.Entity<UserPd>(entity =>
        {
            entity.ToTable("User_PD");

            entity.Property(e => e.UserPdId)
                .HasComment("ID")
                .HasColumnName("UserPD_ID");
            entity.Property(e => e.UserId)
                .HasComment("外鍵")
                .HasColumnName("User_ID");
            entity.Property(e => e.UserPdCreateDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("創建時間")
                .HasColumnType("datetime")
                .HasColumnName("UserPD_CreateDate");
            entity.Property(e => e.UserPdPasswordHash)
                .HasMaxLength(256)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("密碼")
                .HasColumnName("UserPD_PasswordHash");
            entity.Property(e => e.UserPdToken)
                .IsRequired()
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("Token")
                .HasColumnName("UserPD_Token");

            entity.HasOne(d => d.User).WithMany(p => p.UserPds)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__User_ID");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}