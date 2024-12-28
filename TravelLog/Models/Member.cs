using System;
using System.Collections.Generic;

namespace TravelLog.Models;

public partial class Member
{
    public int UserId { get; set; }

    public string UserName { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Phone { get; set; } = null!;

    public DateTime? Birthday { get; set; }

    public bool Gender { get; set; }

    public string Account { get; set; } = null!;

    public string Password { get; set; } = null!;

    public int Rights { get; set; }

    public DateTime CreatedAt { get; set; }
}
