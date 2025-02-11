using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// 註冊 DbContext，只需一次
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

// 設定 CORS 策略，允許來自 Vue 應用的請求 (例如 http://localhost:5173 與 http://localhost:5182)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowVueApp", policy =>
        policy.WithOrigins
        ("http://localhost:5173", "http://localhost:5182")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials());
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// 如果處於開發環境，啟用 Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// 啟用 CORS，請確保在 UseHttpsRedirection 與 UseAuthorization 之前呼叫
app.UseCors("AllowVueApp");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
