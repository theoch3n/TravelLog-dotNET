using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;
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
const string PolicyName = "VueSinglePage";
builder.Services.AddCors(options => {
    options.AddPolicy(PolicyName, policy =>
        policy.WithOrigins("https://localhost:5173", "https://localhost:7206")
              .AllowCredentials()
              .AllowAnyMethod()
              .WithHeaders("Content-Type", "Authorization", "x-requested-with", "x-signalr-user-agent"));
});

// ------------------------------
// 加入 Distributed Memory Cache 與 Session 設定
// ------------------------------
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options => {
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
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1"; // 確保 Secret Key 長度符合要求
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

// ------------------------------
// 驗證與認證服務 (Cookie, Google, JWT)
// ------------------------------
builder.Services.AddAuthentication(options => {
    options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
})
.AddCookie(options => {
    options.Cookie.SameSite = SameSiteMode.None;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
})
.AddGoogle(googleOptions => {
    googleOptions.ClientId = builder.Configuration["Gmail:ClientId"];
    googleOptions.ClientSecret = builder.Configuration["Gmail:ClientSecret"];
    googleOptions.CallbackPath = "/authorize/";
})
.AddJwtBearer(options => {
    options.TokenValidationParameters = new TokenValidationParameters {
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
// 註冊 GmailService 為 Singleton
// ------------------------------
builder.Services.AddSingleton<GmailService>(provider =>
    TravelLogAPI.Helpers.GmailApiProvider.GetGmailService(builder.Configuration));

// ------------------------------
// 註冊 SignalR
// ------------------------------
builder.Services.AddSignalR();

builder.Services.AddMemoryCache();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ------------------------------
// 其他服務
// ------------------------------
builder.Services.AddScoped<TravelLogContextProcedures>();

var app = builder.Build();
var configuration = builder.Configuration;

// 可選：檢查 GmailService 是否成功初始化
using (var scope = app.Services.CreateScope()) {
    var services = scope.ServiceProvider;
    var gmailService = services.GetRequiredService<GmailService>(); // 確保 GmailService 成功注入
}

// ------------------------------
// 如果處於開發環境，啟用 Swagger
// ------------------------------
if (app.Environment.IsDevelopment()) {
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ------------------------------
// 啟用 Middleware 順序最佳化
// ------------------------------
app.UseRouting();         // 1. 啟用路由
app.UseCors(PolicyName);  // 2. 啟用 CORS，確保跨域請求不被阻擋
app.UseSession();         // 3. 啟用 Session
app.UseHttpsRedirection(); // 4. 啟用 HTTPS 強制重導
app.UseAuthentication();  // 5. 啟用身份驗證
app.UseAuthorization();   // 6. 啟用授權

// ------------------------------
// 映射 API 控制器
// ------------------------------
app.MapControllers();

// ------------------------------
// 映射 SignalR Hub
// ------------------------------
app.MapHub<ChatHub>("/ChatHub");

// ------------------------------
// Vue Router History 模式支援
// ------------------------------
app.MapFallbackToFile("/index.html");

// ------------------------------
// 啟動應用程式
// ------------------------------
app.Run();
