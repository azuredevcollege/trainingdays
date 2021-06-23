using Microsoft.Extensions.Options;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats;
using SixLabors.ImageSharp.Formats.Gif;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Formats.Png;
using SixLabors.ImageSharp.Processing;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.ImageResizer
{
    public class ImageProcessor
    {
        private readonly ImageProcessorOptions _options;
        private static object _mySyncRoot = new object();
        private static bool _inputContainerCreated = false;
        private static bool _outputContainerCreated = false;

        public ImageProcessor(IOptions<ImageProcessorOptions> options)
        {
            _options = options.Value;
        }

        public async Task Process(ResizeMessage msg)
        {
            var thumbnailWidth = _options.ImageWidth;
            var inputContainer = GetInputContainer(msg);
            var outputContainer = GetOutputContainer(msg);

            var inputBlob = inputContainer.GetBlockBlobReference(msg.Image);
            var outputBlob = outputContainer.GetBlockBlobReference(msg.Image);
            var encoder = GetEncoder(msg.Image);

            if (null == encoder)
            {
                throw new NotSupportedException($"No encoder supported for {msg.Image}");
            }

            using (var inputStream = new MemoryStream())
            using (var outputStream = new MemoryStream())
            {
                await inputBlob.DownloadToStreamAsync(inputStream);
                inputStream.Position = 0;

                using (var image = Image.Load(inputStream))
                {
                    var divisor = image.Width / thumbnailWidth;
                    var height = Convert.ToInt32(Math.Round((decimal)(image.Height / divisor)));
                    image.Mutate(x => x.Resize(thumbnailWidth, height));
                    image.Save(outputStream, encoder);
                    outputStream.Position = 0;
                }

                await outputBlob.UploadFromStreamAsync(outputStream);
            }
        }

        private CloudBlobContainer GetInputContainer(ResizeMessage msg)
        {
            var account = CloudStorageAccount.Parse(_options.StorageAccountConnectionString);
            var blobClient = account.CreateCloudBlobClient();

            var container = blobClient.GetContainerReference(msg.ImageContainer);

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

        private CloudBlobContainer GetOutputContainer(ResizeMessage msg)
        {
            var account = CloudStorageAccount.Parse(_options.StorageAccountConnectionString);
            var blobClient = account.CreateCloudBlobClient();

            var container = blobClient.GetContainerReference(msg.ThumbnailContainer);

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

        private IImageEncoder GetEncoder(string image)
        {
            IImageEncoder encoder = null;
            var extension = Path.GetExtension(image);
            extension = extension.Replace(".", "");

            switch (extension)
            {
                case "png":
                    encoder = new PngEncoder();
                    break;
                case "jpg":
                    encoder = new JpegEncoder();
                    break;
                case "jpeg":
                    encoder = new JpegEncoder();
                    break;
                case "gif":
                    encoder = new GifEncoder();
                    break;
                default:
                    break;
            }

            return encoder;
        }
    }
}
