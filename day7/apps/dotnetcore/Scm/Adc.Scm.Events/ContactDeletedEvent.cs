namespace Adc.Scm.Events
{
    public class ContactDeletedEvent : EventBase
    {
        public ContactDeletedEvent() 
            : base("ContactDeletedEvent", 1)
        {
        }
    }
}
