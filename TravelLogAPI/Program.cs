using Microsoft.EntityFrameworkCore;
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

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
app.UseCors();
app.Run();
