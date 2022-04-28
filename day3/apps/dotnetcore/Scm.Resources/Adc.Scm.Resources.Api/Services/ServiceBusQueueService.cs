using Azure.Messaging.ServiceBus;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.Api.Services
{
    public class ServiceBusQueueService
    {
        private readonly ServiceBusQueueOptions _options;

        public ServiceBusQueueService(IOptions<ServiceBusQueueOptions> options)
        {
            _options = options.Value;
        }

        public async Task NotifyImageCreated(string image)
        {
            var client = GetQueueSender();
            var msg = new ImageCreatedMsg
            {
                Image = image,
                ImageContainer = _options.ImageContainer,
                ThumbnailContainer = _options.ThumbnailContainer
            };

            var payload = JsonConvert.SerializeObject(msg);
            await client.SendMessageAsync(new ServiceBusMessage(Encoding.UTF8.GetBytes(payload)) { ContentType = "application/json" });
        }

        private ServiceBusSender GetQueueSender()
        {
            var conn = ServiceBusConnectionStringProperties.Parse(_options.ThumbnailQueueConnectionString);

            var client = new ServiceBusClient(_options.ThumbnailQueueConnectionString);
            return client.CreateSender(conn.EntityPath);

        }
    }
}
