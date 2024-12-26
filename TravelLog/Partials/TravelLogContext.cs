﻿using Microsoft.EntityFrameworkCore;

namespace TravelLog.Partials {
    public partial class TravelLogContext : DbContext {

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
            if (!optionsBuilder.IsConfigured) {
                IConfiguration Config = new ConfigurationBuilder()
                    .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                    .AddJsonFile("appsettings.json")
                    .Build();
                optionsBuilder.UseSqlServer(Config.GetConnectionString("TravelLog"));
            }
        }
        public DbSet<Models.Order> Order { get; set; } = default!;
    }
}
