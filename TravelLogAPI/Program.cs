using Microsoft.EntityFrameworkCore;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// 註冊 DbContext
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

//CORS
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options => {
    options.AddPolicy(
        name: PolicyName,
        policy => policy.WithOrigins("*").WithMethods("*").WithHeaders("*"));
});

//builder.Services.AddCors(options => {
//    options.AddPolicy("AllowVueApp",
//        builder => builder
//            .WithOrigins("https://localhost:5173") // Vue project url
//            .AllowAnyMethod()
//            .AllowAnyHeader()
//            .AllowCredentials()
//    );
//});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<TravelLogContextProcedures>();

var app = builder.Build();

// 如果處於開發環境，啟用 Swagger
if (app.Environment.IsDevelopment()) {
    app.UseSwagger();
    app.UseSwaggerUI();
}

// 啟用 Vue Router History 模式的後端支援
app.UseDefaultFiles();
app.UseStaticFiles();
app.UseRouting();

// 啟用 CORS，請確保在 UseHttpsRedirection 與 UseAuthorization 之前呼叫
app.UseCors("VueSinglePage");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.UseEndpoints(endpoints => {
    endpoints.MapControllers();
    endpoints.MapFallbackToFile("/index.html"); // Vue history fallback
});
app.Run();
