using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;
using Microsoft.AspNetCore.Cors.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// 註冊 DbContext
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

//CORS
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options =>
{
    options.AddPolicy(PolicyName, policy =>
        policy.WithOrigins("https://localhost:5173")
              .AllowCredentials()
              .AllowAnyMethod()
              .WithHeaders("Content-Type", "Authorization", "x-requested-with", "x-signalr-user-agent") // 指定允許的標頭
    );
});






var jwtSection = builder.Configuration.GetSection("Jwt");
var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
var audience = jwtSection["Audience"] ?? "MyAppAudience";
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1"; // 32 個字元以上
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidIssuer = issuer,
        ValidateAudience = true,
        ValidAudience = audience,
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = key,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.FromMinutes(5)
    };
});




// 註冊 SignalR
builder.Services.AddSignalR();






builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<TravelLogContextProcedures>();


var app = builder.Build();
//app.UseCors();

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

// 設定 SignalR Hub 路由
app.MapHub<ChatHub>("/ChatHub");




app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
//app.UseCors();
app.Run();

// 啟用 Vue Router History 模式的後端支援
app.UseDefaultFiles();
app.UseStaticFiles();

app.UseRouting();


app.UseEndpoints(endpoints => {
    endpoints.MapControllers();
    endpoints.MapFallbackToFile("/index.html"); // Vue history fallback
});
app.Run();
