using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TravelLog.Models;
using TravelLog.ViewModels;
using System;
using System.Linq;
using System.Threading.Tasks;

public class UserController : Controller
{
    private readonly TravelLogContext _context;
    public UserController(TravelLogContext context)
    {
        _context = context;
    }

    // GET: /User/Index
    public IActionResult Index()
    {
        // 取得所有 User 並 Include UserPds
        var users = _context.Users.Include(u => u.UserPds).ToList();

        // 轉換為 ViewModel
        var viewModels = users.Select(user =>
        {
            var userPd = user.UserPds.FirstOrDefault(); // 只取第一筆
            return new UserAccountViewModel
            {
                UserId = user.UserId,
                UserName = user.UserName,
                UserEmail = user.UserEmail,
                UserPhone = user.UserPhone,
                UserEnabled = user.UserEnabled,
                UserCreateDate = user.UserCreateDate,
                IsEmailVerified = user.IsEmailVerified,
                UserRole = user.UserRole,
                UserPdId = userPd?.UserPdId,
                UserPdPasswordHash = userPd?.UserPdPasswordHash,
                UserPdToken = userPd?.UserPdToken,
                UserPdCreateDate = userPd?.UserPdCreateDate
            };
        }).ToList();

        return View(viewModels);
    }

    // POST: /User/Edit
    // 使用 AJAX 提交更新
    [HttpPost]
    public async Task<IActionResult> Edit([FromBody] UserAccountViewModel model)
    {
        if (ModelState.IsValid)
        {
            var user = _context.Users.FirstOrDefault(u => u.UserId == model.UserId);
            if (user == null)
            {
                return NotFound();
            }
            user.UserName = model.UserName;
            user.UserEmail = model.UserEmail;
            user.UserPhone = model.UserPhone;
            user.UserEnabled = model.UserEnabled;
            // 新增更新兩個欄位
            user.IsEmailVerified = model.IsEmailVerified;
            user.UserRole = model.UserRole;
            // UserCreateDate 通常不更新

            var userPd = _context.UserPds.FirstOrDefault(p => p.UserPdId == model.UserPdId);
            if (userPd != null)
            {
                userPd.UserPdPasswordHash = model.UserPdPasswordHash;
                userPd.UserPdToken = model.UserPdToken;
            }
            else
            {
                userPd = new UserPd
                {
                    UserId = user.UserId,
                    UserPdPasswordHash = model.UserPdPasswordHash,
                    UserPdToken = model.UserPdToken,
                    UserPdCreateDate = DateTime.Now
                };
                _context.UserPds.Add(userPd);
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
        return Json(new { success = false, errors = ModelState.Values.SelectMany(v => v.Errors) });
    }
    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        var user = await _context.Users
                                 .Include(u => u.UserPds)
                                 .FirstOrDefaultAsync(u => u.UserId == id);
        if (user == null)
        {
            return NotFound();
        }

        // 如果沒有設定 Cascade Delete，就必須先刪除關聯的 UserPd 資料
        if (user.UserPds != null && user.UserPds.Any())
        {
            _context.UserPds.RemoveRange(user.UserPds);
        }

        _context.Users.Remove(user);
        await _context.SaveChangesAsync();

        return Json(new { success = true });
    }


}
