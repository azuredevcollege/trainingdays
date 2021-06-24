using System;
using System.Collections.Generic;
using System.Text;

namespace Adc.Scm.Search.Indexer
{
    public static class ContactMessageExtensions
    {
        public static bool IsAddedMessage(this ContactMessage msg)
        {
            return msg.EventType == "ContactAddedEvent";
        }

        public static bool IsChangedMessage(this ContactMessage msg)
        {
            return msg.EventType == "ContactChangedEvent";
        }

        public static bool IsDeletedMessage(this ContactMessage msg)
        {
            return msg.EventType == "ContactDeletedEvent";
        }
    }
}
