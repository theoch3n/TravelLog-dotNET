using Microsoft.AspNetCore.Mvc;
using TravelLog.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace TravelLogAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItineraryController : ControllerBase
    {
        // GET: api/<ItineraryController>
        [HttpGet]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<ItineraryController>/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<ItineraryController>
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<ItineraryController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<ItineraryController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
