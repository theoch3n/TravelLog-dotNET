using System.Text.Json.Serialization;

namespace TravelLogAPI.Models
{
    public class ExchangeRates
    {
        public string Date { get; set; }

        [JsonPropertyName("USD/NTD")]
        public string USDNTD { get; set; }
        [JsonPropertyName("RMB/NTD")]
        public string RMBNTD { get; set; }
        [JsonPropertyName("EUR/USD")]
        public string EURUSD { get; set; }
        [JsonPropertyName("USD/JPY")]
        public string USDJPY { get; set; }
        [JsonPropertyName("GBP/USD")]
        public string GBPUSD { get; set; }
        [JsonPropertyName("AUD/USD")]
        public string AUDUSD { get; set; }
        [JsonPropertyName("USD/HKD")]
        public string USDHKD { get; set; }
        [JsonPropertyName("USD/RMB")]
        public string USDRMB { get; set; }
        [JsonPropertyName("USD/ZAR")]
        public string USDZAR { get; set; }
        [JsonPropertyName("NZD/USD")]
        public string NZDUSD { get; set; }
    }
}
