using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System.Threading.Tasks;
using Azure.Storage.Queues;

namespace Adc.Scm.Resources.Api.Services
{
    public class StorageQueueService
    {
        private readonly StorageQueueOptions _options;
        private static readonly object _syncRoot = new object();
        private static bool _queueCreated = false;

        public StorageQueueService(IOptions<StorageQueueOptions> options)
        {
            _options = options.Value;
        }

        public async Task NotifyImageCreated(string image)
        {
            var queue = GetQueue();

            var msg = new ImageCreatedMsg
            {
                Image = image,
                ImageContainer = _options.ImageContainer,
                ThumbnailContainer = _options.ThumbnailContainer
            };

            var payload = JsonConvert.SerializeObject(msg);
            var b64payload = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(payload));

            await queue.SendMessageAsync(b64payload);
        }

        private QueueClient GetQueue()
        {
            var queueClient = new QueueClient(_options.StorageAccountConnectionString, _options.Queue);

            if (!_queueCreated)
            {
                lock (_syncRoot)
                {
                    if (!_queueCreated)
                    {
                        queueClient.CreateIfNotExistsAsync().GetAwaiter().GetResult();
                        _queueCreated = true;
                    }
                }
            }

            return queueClient;
        }
    }
}
