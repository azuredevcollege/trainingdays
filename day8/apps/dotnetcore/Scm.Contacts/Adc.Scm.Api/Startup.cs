using System.Text.Json;
using Adc.Scm.Api.Monitoring;
using Adc.Scm.Api.Services;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Adc.Scm.Api.Authentication;
using Adc.Scm.Api.Authorization;
using Adc.Scm.Api.Database;
using Adc.Scm.Api.Swagger;

namespace Adc.Scm.Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostEnvironment env)
        {
            Configuration = configuration;
            HostingEnvironment = env;
        }

        public IConfiguration Configuration { get; }
        public IHostEnvironment HostingEnvironment { get; }

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

            services.AddAuthentication(HostingEnvironment);

            // Initialize authorization
            services.AddContactsAuthorization();

            // Initialize ApplicationInsights
            services.AddApplicationInsights();


            services.AddControllers();    
            services.AddDaprClient();        

            services.AddDatabaseServices(HostingEnvironment);
                        
            services.AddScoped<MapperService>();
            services.AddScoped<ClaimsProviderService>();

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

            if (env.IsDevelopment() || env.IsKubernetesDevelopment())
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
