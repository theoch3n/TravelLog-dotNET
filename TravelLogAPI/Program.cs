using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;
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

// JWT ���ҳ]�w
var jwtSection = builder.Configuration.GetSection("Jwt");
var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
var audience = jwtSection["Audience"] ?? "MyAppAudience";
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1";
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

builder.Services.AddAuthentication(options =>
{
    // �Y�A�P�ɨϥ� Google OAuth �P JWT�A���B�i�H�]�w�w�]��׬� Cookie �ήھڻݨD�վ�
    options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
})
.AddCookie()
.AddGoogle(googleOptions =>
{
    googleOptions.ClientId = builder.Configuration["Gmail:ClientId"];
    googleOptions.ClientSecret = builder.Configuration["Gmail:ClientSecret"];
    // ���w OAuth �^�ո��|�A���� redirect URI �|�O https://localhost:7092/authorize/
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
    // �o�̷|�ե� GmailApiProvider.GetGmailService()�A�нT�O GmailApiProvider �w�[�W�P�B��P��ҳB�z
    return TravelLogAPI.Helpers.GmailApiProvider.GetGmailService();
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

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<ChatHub>("/ChatHub");
app.MapFallbackToFile("/index.html");

app.Run();
