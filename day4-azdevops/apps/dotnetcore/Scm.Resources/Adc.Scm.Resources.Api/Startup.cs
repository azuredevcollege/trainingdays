using Adc.Scm.Resources.Api.Formatter;
using Adc.Scm.Resources.Api.Monitoring;
using Adc.Scm.Resources.Api.Repositories;
using Adc.Scm.Resources.Api.Services;
using Microsoft.ApplicationInsights.Extensibility;
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
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Initialize ApplicationInsights
            services.AddSingleton<ITelemetryInitializer, ApiTelemetryInitializer>();
            services.AddApplicationInsightsTelemetry();

            services.AddControllers(options =>
            {
                options.InputFormatters.Add(new ImageInputFormatter());
            });

            services.AddScoped<ImageRepository>();
            services.Configure<ImageStoreOptions>(c => Configuration.Bind("ImageStoreOptions", c));
            services.AddScoped<ServiceBusQueueService>();
            services.Configure<ServiceBusQueueOptions>(c => Configuration.Bind("ServiceBusQueueOptions", c));

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "Resources API", Version = "v1" });
            });

            services.AddCors(options =>
            {
                options.AddPolicy("AllowAnyOrigin", builder => builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod().WithExposedHeaders("Location"));
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            app.UseCors("AllowAnyOrigin");

            app.UseSwagger();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Resources API v1");
                c.RoutePrefix = string.Empty;
            });

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
