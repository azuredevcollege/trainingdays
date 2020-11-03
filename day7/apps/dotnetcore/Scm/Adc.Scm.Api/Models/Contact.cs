using System;
using System.ComponentModel.DataAnnotations;

namespace Adc.Scm.Api.Models
{
    public class Contact
    {
        public Guid? Id { get; set; }
        [Required]
        public string Firstname { get; set; }
        [Required]
        public string Lastname { get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        public string Company { get; set; }
        public string AvatarLocation { get; set; }
        public string Phone { get; set; }
        public string Mobile { get; set; }
        public string Description { get; set; }
        public string Street { get; set; }
        public string HouseNumber { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public string Country { get; set; }
    }
}
