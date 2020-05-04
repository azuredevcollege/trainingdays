using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using System;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.Api.Authentication
{
    public static class AuthenticationBuilderExtensions
    {
        public static AuthenticationBuilder AddAzureAdBearer(this AuthenticationBuilder builder)
            => builder.AddAzureAdBearer(_ => { });

        public static AuthenticationBuilder AddAzureAdBearer(this AuthenticationBuilder builder, Action<AzureAdOptions> configureOptions)
        {
            builder.Services.Configure(configureOptions);
            builder.Services.AddSingleton<IConfigureOptions<JwtBearerOptions>, ConfigureAzureAdOptions>();
            builder.AddJwtBearer();
            return builder;
        }

        private class ConfigureAzureAdOptions : IConfigureNamedOptions<JwtBearerOptions>
        {
            private readonly AzureAdOptions _azureAdOptions;

            public ConfigureAzureAdOptions(IOptions<AzureAdOptions> options)
            {
                _azureAdOptions = options.Value;
            }

            public void Configure(string name, JwtBearerOptions options)
            {
                options.Audience = _azureAdOptions.ClientId;
                options.Authority = $"{_azureAdOptions.Instance}/{_azureAdOptions.TenantId}/v2.0";
                options.TokenValidationParameters.ValidAudiences = new string[] { _azureAdOptions.ClientIdUri };
                options.TokenValidationParameters.ValidIssuer = $"https://sts.windows.net/{_azureAdOptions.TenantId}/";

                options.Events = new JwtBearerEvents
                {
                    OnTokenValidated = context =>
                    {
                        // If your authentication logic is based on users then add your logic here
                        // If you want to add additional claims, this is the right place.
                        // e.g.:
                        // var objectId = context.Principal.GetObjectId();

                        // var db = context.HttpContext.RequestServices.GetRequiredService<AuthorizationDbContext>();
                        // bool isSuperAdmin = await db.SuperAdmins.AnyAsync(a => a.ObjectId == objectId);
                        // if (isSuperAdmin)
                        // {
                        //     //Add claim if they are
                        //     var claims = new List<Claim>
                        //     {
                        //         new Claim(ClaimTypes.Role, "superadmin")
                        //     };
                        //     var appIdentity = new ClaimsIdentity(claims);

                        //     context.Principal.AddIdentity(appIdentity);
                        // }
                        return Task.CompletedTask;
                    },
                    OnAuthenticationFailed = context => 
                    {   
                        return Task.CompletedTask;
                    },
                    OnForbidden = context => 
                    {
                        return Task.CompletedTask;
                    }
                };
            }

            public void Configure(JwtBearerOptions options)
            {
                Configure(Options.DefaultName, options);
            }
        }
    }
}