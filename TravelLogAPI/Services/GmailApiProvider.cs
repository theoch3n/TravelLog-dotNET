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

            // 這裡直接硬編碼了 ClientSecrets（注意：中間不應有多餘的空格）
            var clientSecrets = new ClientSecrets
            {
                // 注意此處 ClientId 中的格式必須正確，請移除多餘空格
                ClientId = "335216978577-pqipnvkd59v0k016cd7sbrid7pbroff6.apps.googleusercontent.com",
                ClientSecret = "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"
            };

            // 使用 GoogleWebAuthorizationBroker 來啟動 OAuth2 流程
            // AuthorizeAsync 會打開一個瀏覽器窗口，讓用戶同意授權
            var credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                clientSecrets,
                new[] { GmailService.Scope.GmailSend },
                "user",  // 使用者識別字串，可根據情況修改
                CancellationToken.None,
                new FileDataStore("Gmail.Api.Auth.Store")).Result;

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
