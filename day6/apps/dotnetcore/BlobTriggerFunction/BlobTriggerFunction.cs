using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;

namespace AzDevCollege.Function
{
    public static class BlobTrigger
    {
        [FunctionName(nameof(BlobTrigger))]
        public static void Run(
            [BlobTrigger("originals/{name}", Connection = "StorageAccountConnectionString")] Stream myBlob, string name,
            [Blob("processed/proc_{name}", FileAccess.Write)] Stream outStream, ILogger log)
        {
            using (Image image = Image.Load(myBlob))
            {
                // Resize and rotate the image!
                image.Mutate(x => x.Resize(image.Width / 2, image.Height / 2));
                image.Mutate(x => x.Rotate(90));

                image.SaveAsJpeg(outStream);
            }
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
        }
    }
}