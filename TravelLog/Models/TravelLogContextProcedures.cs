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
    public partial class TravelLogContext
    {
        private ITravelLogContextProcedures _procedures;

        public virtual ITravelLogContextProcedures Procedures
        {
            get
            {
                if (_procedures is null) _procedures = new TravelLogContextProcedures(this);
                return _procedures;
            }
            set
            {
                _procedures = value;
            }
        }

        public ITravelLogContextProcedures GetProcedures()
        {
            return Procedures;
        }
    }

    public partial class TravelLogContextProcedures : ITravelLogContextProcedures
    {
        private readonly TravelLogContext _context;

        public TravelLogContextProcedures(TravelLogContext context)
        {
            _context = context;
        }

        public virtual async Task<List<get_LocationResult>> get_LocationAsync(int? Itinerary_ID, DateOnly? StartDate, DateOnly? EndDate, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
        {
            var parameterreturnValue = new SqlParameter
            {
                ParameterName = "returnValue",
                Direction = System.Data.ParameterDirection.Output,
                SqlDbType = System.Data.SqlDbType.Int,
            };

            var sqlParameters = new []
            {
                new SqlParameter
                {
                    ParameterName = "Itinerary_ID",
                    Value = Itinerary_ID ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.Int,
                },
                new SqlParameter
                {
                    ParameterName = "StartDate",
                    Value = StartDate ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.Date,
                },
                new SqlParameter
                {
                    ParameterName = "EndDate",
                    Value = EndDate ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.Date,
                },
                parameterreturnValue,
            };
            var _ = await _context.SqlQueryAsync<get_LocationResult>("EXEC @returnValue = [dbo].[get_Location] @Itinerary_ID = @Itinerary_ID, @StartDate = @StartDate, @EndDate = @EndDate", sqlParameters, cancellationToken);

            returnValue?.SetValue(parameterreturnValue.Value);

            return _;
        }

        public virtual async Task<List<get_SerialNumberResult>> get_SerialNumberAsync(string SystemCode, int? AddDay, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
        {
            var parameterreturnValue = new SqlParameter
            {
                ParameterName = "returnValue",
                Direction = System.Data.ParameterDirection.Output,
                SqlDbType = System.Data.SqlDbType.Int,
            };

            var sqlParameters = new []
            {
                new SqlParameter
                {
                    ParameterName = "SystemCode",
                    Size = 10,
                    Value = SystemCode ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.VarChar,
                },
                new SqlParameter
                {
                    ParameterName = "AddDay",
                    Value = AddDay ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.Int,
                },
                parameterreturnValue,
            };
            var _ = await _context.SqlQueryAsync<get_SerialNumberResult>("EXEC @returnValue = [dbo].[get_SerialNumber] @SystemCode = @SystemCode, @AddDay = @AddDay", sqlParameters, cancellationToken);

            returnValue?.SetValue(parameterreturnValue.Value);

            return _;
        }
    }
}
