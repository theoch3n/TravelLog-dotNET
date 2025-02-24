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

    public virtual DbSet<Bill> Bills { get; set; }

    public virtual DbSet<BillDetail> BillDetails { get; set; }

    public virtual DbSet<ExternalLogin> ExternalLogins { get; set; }

    public virtual DbSet<Itinerary> Itineraries { get; set; }

    public virtual DbSet<ItineraryDetail> ItineraryDetails { get; set; }

    public virtual DbSet<ItineraryGroup> ItineraryGroups { get; set; }

    public virtual DbSet<Location> Locations { get; set; }

    public virtual DbSet<Map> Maps { get; set; }

    public virtual DbSet<MemberInformation> MemberInformations { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderStatus> OrderStatuses { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<PaymentMethod> PaymentMethods { get; set; }

    public virtual DbSet<PaymentStatus> PaymentStatuses { get; set; }

    public virtual DbSet<Place> Places { get; set; }

    public virtual DbSet<Schedule> Schedules { get; set; }

    public virtual DbSet<SerialBase> SerialBases { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    public virtual DbSet<TourBundle> TourBundles { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserPd> UserPds { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Bill>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Bill__3214EC07EFAED676");

            entity.ToTable("Bill");

            entity.HasIndex(e => e.ItineraryId, "IDX_Bill_Itinerary");

            entity.Property(e => e.Id).HasComment("帳單 ID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasComment("帳單建立時間")
                .HasColumnType("datetime")
                .HasColumnName("Created_At");
            entity.Property(e => e.ItineraryId)
                .HasComment("行程 ID")
                .HasColumnName("Itinerary_Id");
            entity.Property(e => e.PaidBy)
                .IsRequired()
                .HasMaxLength(50)
                .HasComment("付款人");
            entity.Property(e => e.Title)
                .IsRequired()
                .HasMaxLength(50)
                .HasComment("帳單標題");
            entity.Property(e => e.TotalAmount)
                .HasComment("總金額")
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("Total_Amount");

            entity.HasOne(d => d.Itinerary).WithMany(p => p.Bills)
                .HasForeignKey(d => d.ItineraryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Bill_Itinerary");
        });

        modelBuilder.Entity<BillDetail>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Bill_det__3214EC07463CDBE2");

            entity.ToTable("Bill_details");

            entity.HasIndex(e => e.BillId, "IDX_BillDetails_Bill");

            entity.Property(e => e.Id).HasComment("帳單明細 ID");
            entity.Property(e => e.Amount)
                .HasComment("分擔金額")
                .HasColumnType("decimal(18, 2)");
            entity.Property(e => e.BillId)
                .HasComment("關聯的帳單 ID")
                .HasColumnName("Bill_Id");
            entity.Property(e => e.MemberName)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("成員名稱")
                .HasColumnName("Member_Name");
            entity.Property(e => e.Paid).HasComment("是否已付款（0 = 未付款，1 = 已付款）");

            entity.HasOne(d => d.Bill).WithMany(p => p.BillDetails)
                .HasForeignKey(d => d.BillId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BillDetails_Bill");
        });

        modelBuilder.Entity<ExternalLogin>(entity =>
        {
            entity.HasKey(e => e.ExternalLoginId).HasName("PK__External__A8FDB3AE246B1FBE");

            entity.HasIndex(e => e.MiMemberId, "IDX_ExternalLogins_Member");

            entity.HasIndex(e => new { e.Provider, e.ProviderUserId }, "IX_ExternalLogins_Provider_ProviderUserId").IsUnique();

            entity.Property(e => e.ExternalLoginId).HasComment("外部登入 ID");
            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("(getdate())")
                .HasComment("創建時間")
                .HasColumnType("datetime");
            entity.Property(e => e.MiMemberId)
                .HasComment("關聯的會員 ID")
                .HasColumnName("MI_MemberID");
            entity.Property(e => e.Provider)
                .IsRequired()
                .HasMaxLength(50)
                .HasComment("外部登入提供者 (如 Google)");
            entity.Property(e => e.ProviderUserId)
                .IsRequired()
                .HasMaxLength(100)
                .HasComment("外部使用者唯一識別碼");

            entity.HasOne(d => d.MiMember).WithMany(p => p.ExternalLogins)
                .HasForeignKey(d => d.MiMemberId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ExternalLogins_MemberInformation");
        });

        modelBuilder.Entity<Itinerary>(entity =>
        {
            entity.HasKey(e => e.ItineraryId).HasName("PK__Itinerar__5BD05D1805581CBA");

            entity.ToTable("Itinerary");

            entity.HasIndex(e => e.ItineraryCreateUser, "IDX_Itinerary_CreateUser");

            entity.Property(e => e.ItineraryId)
                .HasComment("行程 ID")
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
            entity.Property(e => e.ItineraryCreateUser)
                .HasComment("創建使用者")
                .HasColumnName("Itinerary_CreateUser");
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
            entity.HasKey(e => e.ItineraryDetailId).HasName("PK__Itinerar__B2CF46AF754FA012");

            entity.ToTable("Itinerary_Detail");

            entity.HasIndex(e => e.ItineraryId, "IDX_ItineraryDetail_Itinerary");

            entity.HasIndex(e => e.ItineraryDetailMapId, "IDX_ItineraryDetail_Map");

            entity.Property(e => e.ItineraryDetailId)
                .ValueGeneratedNever()
                .HasComment("行程明細 ID")
                .HasColumnName("ItineraryDetail_ID");
            entity.Property(e => e.ItineraryDetailAccommodation)
                .HasComment("住宿 (關聯 ProductType_ID)")
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
                .HasComment("地點 (關聯 Map_ID)")
                .HasColumnName("ItineraryDetail_MapID");
            entity.Property(e => e.ItineraryDetailMemo)
                .IsRequired()
                .HasMaxLength(500)
                .HasDefaultValue("")
                .HasComment("行程備註")
                .HasColumnName("ItineraryDetail_Memo");
            entity.Property(e => e.ItineraryDetailProductTypeId)
                .HasComment("商品類別 (關聯 ProductType_ID)")
                .HasColumnName("ItineraryDetail_ProductTypeID");
            entity.Property(e => e.ItineraryDetailStartDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("行程起始時間")
                .HasColumnType("datetime")
                .HasColumnName("ItineraryDetail_StartDate");
            entity.Property(e => e.ItineraryId)
                .HasComment("關聯的行程 ID")
                .HasColumnName("Itinerary_ID");

            entity.HasOne(d => d.ItineraryDetailMap).WithMany(p => p.ItineraryDetails)
                .HasForeignKey(d => d.ItineraryDetailMapId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ItineraryDetail_Map");

            entity.HasOne(d => d.Itinerary).WithMany(p => p.ItineraryDetails)
                .HasForeignKey(d => d.ItineraryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ItineraryDetail_Itinerary");
        });

        modelBuilder.Entity<ItineraryGroup>(entity =>
        {
            entity.HasKey(e => e.ItineraryGroupId).HasName("PK__Itinerar__F3DE5D1E6ECCB887");

            entity.ToTable("Itinerary_Group");

            entity.HasIndex(e => e.ItineraryGroupItineraryId, "IDX_ItineraryGroup_Itinerary");

            entity.Property(e => e.ItineraryGroupId)
                .HasComment("群組 ID")
                .HasColumnName("ItineraryGroup_ID");
            entity.Property(e => e.ItineraryGroupItineraryId)
                .HasComment("關聯的行程 ID")
                .HasColumnName("ItineraryGroup_ItineraryID");
            entity.Property(e => e.ItineraryGroupUserEmail)
                .IsRequired()
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasDefaultValue("")
                .HasComment("使用者信箱")
                .HasColumnName("ItineraryGroup_UserEmail");

            entity.HasOne(d => d.ItineraryGroupItinerary).WithMany(p => p.ItineraryGroups)
                .HasForeignKey(d => d.ItineraryGroupItineraryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ItineraryGroup_Itinerary");
        });

        modelBuilder.Entity<Location>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Location__3213E83FEDC508E1");

            entity.ToTable("Location");

            entity.HasIndex(e => e.ScheduleId, "IDX_Location_Schedule");

            entity.HasIndex(e => e.UserId, "IDX_Location_User");

            entity.Property(e => e.Id)
                .HasComment("地點 ID")
                .HasColumnName("id");
            entity.Property(e => e.Attraction)
                .IsRequired()
                .HasMaxLength(100)
                .HasComment("景點")
                .HasColumnName("attraction");
            entity.Property(e => e.Date)
                .HasComment("日期")
                .HasColumnName("date");
            entity.Property(e => e.ScheduleId)
                .HasComment("關聯的行程 ID")
                .HasColumnName("schedule_id");
            entity.Property(e => e.UserId)
                .HasComment("會員 ID")
                .HasColumnName("user_id");

            entity.HasOne(d => d.Schedule).WithMany(p => p.Locations)
                .HasForeignKey(d => d.ScheduleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Location_Schedule");

            entity.HasOne(d => d.User).WithMany(p => p.Locations)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Location_User");
        });

        modelBuilder.Entity<Map>(entity =>
        {
            entity.HasKey(e => e.MapId).HasName("PK__Map__BD7A6209C5C08A43");

            entity.ToTable("Map");

            entity.Property(e => e.MapId)
                .HasComment("地點 ID")
                .HasColumnName("Map_ID");
            entity.Property(e => e.MapAddress)
                .IsRequired()
                .HasMaxLength(200)
                .HasDefaultValue("")
                .HasComment("地址")
                .HasColumnName("Map_Address");
            entity.Property(e => e.MapCreateDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("創建時間")
                .HasColumnType("datetime")
                .HasColumnName("Map_CreateDate");
            entity.Property(e => e.MapLatitude)
                .HasComment("緯度")
                .HasColumnName("Map_Latitude");
            entity.Property(e => e.MapLongitude)
                .HasComment("經度")
                .HasColumnName("Map_Longitude");
            entity.Property(e => e.MapPlaceName)
                .IsRequired()
                .HasMaxLength(50)
                .HasDefaultValue("")
                .HasComment("地點名稱")
                .HasColumnName("Map_PlaceName");
        });

        modelBuilder.Entity<MemberInformation>(entity =>
        {
            entity.HasKey(e => e.MiMemberId).HasName("PK__MemberIn__C80AA262C4590396");

            entity.ToTable("MemberInformation");

            entity.HasIndex(e => e.MiEmail, "UQ_MemberInformation_Email")
                .IsUnique()
                .HasFilter("([MI_Email] IS NOT NULL)");

            entity.Property(e => e.MiMemberId)
                .HasComment("會員 ID")
                .HasColumnName("MI_MemberID");
            entity.Property(e => e.MiAccountName)
                .IsRequired()
                .HasMaxLength(50)
                .HasComment("帳戶名稱")
                .HasColumnName("MI_AccountName");
            entity.Property(e => e.MiEmail)
                .IsRequired()
                .HasMaxLength(100)
                .HasComment("電子郵件")
                .HasColumnName("MI_Email");
            entity.Property(e => e.MiEmailConfirmationToken)
                .HasMaxLength(255)
                .HasComment("電子郵件確認令牌");
            entity.Property(e => e.MiIsActive)
                .HasDefaultValue(true)
                .HasComment("是否啟用 (0 = 未啟用, 1 = 啟用)")
                .HasColumnName("MI_IsActive");
            entity.Property(e => e.MiPasswordHash)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("密碼雜湊")
                .HasColumnName("MI_PasswordHash");
            entity.Property(e => e.MiRegistrationDate)
                .HasDefaultValueSql("(getdate())")
                .HasComment("註冊時間")
                .HasColumnType("datetime")
                .HasColumnName("MI_RegistrationDate");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Order__46466601B423B8EA");

            entity.ToTable("Order");

            entity.HasIndex(e => e.OrderPaymentStatus, "IDX_Order_PaymentStatus");

            entity.HasIndex(e => e.OrderStatus, "IDX_Order_Status");

            entity.HasIndex(e => e.MerchantTradeNo, "UQ__Order__0528F4AE1687EE08").IsUnique();

            entity.Property(e => e.OrderId)
                .HasComment("訂單 ID")
                .HasColumnName("order_Id");
            entity.Property(e => e.DeleteAt)
                .HasComment("刪除時間（可為 NULL）")
                .HasColumnType("datetime")
                .HasColumnName("delete_at");
            entity.Property(e => e.MerchantTradeNo)
                .IsRequired()
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasComment("綠界訂單交易編號")
                .HasColumnName("merchant_TradeNo");
            entity.Property(e => e.OrderPaymentStatus)
                .HasComment("訂單付款狀態")
                .HasColumnName("order_PaymentStatus");
            entity.Property(e => e.OrderStatus)
                .HasComment("訂單當前狀態")
                .HasColumnName("order_Status");
            entity.Property(e => e.OrderTime)
                .HasDefaultValueSql("(getdate())")
                .HasComment("訂單建立時間")
                .HasColumnType("datetime")
                .HasColumnName("order_Time");
            entity.Property(e => e.OrderTotalAmount)
                .HasComment("訂單總金額")
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("order_TotalAmount");
            entity.Property(e => e.UserId)
                .HasComment("使用者 ID")
                .HasColumnName("user_Id");

            entity.HasOne(d => d.OrderPaymentStatusNavigation).WithMany(p => p.Orders)
                .HasForeignKey(d => d.OrderPaymentStatus)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Order_PaymentStatus");

            entity.HasOne(d => d.OrderStatusNavigation).WithMany(p => p.Orders)
                .HasForeignKey(d => d.OrderStatus)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Order_OrderStatus");

            entity.HasOne(d => d.User).WithMany(p => p.Orders)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Order_User");
        });

        modelBuilder.Entity<OrderStatus>(entity =>
        {
            entity.HasKey(e => e.OsId).HasName("PK__Order_St__85A5060D402D46FC");

            entity.ToTable("Order_Status");

            entity.Property(e => e.OsId)
                .HasComment("訂單狀態 ID")
                .HasColumnName("OS_Id");
            entity.Property(e => e.OsOrderStatus)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("訂單狀態名稱（例：待付款、已付款、已取消）")
                .HasColumnName("OS_OrderStatus");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__Payment__ED10C462C304B86F");

            entity.ToTable("Payment");

            entity.HasIndex(e => e.PaymentMethod, "IDX_Payment_Method");

            entity.HasIndex(e => e.OrderId, "IDX_Payment_Order");

            entity.HasIndex(e => e.PaymentStatusId, "IDX_Payment_Status");

            entity.HasIndex(e => e.EcpayTransactionId, "UQ_Payment_ECPay")
                .IsUnique()
                .HasFilter("([ECPay_TransactionId] IS NOT NULL)");

            entity.Property(e => e.PaymentId)
                .HasComment("付款 ID")
                .HasColumnName("payment_Id");
            entity.Property(e => e.EcpayTransactionId)
                .HasMaxLength(50)
                .HasComment("綠界交易編號")
                .HasColumnName("ECPay_TransactionId");
            entity.Property(e => e.OrderId)
                .HasComment("關聯的訂單")
                .HasColumnName("order_Id");
            entity.Property(e => e.PaymentMethod)
                .HasComment("付款方式")
                .HasColumnName("payment_Method");
            entity.Property(e => e.PaymentMethodName)
                .HasComment("綠界回傳付款方式")
                .HasColumnName("payment_MethodName");
            entity.Property(e => e.PaymentStatusId)
                .HasComment("付款狀態")
                .HasColumnName("paymentStatus_Id");
            entity.Property(e => e.PaymentTime)
                .HasComment("付款成功時間（成功付款才有值）")
                .HasColumnType("datetime")
                .HasColumnName("payment_Time");

            entity.HasOne(d => d.Order).WithMany(p => p.Payments)
                .HasForeignKey(d => d.OrderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Payment_Order");

            entity.HasOne(d => d.PaymentMethodNavigation).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentMethod)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Payment_Method");

            entity.HasOne(d => d.PaymentStatus).WithMany(p => p.Payments)
                .HasForeignKey(d => d.PaymentStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Payment_Status");
        });

        modelBuilder.Entity<PaymentMethod>(entity =>
        {
            entity.HasKey(e => e.PmId).HasName("PK__Payment___8E8EC76B2CD4A9C1");

            entity.ToTable("Payment_Method");

            entity.HasIndex(e => e.PaymentMethodCode, "UQ__Payment___22287870BB1EA4B2").IsUnique();

            entity.Property(e => e.PmId)
                .HasComment("付款方式 ID")
                .HasColumnName("PM_Id");
            entity.Property(e => e.PaymentMethod1)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("付款方式名稱（例：信用卡、ATM 轉帳）")
                .HasColumnName("payment_Method");
            entity.Property(e => e.PaymentMethodCode)
                .IsRequired()
                .HasMaxLength(50)
                .HasComment("綠界付款方式代碼（例：Credit、ATM、CVS）")
                .HasColumnName("payment_MethodCode");
        });

        modelBuilder.Entity<PaymentStatus>(entity =>
        {
            entity.HasKey(e => e.PsId).HasName("PK__Payment___011947ACE0CFE36E");

            entity.ToTable("Payment_Status");

            entity.Property(e => e.PsId)
                .HasComment("付款狀態 ID")
                .HasColumnName("PS_Id");
            entity.Property(e => e.PaymentStatus1)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("付款狀態名稱（例：Pending、Paid、Refunded）")
                .HasColumnName("payment_Status");
        });

        modelBuilder.Entity<Place>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Place__3214EC073FB0D6ED");

            entity.ToTable("Place");

            entity.HasIndex(e => e.ScheduleId, "IDX_Place_Schedule");

            entity.Property(e => e.Id).HasComment("地點 ID");
            entity.Property(e => e.Address)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("地址");
            entity.Property(e => e.Date)
                .HasComment("日期時間")
                .HasColumnName("date");
            entity.Property(e => e.Img)
                .IsRequired()
                .HasComment("圖片")
                .HasColumnName("img");
            entity.Property(e => e.Latitude).HasComment("緯度");
            entity.Property(e => e.Longitude).HasComment("經度");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("名稱");
            entity.Property(e => e.Rating)
                .IsRequired()
                .HasMaxLength(10)
                .HasComment("評分")
                .HasColumnName("rating");
            entity.Property(e => e.ScheduleId)
                .HasComment("關聯的行程 ID")
                .HasColumnName("scheduleId");

            entity.HasOne(d => d.Schedule).WithMany(p => p.Places)
                .HasForeignKey(d => d.ScheduleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Place_Schedule");
        });

        modelBuilder.Entity<Schedule>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Schedule__3213E83F90B39D9E");

            entity.ToTable("Schedule");

            entity.HasIndex(e => e.UserId, "IDX_Schedule_User");

            entity.Property(e => e.Id)
                .HasComment("行程 ID")
                .HasColumnName("id");
            entity.Property(e => e.Destination)
                .IsRequired()
                .HasMaxLength(100)
                .HasComment("目的地")
                .HasColumnName("destination");
            entity.Property(e => e.EndDate)
                .HasComment("結束日期")
                .HasColumnName("end_date");
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(100)
                .HasComment("行程名稱")
                .HasColumnName("name");
            entity.Property(e => e.StartDate)
                .HasComment("開始日期")
                .HasColumnName("start_date");
            entity.Property(e => e.UserId)
                .HasComment("會員 ID")
                .HasColumnName("user_id");
        });

        modelBuilder.Entity<SerialBase>(entity =>
        {
            entity.HasKey(e => e.SbSystemCode).HasName("PK__SerialBa__DB3DE76EFD932076");

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
            entity.HasKey(e => e.TicketsId).HasName("PK__Tickets__EE5BBABBFD6795CE");

            entity.HasIndex(e => e.TicketsType, "IDX_Tickets_Type");

            entity.Property(e => e.TicketsId).HasComment("票務 ID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasComment("票務創建日期")
                .HasColumnType("datetime");
            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .HasComment("票務描述");
            entity.Property(e => e.IsAvailable)
                .HasDefaultValue(true)
                .HasComment("票務狀態 (0 = 不可用, 1 = 可用)");
            entity.Property(e => e.Price).HasComment("票務價格");
            entity.Property(e => e.RefundPolicy)
                .IsRequired()
                .HasMaxLength(255)
                .HasComment("票務退款政策");
            entity.Property(e => e.TicketsName)
                .IsRequired()
                .HasMaxLength(100)
                .HasComment("票務名稱");
            entity.Property(e => e.TicketsType)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("票務種類");
        });

        modelBuilder.Entity<TourBundle>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Tour_Bun__3213E83FCA6D3253");

            entity.ToTable("Tour_Bundles");

            entity.Property(e => e.Id)
                .HasComment("套裝行程 ID")
                .HasColumnName("id");
            entity.Property(e => e.ContactInfo)
                .IsRequired()
                .HasMaxLength(20)
                .HasComment("聯絡方式")
                .HasColumnName("contactInfo");
            entity.Property(e => e.Destination)
                .IsRequired()
                .HasMaxLength(40)
                .HasComment("目的地")
                .HasColumnName("destination");
            entity.Property(e => e.Duration)
                .HasComment("天數")
                .HasColumnName("duration");
            entity.Property(e => e.EventDescription)
                .IsRequired()
                .HasMaxLength(500)
                .HasComment("描述")
                .HasColumnName("eventDescription");
            entity.Property(e => e.EventName)
                .IsRequired()
                .HasMaxLength(40)
                .HasComment("活動名稱")
                .HasColumnName("eventName");
            entity.Property(e => e.FirstDate)
                .HasComment("開始日期")
                .HasColumnType("datetime")
                .HasColumnName("firstDate");
            entity.Property(e => e.LastDate)
                .HasComment("結束日期")
                .HasColumnType("datetime")
                .HasColumnName("lastDate");
            entity.Property(e => e.Price)
                .HasComment("價格")
                .HasColumnName("price");
            entity.Property(e => e.Ratings)
                .HasComment("評分")
                .HasColumnName("ratings");
            entity.Property(e => e.StartingPoint)
                .IsRequired()
                .HasMaxLength(40)
                .HasComment("起始地")
                .HasColumnName("startingPoint");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__User__206D91906084FFDC");

            entity.ToTable("User");

            entity.Property(e => e.UserId)
                .HasComment("使用者 ID")
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
                .HasComment("啟用狀態 (0 = 未啟用, 1 = 啟用)")
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
            entity.HasKey(e => e.UserPdId).HasName("PK__User_PD__F5CC275DC4E1672A");

            entity.ToTable("User_PD");

            entity.HasIndex(e => e.UserId, "IDX_UserPD_User");

            entity.Property(e => e.UserPdId)
                .HasComment("使用者密碼資料 ID")
                .HasColumnName("UserPD_ID");
            entity.Property(e => e.UserId)
                .HasComment("關聯的 User ID")
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
                .HasComment("密碼雜湊")
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
                .HasConstraintName("FK_UserPD_User");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}