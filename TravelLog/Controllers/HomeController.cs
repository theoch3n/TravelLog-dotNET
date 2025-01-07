using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Diagnostics;
using TravelLog.Models;


namespace TravelLog.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        TravelLogContext _context;

        public HomeController(ILogger<HomeController> logger, TravelLogContext context)
        {
            _logger = logger;
            _context = context;
        }
        public IActionResult Index()
        {
            return View();
        }

        /// <author>濟恩</author>
        /// <summary>
        /// 使用預存程序取得流水號
        /// </summary>
        /// <returns></returns>
        //public IActionResult Index()
        //{
        //    SerialBase_SP serialBaseSP = new SerialBase_SP("UR");
        //    DataSet ds = serialBaseSP.get_SerialNumber();
        //    DataTable dt = ds.Tables[0];
        //    SerialBase serialBase = null;
        //    if (dt.Rows.Count > 0)
        //    {
        //        DataRow row = dt.Rows[0];
        //        serialBase = new SerialBase
        //        {
        //            SbSerial = row["SB_Serial"] != DBNull.Value ? Int32.Parse(row["SB_Serial"].ToString()) : 0,
        //            SbSystemCode = row["SB_SystemCode"]?.ToString(),
        //            SbSystemName = row["SB_SystemName"]?.ToString(),
        //            SbSerialNumber = row["SB_SerialNumber"]?.ToString(),
        //            SbCount = row["SB_Count"] != DBNull.Value ? Int32.Parse(row["SB_Count"].ToString()) : 0,
        //            ModifiedDate = row["ModifiedDate"] != DBNull.Value ? DateTime.Parse(row["ModifiedDate"].ToString()) : DateTime.MinValue
        //        };

        //    }
        //    return View(serialBase);
        //}

        //public IActionResult Index()
        //{
        //    SerialBase_SP serialBaseSP = new SerialBase_SP("UR");
        //    List<SerialBase> serialTable = serialBaseSP.GetSerialTable();
        //    SerialBase serialBase = serialTable.FirstOrDefault(); // 取得第一筆資料
        //    return View(serialBase);
        //}

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
