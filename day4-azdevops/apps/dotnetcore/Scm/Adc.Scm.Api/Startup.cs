using Adc.Scm.Api.Monitoring;
using Adc.Scm.Api.Services;
using Adc.Scm.Events;
using Adc.Scm.Repository.EntityFrameworkCore;
using Adc.Scm.Repository.Interfaces;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using System;

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

        // HACK: Keep Sqlite connection open !!!
        private static SqliteConnection _sqlite;


        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Initialize ApplicationInsights
            services.AddSingleton<ITelemetryInitializer, ApiTelemetryInitializer>();
            services.AddApplicationInsightsTelemetry();


            services.AddControllers();            

            if (HostingEnvironment.IsDevelopment())
            {
                var connStr = Configuration.GetConnectionString("DefaultConnectionString");

                // Use Sqlite in development mode if ConnectionString is specified
                if (!string.IsNullOrEmpty(connStr))
                {
                    _sqlite = new SqliteConnection("DataSource=:memory:");
                    _sqlite.Open();
                    services.AddEntityFrameworkSqlServer();
                    services.AddDbContext<ContactDbContext>(options => options.UseSqlite(_sqlite));
                    services.AddScoped<IContactRepository, ContactRepository>();
                }
                // Use CosmosDb if no ConnectionString is specified
                else
                {
                    services.Configure<Repository.CosmosDb.RepositoryOptions>(options => Configuration.Bind("CosmosOptions", options));
                    services.AddScoped<IContactRepository, Repository.CosmosDb.ContactRepository>();
                }
            }
            else
            {
                var connStr = Configuration.GetConnectionString("DefaultConnectionString");
                // Use SqlDatabase in production if ConnectionString is specified
                if (!string.IsNullOrEmpty(connStr))
                {
                    services.AddEntityFrameworkSqlServer();
                    services.AddDbContext<ContactDbContext>(options => options.UseSqlServer(connStr));
                    services.AddScoped<IContactRepository, ContactRepository>();
                }
                // Use CosmosDb if no ConnectionString is specified
                else
                {                    
                    services.Configure<Repository.CosmosDb.RepositoryOptions>(options => Configuration.Bind("CosmosOptions", options));
                    services.AddScoped<IContactRepository, Repository.CosmosDb.ContactRepository>();
                }
            }
                        
            services.AddScoped<MapperService>();
            services.AddScoped<ClaimsProviderService>();
            services.Configure<EventServiceOptions>(options => Configuration.Bind("EventServiceOptions", options));
            services.AddScoped<EventService>();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "Contacts API", Version = "v1" });
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
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Contacts API v1");
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
