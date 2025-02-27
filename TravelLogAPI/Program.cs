using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;
using Microsoft.AspNetCore.Cors.Infrastructure;
using TravelLogAPI.Helpers; // 包含 GmailApiProvider 與 FixedPortLocalServerCodeReceiver
using Google.Apis.Gmail.v1; // 引用 GmailService

var builder = WebApplication.CreateBuilder(args);

// ------------------------------
// 註冊 DbContext
// ------------------------------
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

// ------------------------------
// CORS 設定
// ------------------------------
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options =>
{
    options.AddPolicy(PolicyName, policy =>
        policy.WithOrigins("https://localhost:5173")
              .AllowCredentials()
              .AllowAnyMethod()
              .WithHeaders("Content-Type", "Authorization", "x-requested-with", "x-signalr-user-agent"));
});

// ------------------------------
// 加入 Distributed Memory Cache 與 Session 設定
// ------------------------------
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.SameSite = SameSiteMode.None;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
});

// ------------------------------
// JWT 驗證設定
// ------------------------------
var jwtSection = builder.Configuration.GetSection("Jwt");
var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
var audience = jwtSection["Audience"] ?? "MyAppAudience";
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1"; // 32 個字元以上
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

// ------------------------------
// 驗證與認證服務 (Cookie, Google, JWT)
// ------------------------------
builder.Services.AddAuthentication(options =>
{
    // 這裡設定 Cookie 為預設驗證方式，Google 為挑戰方案
    options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
})
.AddCookie(options =>
{
    options.Cookie.SameSite = SameSiteMode.None;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
})
.AddGoogle(googleOptions =>
{
    googleOptions.ClientId = builder.Configuration["Gmail:ClientId"];
    googleOptions.ClientSecret = builder.Configuration["Gmail:ClientSecret"];
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

// ------------------------------
// 註冊 GmailService 為 Singleton（初始化時使用 appsettings 中的 Gmail 設定）
// ------------------------------
builder.Services.AddSingleton<Google.Apis.Gmail.v1.GmailService>(provider =>
{
    return TravelLogAPI.Helpers.GmailApiProvider.GetGmailService(builder.Configuration);
});

// ------------------------------
// 註冊 SignalR
// ------------------------------
builder.Services.AddSignalR();

// ------------------------------
// 註冊 Controllers 與 Swagger
// ------------------------------
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ------------------------------
// 其他服務
// ------------------------------
builder.Services.AddScoped<TravelLogContextProcedures>();

var app = builder.Build();
var configuration = builder.Configuration;
// 可選：檢查 GmailService 是否初始化成功
var gmailService = TravelLogAPI.Helpers.GmailApiProvider.GetGmailService(builder.Configuration);

// ------------------------------
// 如果處於開發環境，啟用 Swagger
// ------------------------------
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ------------------------------
// 靜態檔案與 Vue Router History 模式支援
// ------------------------------
app.UseDefaultFiles();
app.UseStaticFiles();

app.UseRouting();

// ------------------------------
// 啟用 CORS 與 Session
// ------------------------------
app.UseCors(PolicyName);
app.UseSession();

app.UseHttpsRedirection();

// ------------------------------
// 啟用認證與授權
// ------------------------------
app.UseAuthentication();
app.UseAuthorization();

// ------------------------------
// 映射 SignalR Hub、Controllers 與 Fallback (Vue History)
// ------------------------------
app.MapControllers();
app.MapHub<ChatHub>("/ChatHub");
app.MapFallbackToFile("/index.html");

// ------------------------------
// 啟動應用程式（只呼叫一次 Run()）
// ------------------------------
app.Run();
