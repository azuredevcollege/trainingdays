using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Search.Api.Services
{
    public class ClaimsProviderService
    {
        public Guid GetUserId(HttpContext context)
        {
            // We have not integrated Identity yet. So we just return an empty Guid
            return Guid.Empty;
        }
    }
}
