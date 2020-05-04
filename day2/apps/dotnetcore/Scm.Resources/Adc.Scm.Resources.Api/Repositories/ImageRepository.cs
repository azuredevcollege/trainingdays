using Microsoft.Extensions.Options;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.IO;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.Api.Repositories
{
    public class ImageRepository
    {
        private readonly ImageStoreOptions _options;
        private static object _mySyncRoot = new object();
        private static bool _inputContainerCreated = false;
        private static bool _outputContainerCreated = false;

        public ImageRepository(IOptions<ImageStoreOptions> options)
        {
            _options = options.Value;
        }

        public async Task<Tuple<string, string>> Add(string filename, byte[] data)
        {
            var extension = Path.GetExtension(filename);
            var id = Guid.NewGuid();
            var blobname = $"{id.ToString()}{extension}";

            var container = GetInputContainer();

            var blob = container.GetBlockBlobReference(blobname);
            var uploadOne = blob.UploadFromByteArrayAsync(data, 0, data.Length);

            var outputBlob = GetOutputContainer().GetBlockBlobReference(blobname);
            var uploadTwo = outputBlob.UploadFromByteArrayAsync(data, 0, data.Length);

            await Task.WhenAll(uploadOne, uploadTwo);

            return Tuple.Create(blobname, outputBlob.StorageUri.PrimaryUri.OriginalString);            
        }

        public async Task<byte[]> Get(string image)
        {
            var container = GetOutputContainer();
            var blob = container.GetBlockBlobReference(image);

            try
            {
                using (var memstream = new MemoryStream())
                {
                    await blob.DownloadToStreamAsync(memstream);
                    return memstream.ToArray();
                }
            }
            catch (Exception)
            {
                return null;
            }                        
        }

        private CloudBlobContainer GetInputContainer()
        {
            var account = CloudStorageAccount.Parse(_options.StorageAccountConnectionString);
            var blobClient = account.CreateCloudBlobClient();

            var container = blobClient.GetContainerReference(_options.ImageContainer);

            if (!_inputContainerCreated)
            {
                lock (_mySyncRoot)
                {
                    if (!_inputContainerCreated)
                    {
                        container.CreateIfNotExistsAsync(BlobContainerPublicAccessType.Blob, null, null).GetAwaiter().GetResult();
                        _inputContainerCreated = true;
                    }
                }
            }

            return container;
        }

        private CloudBlobContainer GetOutputContainer()
        {
            var account = CloudStorageAccount.Parse(_options.StorageAccountConnectionString);
            var blobClient = account.CreateCloudBlobClient();

            var container = blobClient.GetContainerReference(_options.ThumbnailContainer);

            if (!_outputContainerCreated)
            {
                lock (_mySyncRoot)
                {
                    if (!_outputContainerCreated)
                    {
                        container.CreateIfNotExistsAsync(BlobContainerPublicAccessType.Blob, null, null).GetAwaiter().GetResult();
                        _outputContainerCreated = true;
                    }
                }
            }

            return container;
        }
    }
}
