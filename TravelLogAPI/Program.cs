using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the DI container.
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

//CORS
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options => {
    options.AddPolicy(
        name: PolicyName,
        policy => policy.WithOrigins("*").WithMethods("*").WithHeaders("*"));
});





// 註冊 SignalR
builder.Services.AddSignalR();



builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));
//必需結尾


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options => {
    options.AddPolicy("AllowVueApp",
        builder => builder
            .WithOrigins("http://localhost:5173") // Vue project url
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials()
    );
});

var app = builder.Build();
app.UseCors();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors();


// 設定 SignalR Hub 路由
app.MapHub<ChatHub>("/ChatHub");



// 啟用 CORS
app.UseCors("AllowVueApp");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
app.Run();
