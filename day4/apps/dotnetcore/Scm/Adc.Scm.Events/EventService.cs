using Microsoft.Azure.ServiceBus;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;

namespace Adc.Scm.Events
{
    public class EventService
    {
        private readonly EventServiceOptions _options;

        public EventService(IOptions<EventServiceOptions> options)
        {
            _options = options.Value;
        }

        public async Task Send(EventBase evt)
        {
            var client = GetClient();
            var json = JsonConvert.SerializeObject(evt);
            var msg = new Message(Encoding.UTF8.GetBytes(json));
            msg.SessionId = evt.UserId.ToString();
            await client.SendAsync(msg);
        }

        private TopicClient GetClient()
        {
            return new TopicClient(new ServiceBusConnectionStringBuilder(_options.ServiceBusConnectionString));
        }
    }
}
