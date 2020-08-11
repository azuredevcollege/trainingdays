using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace Adc.Scm.Api
{
    public class StartupDapr
    {
        public StartupDapr(IConfiguration configuration, IHostEnvironment environment)
        {
            Configuration = configuration;
            HostingEnvironment = environment;
        }

        public IConfiguration Configuration { get; }
        public IHostEnvironment HostingEnvironment { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();    
            services.AddDaprClient();  
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            app.Use(async (context, next) => 
            {
                System.Console.WriteLine($"INFO: Path {context.Request.Path} called.");

                if (context.Request.Path == "/dapr/config")
                {
                    // no configuration needed
                    System.Console.WriteLine("INFO: dapr/config called");
                    Program.DaprInitSemaphor.Release();
                    context.Response.StatusCode = 200;
                    return;
                }


                if (context.Request.Path == "/dapr/subscribe")
                {
                    // invoke next, to give dapr asp.net core a chance to
                    // register subscriber an routes
                    System.Console.WriteLine("INFO: dapr/subscribe called");
                    await next.Invoke();
                    Program.DaprInitSemaphor.Release();
                    return;
                }

                // if (context.Request.Path == "/testqueue" && context.Request.Method == "OPTIONS")
                // {
                //     // return 200 and allowed method POST
                //     context.Response.StatusCode = 200;
                //     context.Response.Headers.Add("Allow", new StringValues("POST"));
                //     Program.DaprInitSemaphor.Release();
                //     return;
                // }
                
                await next.Invoke();
            });

            app.UseRouting();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapSubscribeHandler();
                endpoints.MapControllers();
            });
        }
    }
}