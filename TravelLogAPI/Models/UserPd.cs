﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace TravelLogAPI.Models;

public partial class UserPd
{
    /// <summary>
    /// ID
    /// </summary>
    public int UserPdId { get; set; }

    /// <summary>
    /// 外鍵
    /// </summary>
    public int UserId { get; set; }

    /// <summary>
    /// 密碼
    /// </summary>
    public string UserPdPasswordHash { get; set; }

    /// <summary>
    /// Token
    /// </summary>
    public string UserPdToken { get; set; }

    /// <summary>
    /// 創建時間
    /// </summary>
    public DateTime UserPdCreateDate { get; set; }

    public DateTime TokenCreateDate { get; set; }

    public virtual User User { get; set; }
}