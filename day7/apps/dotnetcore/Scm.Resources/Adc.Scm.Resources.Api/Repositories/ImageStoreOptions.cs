using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.Api.Repositories
{
    public class ImageStoreOptions
    {
        public string StorageAccountConnectionString { get; set; }
        public string ImageContainer { get; set; }
        public string ThumbnailContainer { get; set; }
    }
}
