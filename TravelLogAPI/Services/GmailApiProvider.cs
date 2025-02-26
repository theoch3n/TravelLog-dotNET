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
        private static GmailService _gmailService;
        private static readonly object _initLock = new object();

        public static GmailService GetGmailService()
        {
            if (_gmailService == null)
            {
                lock (_initLock)
                {
                    if (_gmailService == null)
                    {
                        var clientSecrets = new ClientSecrets
                        {
                            ClientId = "335216978577-pqipnvkd59v0k016cd7sbrid7pbroff6.apps.googleusercontent.com",
                            ClientSecret = "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"
                        };

                        var credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                            clientSecrets,
                            new[] { GmailService.Scope.GmailSend },
                            "user",
                            CancellationToken.None,
                            new FileDataStore("Gmail.Api.Auth.Store"),
                            new FixedPortLocalServerCodeReceiver("https://localhost:7092/authorize/")
                        ).Result;

                        _gmailService = new GmailService(new BaseClientService.Initializer()
                        {
                            HttpClientInitializer = credential,
                            ApplicationName = "TravelLog"
                        });
                    }
                }
            }
            return _gmailService;
        }
    }
}
