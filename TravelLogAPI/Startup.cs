using System;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Owin;
using Microsoft.Owin.Security.Jwt;
using Owin;

[assembly: OwinStartup(typeof(TravelLogAPI.Startup))]
namespace TravelLogAPI
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // 設定發行者、接收者以及密鑰（請務必妥善保管密鑰）
            var issuer = "MyAppIssuer";
            var audience = "MyAppAudience";
            var secret = Encoding.UTF8.GetBytes("your_secret_key_here");


            app.UseJwtBearerAuthentication(new JwtBearerAuthenticationOptions
            {
                AuthenticationMode = Microsoft.Owin.Security.AuthenticationMode.Active,
                TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateIssuerSigningKey = true,
                    ValidateLifetime = true,
                    ValidIssuer = issuer,
                    ValidAudience = audience,
                    IssuerSigningKey = new SymmetricSecurityKey(secret)
                }
            });
        }
    }
}
