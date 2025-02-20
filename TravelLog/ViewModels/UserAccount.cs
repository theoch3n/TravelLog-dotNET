using System;

namespace TravelLog.ViewModels
{
    public class UserAccountViewModel
    {
        // User 資料
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }
        public string UserPhone { get; set; }
        public bool UserEnabled { get; set; }
        public DateTime UserCreateDate { get; set; }

        // UserPd 資料 (此處使用 nullable 型別，以防該使用者沒有對應資料)
        public int? UserPdId { get; set; }
        public string UserPdPasswordHash { get; set; }
        public string UserPdToken { get; set; }
        public DateTime? UserPdCreateDate { get; set; }
    }
}
