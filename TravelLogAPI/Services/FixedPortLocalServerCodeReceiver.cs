using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Requests;
using Google.Apis.Auth.OAuth2.Responses;
using System;
using System.Net;
using System.Threading;
using System.Threading.Tasks;

namespace TravelLogAPI.Helpers
{
    public class FixedPortLocalServerCodeReceiver : ICodeReceiver
    {
        private readonly string _fixedRedirectUri;

        public FixedPortLocalServerCodeReceiver(string fixedRedirectUri)
        {
            // 指定固定回呼 URI，必須包含尾部斜線，例如 "http://localhost:7092/authorize/"
            _fixedRedirectUri = fixedRedirectUri;
        }

        // 固定使用此回呼 URI
        public string RedirectUri => _fixedRedirectUri;

        // 實作 ReceiveCodeAsync 方法：打開瀏覽器、監聽 HTTP 回呼並解析授權碼
        public async Task<AuthorizationCodeResponseUrl> ReceiveCodeAsync(AuthorizationCodeRequestUrl url, CancellationToken cancellationToken)
        {
            // 建立完整的授權 URL
            string authorizationUrl = url.Build().ToString();

            // 開啟使用者預設瀏覽器導向授權 URL
            System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
            {
                FileName = authorizationUrl,
                UseShellExecute = true
            });

            // 使用 HttpListener 監聽固定的回呼 URI
            using (HttpListener listener = new HttpListener())
            {
                listener.Prefixes.Add(_fixedRedirectUri);
                listener.Start();

                // 等待授權伺服器回傳授權碼
                var context = await listener.GetContextAsync();
                var response = context.Response;
                var request = context.Request;

                // 從 URL 查詢字串解析授權碼或錯誤資訊
                var authResponse = new AuthorizationCodeResponseUrl(request.Url.Query);

                // 回應瀏覽器一段簡單 HTML，告知授權完成
                string responseString = "<html><head><meta http-equiv='refresh' content='10;url=https://www.google.com'></head><body>授權完成，您可以關閉此視窗。</body></html>";
                byte[] buffer = System.Text.Encoding.UTF8.GetBytes(responseString);
                response.ContentLength64 = buffer.Length;
                await response.OutputStream.WriteAsync(buffer, 0, buffer.Length);
                response.OutputStream.Close();

                listener.Stop();
                return authResponse;
            }
        }
    }
}
