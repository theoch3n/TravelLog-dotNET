using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace TravelLogAPI
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        // 在建構子中注入 IConfiguration
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // 配置服務
        public void ConfigureServices(IServiceCollection services)
        {
            var jwtSection = Configuration.GetSection("Jwt");
            var issuer = jwtSection["Issuer"] ?? "MyAppIssuer";
            var audience = jwtSection["Audience"] ?? "MyAppAudience";
            var secret = jwtSection["SecretKey"] ?? "G7$k2Lp@9n3fXrZ1G7$k2Lp@9n3fXrZ1";


            // 建立對稱安全金鑰
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

            // 設定 JWT 驗證服務
            services.AddAuthentication(options =>
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

            // 加入控制器服務（若為 MVC 專案，可使用 AddControllersWithViews()）
            services.AddControllers();
        }

        // 配置 HTTP 請求管線
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();  // 認證中間件必須在授權中間件之前
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
