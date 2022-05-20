using Microsoft.Extensions.Options;
using System;
using System.IO;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

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

            var blob = container.GetBlobClient(blobname);
            var uploadOne = blob.UploadAsync(BinaryData.FromBytes(data));

            var outputBlob = GetOutputContainer().GetBlobClient(blobname);
            var uploadTwo = outputBlob.UploadAsync(BinaryData.FromBytes(data));

            await Task.WhenAll(uploadOne, uploadTwo);

            return Tuple.Create(blobname, outputBlob.Uri.AbsoluteUri);            
        }

        public async Task<byte[]> Get(string image)
        {
            var container = GetOutputContainer();
            var blob = container.GetBlobClient(image);

            try
            {
                using (var memstream = new MemoryStream())
                {
                    var res = await blob.DownloadContentAsync();
                    return res.Value.Content.ToArray();
                }
            }
            catch (Exception)
            {
                return null;
            }                        
        }

        private BlobContainerClient GetInputContainer()
        {
            var blobClient = new BlobContainerClient(_options.StorageAccountConnectionString, _options.ImageContainer);

            if (!_inputContainerCreated)
            {
                lock (_mySyncRoot)
                {
                    if (!_inputContainerCreated)
                    {
                        blobClient.CreateIfNotExistsAsync(PublicAccessType.Blob, null, null).GetAwaiter().GetResult();
                        _inputContainerCreated = true;
                    }
                }
            }

            return blobClient;
        }

        private BlobContainerClient GetOutputContainer()
        {
            var blobClient = new BlobContainerClient(_options.StorageAccountConnectionString, _options.ThumbnailContainer);

            if (!_outputContainerCreated)
            {
                lock (_mySyncRoot)
                {
                    if (!_outputContainerCreated)
                    {
                        blobClient.CreateIfNotExistsAsync(PublicAccessType.Blob, null, null).GetAwaiter().GetResult();
                        _outputContainerCreated = true;
                    }
                }
            }

            return blobClient;
        }
    }
}
