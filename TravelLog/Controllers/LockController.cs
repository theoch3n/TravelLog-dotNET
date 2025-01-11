using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using TravelLog.Models;

namespace TravelLog.Controllers
{
    public static class CDictionary
    {
        public const string SK_LOINGED_USER = "SK_LOINGED_USER"; // Session 鍵值名稱
    }

    public class LockController : Controller
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            // 檢查 Session 是否有登入資訊
            var userId = HttpContext.Session.GetString(CDictionary.SK_LOINGED_USER);

            // 確認當前頁面的控制器和動作名稱
            var controllerName = context.RouteData.Values["controller"]?.ToString();
            var actionName = context.RouteData.Values["action"]?.ToString();

            // 定義例外頁面清單
            var exemptPages = new List<(string Controller, string Action)>
            {
                ("Member", "Login"),
                ("Member", "Register"),
                ("Member", "ResetPassword"),
                ("Member", "ResetPasswordRequest")
            };

            // 判斷當前頁面是否在例外清單中
            var isExemptPage = exemptPages.Any(page =>
                page.Controller.Equals(controllerName, StringComparison.OrdinalIgnoreCase) &&
                page.Action.Equals(actionName, StringComparison.OrdinalIgnoreCase));

            // 如果未登入且不是例外頁面，重導向至 Login 頁面
            if (string.IsNullOrEmpty(userId) && !isExemptPage)
            {
                Console.WriteLine($"User not logged in. Redirecting to Login page. Controller: {controllerName}, Action: {actionName}");
                context.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                {
                    controller = "Member",
                    action = "Login"
                }));
            }
            else if (!string.IsNullOrEmpty(userId))
            {
                Console.WriteLine($"User logged in with UserId: {userId}");
            }

            // 執行父類別的邏輯
            base.OnActionExecuting(context);
        }
    }
}
