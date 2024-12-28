using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Ticket
{
    public int TicketsId { get; set; }

    public string TicketsName { get; set; } = null!;

    public string TicketsType { get; set; } = null!;

    public int Price { get; set; }

    public bool IsAvailable { get; set; }

    public string? Description { get; set; }

    public string RefundPolicy { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }
}
