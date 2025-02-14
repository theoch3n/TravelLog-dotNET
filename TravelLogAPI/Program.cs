using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// 註冊 DbContext，只需一次
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

//CORS
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options => {
    options.AddPolicy(
        name: PolicyName,
        policy => policy.WithOrigins("*").WithMethods("*").WithHeaders("*"));
});





builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<TravelLogContextProcedures>();

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
