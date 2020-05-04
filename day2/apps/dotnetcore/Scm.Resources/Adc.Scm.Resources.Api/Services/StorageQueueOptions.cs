using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.Api.Services
{
    public class StorageQueueOptions
    {
        public string StorageAccountConnectionString { get; set; }
        public string Queue { get; set; }
        public string ImageContainer { get; set; }
        public string ThumbnailContainer { get; set; }
    }
}
