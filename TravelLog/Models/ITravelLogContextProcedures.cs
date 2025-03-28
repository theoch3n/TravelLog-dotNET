﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading;
using System.Threading.Tasks;
using TravelLog.Models;

namespace TravelLog.Models
{
    public partial interface ITravelLogContextProcedures
    {
        Task<List<get_LocationResult>> get_LocationAsync(int? Itinerary_ID, DateOnly? StartDate, DateOnly? EndDate, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default);
        Task<List<get_SerialNumberResult>> get_SerialNumberAsync(string SystemCode, int? AddDay, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default);
    }
}
