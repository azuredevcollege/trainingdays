using Microsoft.Azure.Search;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace Adc.Scm.Search.Indexer
{
    [JsonObject(NamingStrategyType = typeof(JsonLowercaseNamingStrategy))]
    public class Contact
    {
        [System.ComponentModel.DataAnnotations.Key]
        [IsRetrievable(true)]
        public string Id { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string UserId { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Firstname { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Lastname { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Email { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Company { get; set; }
        [IsRetrievable(true)]
        public string AvatarLocation { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Phone { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Mobile { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Description { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Street { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string HouseNumber { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string City { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string PostalCode { get; set; }
        [IsSearchable, IsRetrievable(true)]
        public string Country { get; set; }
    }
}
