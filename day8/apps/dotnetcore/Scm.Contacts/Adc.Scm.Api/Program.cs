using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Adc.Scm.Api
{
    public class Program
    {
        public static SemaphoreSlim DaprInitSemaphor = new SemaphoreSlim(0, 1);
        public static void Main(string[] args)
        {
            var daprHost = CreateDaprHostBuilder(args).Build();
            daprHost.RunAsync();
            System.Console.WriteLine("INFO: Starting init server started.");
            DaprInitSemaphor.Wait();
            DaprInitSemaphor.Wait();
            daprHost.StopAsync().Wait();
            System.Console.WriteLine("INFO: Starting server.");
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        
        public static IHostBuilder CreateDaprHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder => 
            {
                
                webBuilder.UseStartup<StartupDapr>();
            });
    }
}
