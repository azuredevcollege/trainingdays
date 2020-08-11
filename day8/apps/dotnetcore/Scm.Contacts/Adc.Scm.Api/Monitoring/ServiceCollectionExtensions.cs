using Adc.Scm.Api.Secrets;
using Dapr.Client;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace Adc.Scm.Api.Monitoring
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddApplicationInsights(this IServiceCollection services)
        {
            services.AddSingleton<IConfigureOptions<ApplicationInsightsServiceOptions>, ConfigureApplicationInsightsServiceOptions>();
            services.AddSingleton<ITelemetryInitializer, ApiTelemetryInitializer>();
            services.AddApplicationInsightsTelemetry();
            return services;
        }

        private class ConfigureApplicationInsightsServiceOptions : IConfigureOptions<ApplicationInsightsServiceOptions>
        {
            private readonly DaprClient _daprClient;

            public ConfigureApplicationInsightsServiceOptions(DaprClient daprClient)
            {
                _daprClient = daprClient;
            }

            public void Configure(ApplicationInsightsServiceOptions options)
            {
                // unfortunately, we can not read the key from the secretstore, because
                // when we are here, dapr is still not initialized and can not accept requests over gRPC :-(
                // Maybe that will change in the future. But until then we have to use Environment variables
                //var key = System.Environment.GetEnvironmentVariable(SecretConstants.AppInsightsKey);
                var key = _daprClient.GetSecretAsync(SecretConstants.StoreName, SecretConstants.AppInsightsKey).Result[SecretConstants.AppInsightsKey];

                if (!string.IsNullOrEmpty(key))
                    options.InstrumentationKey = key;
                else
                    options.InstrumentationKey = string.Empty;
            }
        }
    }
}