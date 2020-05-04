using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;

namespace Adc.Scm.Resources.Api.Authorization
{
    public static class ServiceCollectionExtensions
    {
        private const string _scopeClaimType = "http://schemas.microsoft.com/identity/claims/scope";        
        
        public static IServiceCollection AddContactsAuthorization(this IServiceCollection services)
        {
            return services.AddAuthorization(options =>
            {
                options.AddPolicy(AuthorizationPolicy.ContactsCreateOrUpdate, policy => 
                {
                    policy.RequireAssertion(context => {
                        return context.User.HasClaim(claim => {
                            return claim.Type == _scopeClaimType 
                                && (claim.Value.Contains(AuthorizationScopes.ContactsCreate) 
                                    || claim.Value.Contains(AuthorizationScopes.ContactsDelete));
                        });
                    });
                });

                options.AddPolicy(AuthorizationPolicy.ContactsRead, policy => 
                {
                    policy.RequireAssertion(context => {
                        return context.User.HasClaim(claim => {
                            return claim.Type == _scopeClaimType 
                                && claim.Value.Contains(AuthorizationScopes.ContactsRead);
                        });
                    });
                });
            });
        }
    }
}