using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SixLabors.ImageSharp;

namespace Adc.Scm.Resources.ImageResizer
{
    public static class ImageResizer
    {
        private static ExecutionContext _context;

        private static Lazy<IConfiguration> _configuration = new Lazy<IConfiguration>(BuildConfiguration);
        private static Lazy<ServiceProvider> _serviceProvider = new Lazy<ServiceProvider>(BuildServices);

        private static IConfiguration Configuration
        {
            get { return _configuration.Value; }
        }

        private static ServiceProvider ServiceProvider
        {
            get { return _serviceProvider.Value; }
        }

        [FunctionName(nameof(ImageResizer))]
        public static void Run([ServiceBusTrigger("sbq-scm-thumbnails", Connection = "ServiceBusConnectionString")] ResizeMessage msg,
            ILogger log, ExecutionContext context)
        {
            _context = context;

            try
            {
                ServiceProvider.GetRequiredService<ImageProcessor>().Process(msg).GetAwaiter().GetResult();
            }
            catch (Exception ex)
            {
                log.LogInformation(ex.Message);
            }


            log.LogInformation($"Function processed: {msg}");
        }

        private static IConfiguration BuildConfiguration()
        {
            return new ConfigurationBuilder()
                .SetBasePath(_context.FunctionAppDirectory)
                .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();
        }

        private static ServiceProvider BuildServices()
        {
            var serviceCollection = new ServiceCollection();

            serviceCollection
                .AddOptions()
                .Configure<ImageProcessorOptions>(c => Configuration.Bind("ImageProcessorOptions", c))
                .AddScoped<ImageProcessor>();

            return serviceCollection.BuildServiceProvider();
        }
    }
}
