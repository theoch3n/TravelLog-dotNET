using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Schedule
{
    /// <summary>
    /// 行程ID
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// 行程名稱
    /// </summary>
    public string Name { get; set; } = null!;

    /// <summary>
    /// 使用者ID
    /// </summary>
    public int UserId { get; set; }
}
