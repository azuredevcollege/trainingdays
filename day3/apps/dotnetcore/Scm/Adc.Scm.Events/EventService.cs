using Azure.Messaging.ServiceBus;
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
            try
            {
                var sender = GetSender();
                var json = JsonConvert.SerializeObject(evt);
                var msg = new ServiceBusMessage(Encoding.UTF8.GetBytes(json)) { ContentType = "application/json" };
                msg.SessionId = evt.UserId.ToString();
                await sender.SendMessageAsync(msg);
            }
            catch (System.Exception)
            {
                System.Console.WriteLine("Event not sent: ConnectionString might not be initialized.");
            }
        }

        private ServiceBusSender GetSender()
        {
            var conn = ServiceBusConnectionStringProperties.Parse(_options.ServiceBusConnectionString);

            var client = new ServiceBusClient(_options.ServiceBusConnectionString);
            return client.CreateSender(conn.EntityPath);
        }
    }
}
