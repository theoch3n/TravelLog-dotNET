
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
                // 取得 GmailService 實例
                var service = GetGmailService();

                // 使用 MimeKit 建立郵件內容
                var mimeMessage = new MimeMessage();
                // 設定寄件人，這裡的郵箱應與 Gmail API 認證時的帳戶相同
                mimeMessage.From.Add(new MailboxAddress("Your App Name", "yourapp@gmail.com"));
                // 設定收件人
                mimeMessage.To.Add(new MailboxAddress("", toEmail));
                // 設定郵件主旨
                mimeMessage.Subject = subject;
                // 設定郵件內容（這裡採用純文字格式）
                mimeMessage.Body = new TextPart("plain") { Text = body };

                // 將 MIME 郵件寫入 MemoryStream
                using (var stream = new MemoryStream())
                {
                    mimeMessage.WriteTo(stream);
                    // 將資料轉為 Base64Url 格式
                    var rawMessage = Convert.ToBase64String(stream.ToArray())
                        .Replace('+', '-')
                        .Replace('/', '_')
                        .Replace("=", "");

                    // 建立 Gmail API Message 物件，並設定 Raw 屬性
                    var message = new Message
                    {
                        Raw = rawMessage
                    };

                    // 使用 Gmail API 的 Users.Messages.Send 方法發送郵件
                    // "me" 表示發送者為已認證的使用者
                    service.Users.Messages.Send(message, "me").Execute();
                }
            }
            catch (Exception ex)
            {
                // 這裡可根據需求記錄錯誤或進行其他處理
                throw new Exception("寄送郵件發生錯誤：" + ex.Message);
            }
        }
    }
}
