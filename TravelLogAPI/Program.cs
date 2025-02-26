using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;
using Google.Apis.Gmail.v1; // 引用 GmailService

var builder = WebApplication.CreateBuilder(args);

// 註冊 DbContext
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

// CORS 設定
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options =>
{
    options.AddPolicy(PolicyName, policy =>
        policy.WithOrigins("https://localhost:5173")
              .AllowCredentials()
              .AllowAnyMethod()
              .WithHeaders("Content-Type", "Authorization", "x-requested-with", "x-signalr-user-agent"));
});

// JWT 驗證設定
var jwtSection = builder.Configuration.GetSection("Jwt");
var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
var audience = jwtSection["Audience"] ?? "MyAppAudience";
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1";
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

builder.Services.AddAuthentication(options =>
{
    // 若你同時使用 Google OAuth 與 JWT，此處可以設定預設方案為 Cookie 或根據需求調整
    options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
})
.AddCookie()
.AddGoogle(googleOptions =>
{
    googleOptions.ClientId = builder.Configuration["Gmail:ClientId"];
    googleOptions.ClientSecret = builder.Configuration["Gmail:ClientSecret"];
    // 指定 OAuth 回調路徑，完整 redirect URI 會是 https://localhost:7092/authorize/
    googleOptions.CallbackPath = "/authorize/";
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

// 註冊 GmailService 為 Singleton，啟動時初始化一次
builder.Services.AddSingleton<Google.Apis.Gmail.v1.GmailService>(provider =>
{
    // 這裡會調用 GmailApiProvider.GetGmailService()，請確保 GmailApiProvider 已加上同步鎖與單例處理
    return TravelLogAPI.Helpers.GmailApiProvider.GetGmailService();
});

// 註冊 SignalR
builder.Services.AddSignalR();

// 註冊 Controllers 與 Swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// 其他服務
builder.Services.AddScoped<TravelLogContextProcedures>();

var app = builder.Build();

// 如果處於開發環境，啟用 Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseCors(PolicyName);

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<ChatHub>("/ChatHub");
app.MapFallbackToFile("/index.html");

app.Run();
