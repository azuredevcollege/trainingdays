using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Adc.Scm.Search.Indexer
{
    public static class ContactIndexer
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

        [FunctionName(nameof(ContactIndexer))]
        public static void Run([ServiceBusTrigger("sbt-contacts", "contactsearch", Connection = "ServiceBusConnectionString", IsSessionsEnabled = true)] ContactMessage msg, ILogger log, ExecutionContext context)
        {
            _context = context;

            ServiceProvider.GetRequiredService<ContactIndexerProcessor>().Process(msg).GetAwaiter().GetResult();

            log.LogInformation($"C# ServiceBus topic trigger function processed message: {msg.EventType}");
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
                .Configure<ContactIndexerOptions>(options => Configuration.Bind("ContactIndexerOptions", options))
                .AddScoped<ContactIndexerProcessor>();

            return serviceCollection.BuildServiceProvider();
        }
    }
}
