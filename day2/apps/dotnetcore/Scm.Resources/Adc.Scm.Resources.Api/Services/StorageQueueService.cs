using Microsoft.Extensions.Options;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Queue;
using Newtonsoft.Json;
using System.Threading.Tasks;

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

            await queue.AddMessageAsync(new CloudQueueMessage(payload));
        }
        
        private CloudQueue GetQueue()
        {
            var account = CloudStorageAccount.Parse(_options.StorageAccountConnectionString);
            var queueClient = account.CreateCloudQueueClient();
            var queue = queueClient.GetQueueReference(_options.Queue);

            if (!_queueCreated)
            {
                lock (_syncRoot)
                {
                    if (!_queueCreated)
                    {
                        queue.CreateIfNotExistsAsync().GetAwaiter().GetResult();
                        _queueCreated = true;
                    }
                }
            }

            return queue;
        }
    }
}
