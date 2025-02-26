using Google.Apis.Auth.OAuth2;
using Google.Apis.Gmail.v1;
using Google.Apis.Util.Store;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

public static class GoogleAuthHelper
{
    /// <summary>
    /// 非同步取得使用者的 Google OAuth2 認證，需先下載 credentials.json 放置在專案資料夾中。
    /// </summary>
    /// <returns>UserCredential 物件</returns>
    public static async Task<UserCredential> GetUserCredentialAsync()
    {
        using (var stream = new FileStream("credentials.json", FileMode.Open, FileAccess.Read))
        {
            // 設定存放 token 的檔案路徑，token.json 會自動建立
            string credPath = "token.json";
            var credential = await GoogleWebAuthorizationBroker.AuthorizeAsync(
                GoogleClientSecrets.Load(stream).Secrets,
                new[] { GmailService.Scope.GmailSend },
                "user",
                CancellationToken.None,
                new FileDataStore(credPath, true)
            );
            return credential;
        }
    }
}
