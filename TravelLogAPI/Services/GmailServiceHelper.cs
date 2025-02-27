using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using MimeKit;
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using TravelLogAPI.Helpers;

namespace TravelLogAPI.Services
{
    public static class GmailServiceHelper
    {
        public static Message CreateEmailMessage(string to, string from, string subject, string body)
        {
            var emailMessage = new MimeMessage();
            emailMessage.From.Add(new MailboxAddress("", from));
            emailMessage.To.Add(new MailboxAddress("", to));
            emailMessage.Subject = subject;
            emailMessage.Body = new TextPart("html")
            {
                Text = body
            };

            using (var stream = new MemoryStream())
            {
                emailMessage.WriteTo(stream);
                var rawBytes = stream.ToArray();
                var rawString = Convert.ToBase64String(rawBytes)
                    .Replace('+', '-')
                    .Replace('/', '_')
                    .Replace("=", "");
                return new Message
                {
                    Raw = rawString
                };
            }
        }

        public static async Task<Message> SendEmailAsync(IConfiguration configuration, string to, string from, string subject, string body, ILogger logger = null)
        {
            // 傳入 configuration 參數取得 GmailService
            var gmailService = GmailApiProvider.GetGmailService(configuration);
            // 建立郵件訊息
            var message = CreateEmailMessage(to, from, subject, body);

            // 日誌：印出 Raw 內容，注意這通常是 Base64Url 編碼的字串
            logger?.LogInformation("Generated email Raw content: {RawContent}", message.Raw);

            try
            {
                var response = await gmailService.Users.Messages.Send(message, "me").ExecuteAsync();

                // 日誌：印出回傳訊息 (例如訊息 ID)
                logger?.LogInformation("Email sent successfully. Message ID: {MessageId}", response.Id);
                return response;
            }
            catch (Exception ex)
            {
                logger?.LogError(ex, "Failed to send email.");
                throw; // 根據需求拋出或處理錯誤
            }
        }

    }
}
