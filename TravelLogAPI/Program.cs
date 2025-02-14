using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// ���U DbContext�A�u�ݤ@��
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
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials()
    );
});

var app = builder.Build();

// �p�G�B��}�o���ҡA�ҥ� Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// �ҥ� CORS�A�нT�O�b UseHttpsRedirection �P UseAuthorization ���e�I�s
app.UseCors("VueSinglePage");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

// �ҥ� Vue Router History �Ҧ�����ݤ䴩
app.UseDefaultFiles();
app.UseStaticFiles();

app.UseRouting();

app.UseEndpoints(endpoints => {
    endpoints.MapControllers();
    endpoints.MapFallbackToFile("/index.html"); // Vue history fallback
});
