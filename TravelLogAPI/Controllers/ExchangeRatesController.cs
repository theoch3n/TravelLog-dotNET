using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using TravelLogAPI.Models;

namespace TravelLogAPI.Controllers
{
    [EnableCors("VueSinglePage")]
    [Route("api/[controller]")]
    [ApiController]
    public class ExchangeRatesController : ControllerBase
    {
        
        [HttpGet]
        public async Task<ExchangeRates> ExchangeRate()
        {
            HttpClient client = new HttpClient();
            HttpResponseMessage response = await client.GetAsync("https://openapi.taifex.com.tw/v1/DailyForeignExchangeRates");
            response.EnsureSuccessStatusCode();
            ExchangeRates[] data = JsonSerializer.Deserialize<ExchangeRates[]> (await response.Content.ReadAsStringAsync());
            return data.Last(); 
        }
    }
}
