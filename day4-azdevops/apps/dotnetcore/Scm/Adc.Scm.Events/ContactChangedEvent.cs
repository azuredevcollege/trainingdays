namespace Adc.Scm.Events
{
    public class ContactChangedEvent : EventBase
    {
        public ContactChangedEvent() 
            : base("ContactChangedEvent", 1)
        {
        }
    }
}
