using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using MimeKit;
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using TravelLogAPI.Helpers;
using Microsoft.Extensions.Logging;

namespace TravelLogAPI.Services
{
    public static class GmailServiceHelper
    {
        public static Message CreateEmailMessage(string to, string from, string subject, string body)
        {
            // 這裡我們把傳入的 body 包在一個固定的 HTML 模板中
            string htmlTemplate = $@"
                <html>
                  <head>
                    <meta charset=""UTF-8"">
                    <style>
                      body {{ font-family: Arial, sans-serif; font-size: 14px; }}
                      .highlight {{ color: blue; font-weight: bold; }}
                    </style>
                  </head>
                  <body>
                    {body}
                  </body>
                </html>";

            var emailMessage = new MimeMessage();
            emailMessage.From.Add(new MailboxAddress("", from));
            emailMessage.To.Add(new MailboxAddress("", to));
            emailMessage.Subject = subject;
            emailMessage.Body = new TextPart("html")
            {
                Text = htmlTemplate
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

            // 日誌：印出 Raw 內容
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
                throw;
            }
        }
    }
}
