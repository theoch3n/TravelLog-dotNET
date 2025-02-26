using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;
using TravelLogAPI.Helpers;
using Google.Apis.Gmail.v1; // �ޥ� GmailService

var builder = WebApplication.CreateBuilder(args);

// ���U DbContext
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

// CORS �]�w
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options =>
{
    options.AddPolicy(PolicyName, policy =>
        policy.WithOrigins("https://localhost:5173")
              .AllowCredentials()
              .AllowAnyMethod()
              .WithHeaders("Content-Type", "Authorization", "x-requested-with", "x-signalr-user-agent"));
});

builder.Services.AddDistributedMemoryCache(); // Session �ݭn�O����֨�
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.SameSite = SameSiteMode.None;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
});

// JWT ���ҳ]�w
var jwtSection = builder.Configuration.GetSection("Jwt");
var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
var audience = jwtSection["Audience"] ?? "MyAppAudience";
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1";
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

builder.Services.AddAuthentication(options =>
{
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

// ���U GmailService �� Singleton�A�Ұʮɪ�l�Ƥ@��
builder.Services.AddSingleton<Google.Apis.Gmail.v1.GmailService>(provider =>
{
    return TravelLogAPI.Helpers.GmailApiProvider.GetGmailService(builder.Configuration);
});

// ���U SignalR
builder.Services.AddSignalR();

// ���U Controllers �P Swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ��L�A��
builder.Services.AddScoped<TravelLogContextProcedures>();

var app = builder.Build();
var configuration = builder.Configuration;
var gmailService = GmailApiProvider.GetGmailService(builder.Configuration); // �o�̶ǤJ IConfiguration

// �p�G�B��}�o���ҡA�ҥ� Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseCors(PolicyName);
app.UseSession(); // �T�O Session �b Authentication ���e
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<ChatHub>("/ChatHub");
app.MapFallbackToFile("/index.html");

app.Run();
