using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class SerialBase
{
    /// <summary>
    /// 流水號
    /// </summary>
    public int SbSerial { get; set; }

    /// <summary>
    /// 系統代碼
    /// </summary>
    public string SbSystemCode { get; set; } = null!;

    /// <summary>
    /// 代碼名稱
    /// </summary>
    public string SbSystemName { get; set; } = null!;

    /// <summary>
    /// 系統編號
    /// </summary>
    public string SbSerialNumber { get; set; } = null!;

    /// <summary>
    /// 取號總數
    /// </summary>
    public int SbCount { get; set; }

    /// <summary>
    /// 修改日期
    /// </summary>
    public DateTime ModifiedDate { get; set; }
}
