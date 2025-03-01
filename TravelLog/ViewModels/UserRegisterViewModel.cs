namespace TravelLog.ViewModels
{
    public class UserRegisterViewModel
    {
        // 對應 User 模型的 UserName
        public string Name { get; set; }

        // 對應 User 模型的 UserEmail
        public string Email { get; set; }

        // 對應 User 模型的 UserPhone
        public string Phone { get; set; }

        // 註冊時用來輸入密碼
        public string Password { get; set; }

        // 用於確認密碼
        public string ConfirmPassword { get; set; }

        // 對應 User 模型的 UserRole
        public int Role { get; set; }
    }
}
