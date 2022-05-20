using Azure.Search.Documents.Indexes;
using System.Text.Json.Serialization;

namespace Adc.Scm.Search.Indexer
{
    public class Contact
    {
        [SimpleField(IsKey = true)]
        [JsonPropertyName("id")]
        public string Id { get; set; }

        [SearchableField]
        [JsonPropertyName("userid")]
        public string UserId { get; set; }

        [SearchableField]
        [JsonPropertyName("firstname")]
        public string Firstname { get; set; }

        [SearchableField]
        [JsonPropertyName("lastname")]
        public string Lastname { get; set; }

        [SearchableField]
        [JsonPropertyName("email")]
        public string Email { get; set; }

        [SearchableField]
        [JsonPropertyName("company")]
        public string Company { get; set; }

        [SimpleField]
        [JsonPropertyName("avatarlocation")]
        public string AvatarLocation { get; set; }

        [SearchableField]
        [JsonPropertyName("phone")]
        public string Phone { get; set; }

        [SearchableField]
        [JsonPropertyName("mobile")]
        public string Mobile { get; set; }

        [SearchableField]
        [JsonPropertyName("description")]
        public string Description { get; set; }

        [SearchableField]
        [JsonPropertyName("street")]
        public string Street { get; set; }

        [SearchableField]
        [JsonPropertyName("housenumber")]
        public string HouseNumber { get; set; }

        [SearchableField]
        [JsonPropertyName("city")]
        public string City { get; set; }

        [SearchableField]
        [JsonPropertyName("postalcode")]
        public string PostalCode { get; set; }

        [SearchableField]
        [JsonPropertyName("country")]
        public string Country { get; set; }
    }
}
