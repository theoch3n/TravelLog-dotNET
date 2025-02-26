using Google.Apis.Auth.OAuth2;
using Google.Apis.Gmail.v1;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using System.Threading;
using TravelLogAPI.Helpers; // 包含 FixedPortLocalServerCodeReceiver

namespace TravelLogAPI.Helpers
{
    public static class GmailApiProvider
    {
        public static GmailService GetGmailService()
        {
            // 這裡直接硬編碼 ClientSecrets（實際上可從 appsettings.json 讀取設定）
            var clientSecrets = new ClientSecrets
            {
                ClientId = "335216978577-pqipnvkd59v0k016cd7sbrid7pbroff6.apps.googleusercontent.com",
                ClientSecret = "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"
            };

            // 使用 GoogleWebAuthorizationBroker 進行 OAuth2 流程
            // 改用自訂的 FixedPortLocalServerCodeReceiver 固定回呼 URI，例如 "http://localhost:7092/authorize/"
            var credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                clientSecrets,
                new[] { GmailService.Scope.GmailSend },
                "user",                   // 使用者識別字串
                CancellationToken.None,
                new FileDataStore("Gmail.Api.Auth.Store"),
                new FixedPortLocalServerCodeReceiver("https://localhost:7092/authorize/")
            ).Result;

            // 建立 GmailService 實例
            var service = new GmailService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = "TravelLog"
            });

            return service;
        }
    }
}
