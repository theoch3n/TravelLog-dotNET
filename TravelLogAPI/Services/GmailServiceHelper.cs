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

        public static async Task<Message> SendEmailAsync(IConfiguration configuration, string to, string from, string subject, string body)
        {
            // 傳入 configuration 參數
            var gmailService = GmailApiProvider.GetGmailService(configuration);
            var message = CreateEmailMessage(to, from, subject, body);
            return await gmailService.Users.Messages.Send(message, "me").ExecuteAsync();
        }
    }
}
