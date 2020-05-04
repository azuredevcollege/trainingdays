using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;

namespace Adc.Scm.Search.Api.Authorization
{
    public static class ServiceCollectionExtensions
    {
        private const string _scopeClaimType = "http://schemas.microsoft.com/identity/claims/scope";        
        
        public static IServiceCollection AddContactsAuthorization(this IServiceCollection services)
        {
            return services.AddAuthorization(options =>
            {
                AddPolicy(options, AuthorizationScopes.ContactsRead);
                AddPolicy(options, AuthorizationScopes.ContactsUpdate);
                AddPolicy(options, AuthorizationScopes.ContactsCreate);
                AddPolicy(options, AuthorizationScopes.ContactsDelete);
            });
        }

        private static void AddPolicy(AuthorizationOptions options, string scope)
        {
            options.AddPolicy(scope, policy => 
            {
                policy.RequireAssertion(context => {
                    return context.User.HasClaim(claim => {
                        return claim.Type == _scopeClaimType && claim.Value.Contains(scope);
                    });
                });
            });
        }
    }
}