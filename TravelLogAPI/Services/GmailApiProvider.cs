using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Auth.OAuth2.Responses;
using Google.Apis.Gmail.v1;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using Microsoft.Extensions.Configuration;
using System.Threading;
using TravelLogAPI.Helpers; // 包含 FixedPortLocalServerCodeReceiver

namespace TravelLogAPI.Helpers
{
    // 定義 Gmail 設定的 POCO 類別（可放在單獨檔案中）
    public class GmailSettings
    {
        public string ClientId { get; set; }
        public string ClientSecret { get; set; }
        public string RedirectUri { get; set; }
        public string RefreshToken { get; set; }
        public string ApplicationName { get; set; }
        public string CredentialPath { get; set; }
        public string AuthStorePath { get; set; }
    }

    public static class GmailApiProvider
    {
        private static GmailService _gmailService;
        private static readonly object _initLock = new object();

        // 透過 IConfiguration 讀取 appsettings 中 Gmail 區段的設定
        public static GmailService GetGmailService(IConfiguration configuration)
        {
            if (_gmailService == null)
            {
                lock (_initLock)
                {
                    if (_gmailService == null)
                    {
                        // 從 appsettings.json 讀取 Gmail 設定
                        var gmailSettings = configuration.GetSection("Gmail").Get<GmailSettings>();

                        // 如果有 RefreshToken，表示已驗證過，採用非互動式方式建立憑證
                        if (!string.IsNullOrEmpty(gmailSettings.RefreshToken))
                        {
                            // 建立一個 TokenResponse，只包含 RefreshToken
                            var tokenResponse = new TokenResponse { RefreshToken = gmailSettings.RefreshToken };

                            // 建立 GoogleAuthorizationCodeFlow (可根據需要加入其他 Scope)
                            var initializer = new GoogleAuthorizationCodeFlow.Initializer
                            {
                                ClientSecrets = new ClientSecrets
                                {
                                    ClientId = gmailSettings.ClientId,
                                    ClientSecret = gmailSettings.ClientSecret
                                }
                            };

                            var flow = new GoogleAuthorizationCodeFlow(initializer);

                            // 建立 UserCredential，這裡 "user" 為使用者代號，可根據需求調整
                            var credential = new UserCredential(flow, "user", tokenResponse);

                            // 透過 RefreshTokenAsync 更新 AccessToken
                            credential.RefreshTokenAsync(CancellationToken.None).Wait();

                            _gmailService = new GmailService(new BaseClientService.Initializer()
                            {
                                HttpClientInitializer = credential,
                                ApplicationName = gmailSettings.ApplicationName
                            });
                        }
                        else
                        {
                            // 若未提供 RefreshToken，則使用互動式流程並採用 FixedPortLocalServerCodeReceiver
                            var clientSecrets = new ClientSecrets
                            {
                                ClientId = gmailSettings.ClientId,
                                ClientSecret = gmailSettings.ClientSecret
                            };

                            var credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                                clientSecrets,
                                new[] { GmailService.Scope.GmailSend },
                                "user",
                                CancellationToken.None,
                                new FileDataStore(gmailSettings.AuthStorePath),
                                new FixedPortLocalServerCodeReceiver(gmailSettings.RedirectUri)
                            ).Result;

                            _gmailService = new GmailService(new BaseClientService.Initializer()
                            {
                                HttpClientInitializer = credential,
                                ApplicationName = gmailSettings.ApplicationName
                            });
                        }
                    }
                }
            }
            return _gmailService;
        }
    }
}
