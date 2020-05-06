using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Api.Services
{
    /// <summary>
    /// Provides access to claims of current user.
    /// </summary>
    public class ClaimsProviderService
    {
        private const string _oidClaimType = "http://schemas.microsoft.com/identity/claims/objectidentifier";
        public Guid GetUserId(HttpContext context)
        {
            var oidClaim = context.User.Claims.FirstOrDefault(c => c.Type == _oidClaimType);
            if (null == oidClaim)
                throw new InvalidOperationException("No oid claim!");
            
            var oid = Guid.Parse(oidClaim.Value);
            return oid;
        }
    }
}
