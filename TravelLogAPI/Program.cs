using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// ���U DbContext�A�u�ݤ@��
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

// �]�w CORS �����A���\�Ӧ� Vue ���Ϊ��ШD (�Ҧp http://localhost:5173 �P http://localhost:5182)
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

// �p�G�B��}�o���ҡA�ҥ� Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// �ҥ� CORS�A�нT�O�b UseHttpsRedirection �P UseAuthorization ���e�I�s
app.UseCors("AllowVueApp");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
