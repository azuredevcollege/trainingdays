using System;

namespace Adc.Scm.Events
{
    public abstract class EventBase
    {
        protected EventBase(string eventType, int version)
        {
            EventType = eventType;
            Version = version;
        }

        public int Version { get; set; }
        public string EventType { get; set; }
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public string Email { get; set; }
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
