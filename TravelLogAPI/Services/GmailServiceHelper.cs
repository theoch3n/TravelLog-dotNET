
using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using MimeKit;
using System;
using System.IO;

namespace TravelLogAPI.Helpers
{
    public static class GmailServiceHelper
    {
        /// <summary>
        /// 取得 Gmail API 的 Service 實例，透過 GmailApiProvider 取得 OAuth2 驗證後的服務
        /// </summary>
        /// <returns>GmailService 實例</returns>
        public static GmailService GetGmailService()
        {
            // GmailApiProvider 負責根據設定檔或環境變數建立 GmailService
            return GmailApiProvider.GetGmailService();
        }

        /// <summary>
        /// 使用 Gmail API 發送郵件
        /// </summary>
        /// <param name="toEmail">收件人 Email</param>
        /// <param name="subject">郵件主旨</param>
        /// <param name="body">郵件內容</param>
        public static void SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                var service = GetGmailService();

                var mimeMessage = new MimeMessage();
                mimeMessage.From.Add(new MailboxAddress("TravelLog", "david39128332@gmail.com"));
                mimeMessage.To.Add(new MailboxAddress("", toEmail));
                mimeMessage.Subject = subject;

                // 使用 MultipartAlternative 同時提供純文字與 HTML 版本
                var plainText = new TextPart("plain") { Text = body };
                var htmlText = new TextPart("html")
                {
                    Text = $@"
                    <html>
                      <body>
                        <h2>{subject}</h2>
                        <p>{body}</p>
                        <p>感謝您的使用，<br/>TravelLog 團隊</p>
                      </body>
                    </html>"
                };

                mimeMessage.Body = new MultipartAlternative { plainText, htmlText };

                using (var stream = new MemoryStream())
                {
                    mimeMessage.WriteTo(stream);
                    var rawMessage = Convert.ToBase64String(stream.ToArray())
                        .Replace('+', '-')
                        .Replace('/', '_')
                        .Replace("=", "");

                    var message = new Message { Raw = rawMessage };
                    service.Users.Messages.Send(message, "me").Execute();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("寄送郵件發生錯誤：" + ex.Message);
            }
        }

    }
}
