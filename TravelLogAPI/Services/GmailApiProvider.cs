
using Google.Apis.Auth.OAuth2;
using Google.Apis.Gmail.v1;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using System.IO;
using System.Threading;

namespace TravelLogAPI.Helpers
{
    public static class GmailApiProvider
    {
        public static GmailService GetGmailService()
        {
            // 從 appsettings.json 或環境變數讀取 Gmail API 的認證資訊
            // 例如 ClientId, ClientSecret, RefreshToken 等
            // 這裡僅提供一個簡單範例，實際應根據你的情況處理 OAuth2 流程
            var clientSecrets = new ClientSecrets
            {
                ClientId = "your_client_id",
                ClientSecret = "your_client_secret"
            };

            // Token 資訊，實際應使用安全方式儲存
            var credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                clientSecrets,
                new[] { GmailService.Scope.GmailSend },
                "user",
                CancellationToken.None,
                new FileDataStore("Gmail.Api.Auth.Store")).Result;

            // 建立 GmailService 實例
            var service = new GmailService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = "Your App Name"
            });

            return service;
        }
    }
}
