using Microsoft.Azure.ServiceBus;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
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
            var client = GetQueueClient();
            var msg = new ImageCreatedMsg
            {
                Image = image,
                ImageContainer = _options.ImageContainer,
                ThumbnailContainer = _options.ThumbnailContainer
            };

            var payload = JsonConvert.SerializeObject(msg);
            await client.SendAsync(new Message(Encoding.UTF8.GetBytes(payload)));
        }

        private QueueClient GetQueueClient()
        {
            return new QueueClient(new ServiceBusConnectionStringBuilder(_options.ThumbnailQueueConnectionString));
        }
    }
}
