using Dapr.Client;
using Adc.Scm.Resources.Api.Secrets;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;

namespace Adc.Scm.Resources.Api.Authentication
{
    public static class AutheticationServicesExtensions
    {
        public static IServiceCollection AddAuthentication(this IServiceCollection services, IHostEnvironment env)
        {
            // In development use the DevAuthenticationHandler
            if (env.IsDevelopment() || env.IsKubernetesDevelopment())
            {
                services.AddAuthentication(options => 
                {
                    options.DefaultScheme = DevAuthenticationHandler.AuthScheme;
                }).AddScheme<AuthenticationSchemeOptions, DevAuthenticationHandler>(DevAuthenticationHandler.AuthScheme, _ => {});
            }
            else // use AzureAd
            {
                services.AddAuthentication(options => 
                {
                    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                }).AddAzureAdBearer();
            }

            return services;
        }
    }
    
    public static class AuthenticationBuilderExtensions
    {
        public static AuthenticationBuilder AddAzureAdBearer(this AuthenticationBuilder builder)
        {
            builder.Services.AddSingleton<IConfigureOptions<AzureAdOptions>, ConfigureAzureAdOptions>();
            builder.Services.AddSingleton<IConfigureOptions<JwtBearerOptions>, ConfigureJwtBearerOptions>();
            builder.AddJwtBearer();
            return builder;
        }

        private class ConfigureAzureAdOptions : IConfigureOptions<AzureAdOptions>
        {
            private readonly DaprClient _daprClient;
            public ConfigureAzureAdOptions(DaprClient daprClient)
            {
                _daprClient = daprClient;
            }

            public void Configure(AzureAdOptions options)
            {
                options.ClientId = _daprClient.GetSecretAsync(SecretConstants.StoreName, SecretConstants.AadClientIdKey).Result[SecretConstants.AadClientIdKey];
                options.ClientIdUri = _daprClient.GetSecretAsync(SecretConstants.StoreName, SecretConstants.AadClientIdUriKey).Result[SecretConstants.AadClientIdUriKey];
                options.TenantId = _daprClient.GetSecretAsync(SecretConstants.StoreName, SecretConstants.AadTenantId).Result[SecretConstants.AadTenantId];
            }
        }

        private class ConfigureJwtBearerOptions : IConfigureNamedOptions<JwtBearerOptions>
        {
            private readonly AzureAdOptions _azureAdOptions;

            public ConfigureJwtBearerOptions(IOptions<AzureAdOptions> options)
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