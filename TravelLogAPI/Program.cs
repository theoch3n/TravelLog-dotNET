using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TravelLogAPI.Hubs;
using TravelLogAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// ���U DbContext
builder.Services.AddDbContext<TravelLogContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("TravelLog")));

//CORS
string PolicyName = "VueSinglePage";
builder.Services.AddCors(options => {
    options.AddPolicy(
        name: PolicyName,
        policy => policy.WithOrigins("*").WithMethods("*").WithHeaders("*"));
});

var jwtSection = builder.Configuration.GetSection("Jwt");
var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
var audience = jwtSection["Audience"] ?? "MyAppAudience";
var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1"; // 32 �Ӧr���H�W
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




// ���U SignalR
builder.Services.AddSignalR();




builder.Services.AddMemoryCache();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<TravelLogContextProcedures>();


var app = builder.Build();
//app.UseCors();

// �p�G�B��}�o���ҡA�ҥ� Swagger
if (app.Environment.IsDevelopment()) {
    app.UseSwagger();
    app.UseSwaggerUI();
}

// �ҥ� Vue Router History �Ҧ�����ݤ䴩
app.UseDefaultFiles();
app.UseStaticFiles();
app.UseRouting();

// �ҥ� CORS�A�нT�O�b UseHttpsRedirection �P UseAuthorization ���e�I�s
app.UseCors("VueSinglePage");

// �]�w SignalR Hub ����
app.MapHub<ChatHub>("/ChatHub");




app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
//app.UseCors();
app.Run();

// �ҥ� Vue Router History �Ҧ�����ݤ䴩
app.UseDefaultFiles();
app.UseStaticFiles();

app.UseRouting();


app.UseEndpoints(endpoints => {
    endpoints.MapControllers();
    endpoints.MapFallbackToFile("/index.html"); // Vue history fallback
});
app.Run();
