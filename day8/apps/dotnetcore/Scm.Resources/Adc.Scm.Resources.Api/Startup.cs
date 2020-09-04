using System.Text.Json;
using Adc.Scm.Resources.Api.Authentication;
using Adc.Scm.Resources.Api.Authorization;
using Adc.Scm.Resources.Api.Formatter;
using Adc.Scm.Resources.Api.Monitoring;
using Adc.Scm.Resources.Api.Repositories;
using Adc.Scm.Resources.Api.Services;
using Adc.Scm.Resources.Api.Swagger;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

namespace Adc.Scm.Resources.Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostEnvironment env)
        {
            Configuration = configuration;
            HostingEnvironment = env;
        }

        public IConfiguration Configuration { get; }
        public IHostEnvironment HostingEnvironment { get; set; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Add Json Serilaization Options
            services.AddSingleton(new JsonSerializerOptions()
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                DictionaryKeyPolicy = JsonNamingPolicy.CamelCase,
                PropertyNameCaseInsensitive = true,
            });
            
            services.AddHealthChecks();

            // Initialize authentication
            services.AddAuthentication(HostingEnvironment);

            // Initialize authorization
            services.AddContactsAuthorization();

            // Initialize ApplicationInsights
            services.AddApplicationInsights();

            services.AddControllers(options =>
            {
                options.InputFormatters.Add(new ImageInputFormatter());
            });

            services.AddDaprClient();

            services.AddScoped<ImageRepository>();
            services.Configure<ImageStoreOptions>(c => Configuration.Bind("ImageStoreOptions", c));
            services.AddScoped<ServiceBusQueueService>();
            services.Configure<ServiceBusQueueOptions>(c => Configuration.Bind("ServiceBusQueueOptions", c));

            services.AddSwagger(HostingEnvironment);

            services.AddCors(options =>
            {
                options.AddPolicy("AllowAnyOrigin", builder => builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod().WithExposedHeaders("Location"));
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            app.UseCors("AllowAnyOrigin");

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseSwaggerWithUI();
            app.UseRouting();
            app.UseCloudEvents();
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapSubscribeHandler();
                endpoints.MapControllers();
                endpoints.MapHealthChecks("/healthz");
            });
        }
    }
}
