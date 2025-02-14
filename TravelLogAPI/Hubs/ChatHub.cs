using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;


namespace TravelLogAPI.Hubs
{
    public class ChatHub : Hub
    {
         // 這個方法讓客戶端傳送訊息給所有連線的用戶
    public async Task SendMessage(string user, string message)
    {
        await Clients.All.SendAsync("ReceiveMessage", user, message);
    }

        // 工作人員回覆訊息
        public async Task SendReply(string user, string reply)
        {
            await Clients.User(user).SendAsync("ReceiveReply", reply);
        }
        
    }
}
