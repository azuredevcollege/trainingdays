namespace Adc.Scm.Events
{
    public class ContactAddedEvent : EventBase
    {
        public ContactAddedEvent() 
            : base("ContactAddedEvent", 1)
        {
        }
    }
}
