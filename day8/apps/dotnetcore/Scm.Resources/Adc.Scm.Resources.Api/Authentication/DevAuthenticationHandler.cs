using System;
using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Adc.Scm.Resources.Api.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Adc.Scm.Resources.Api.Authentication
{
    public class DevAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        public static readonly Guid UserId = Guid.Parse("687d7c63-9a15-4faf-af5a-140782baa24d");
        public const string AuthScheme = "DevAuth";
        private readonly Claim _DefaultUserIdClaim = new Claim("http://schemas.microsoft.com/identity/claims/objectidentifier", UserId.ToString());
        private static readonly string _Scopes = AuthorizationScopes.ContactsRead + " " + AuthorizationScopes.ContactsCreate + " " + AuthorizationScopes.ContactsDelete + " " + AuthorizationScopes.ContactsUpdate;
        public DevAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options, 
            ILoggerFactory logger, 
            UrlEncoder encoder, 
            ISystemClock clock) 
            : base(options, logger, encoder, clock)
        {
        }

        protected override Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            var authenticationTicket = new AuthenticationTicket(
                new ClaimsPrincipal(new ClaimsIdentity(new Claim[] 
                    { 
                        _DefaultUserIdClaim,
                        new Claim("http://schemas.microsoft.com/identity/claims/scope", _Scopes) 
                    }, 
                    AuthScheme)),
                new AuthenticationProperties(),
                AuthScheme);
                
            return Task.FromResult(AuthenticateResult.Success(authenticationTicket));
        }
    }
}