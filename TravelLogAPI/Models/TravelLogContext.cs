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

    public virtual DbSet<Place> Places { get; set; }

    public virtual DbSet<TourBundle> TourBundles { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserPd> UserPds { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Place>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Place__3214EC075A059774");

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
            entity.HasKey(e => e.Id).HasName("PK__Tour_Bun__3213E83FCBE4659B");

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