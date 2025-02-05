using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

//必需
string PolicyName = "Room145";

builder.Services.AddCors(options =>
{
    options.AddPolicy(
        name: PolicyName,
       policy => policy.WithOrigins("*").WithMethods("*").WithHeaders("*"));
});

builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));
//必需結尾


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors();


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
