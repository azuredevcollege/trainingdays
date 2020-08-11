using Adc.Scm.Api.Secrets;
using Adc.Scm.Repository.EntityFrameworkCore;
using Adc.Scm.Repository.Interfaces;
using Dapr.Client;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;

namespace Adc.Scm.Api.Database
{
    public static class ServiceCollectionExtension
    {
        // HACK: Keep Sqlite connection open !!!
        private static SqliteConnection _sqlite;
        
        public static IServiceCollection AddDatabaseServices(this IServiceCollection services, IHostEnvironment env)
        {
            services.AddSingleton<IConfigureOptions<SqlOptions>, ConfigureSqlOptions>();

            if (env.IsDevelopment())
            {
                services.AddEntityFrameworkSqlServer();
                services.AddDbContext<ContactDbContext>((sp, options) => 
                {
                    if (null == _sqlite)
                    {
                        var sqlOptions = sp.GetRequiredService<IOptions<SqlOptions>>();
                        _sqlite = new SqliteConnection(sqlOptions.Value.ConnectionString);
                        _sqlite.Open();
                    }

                    options.UseSqlite(_sqlite);
                });

                IServiceCollection serviceCollections = services.AddScoped<IContactRepository, ContactRepository>();
            }
            else
            {
                services.AddEntityFrameworkSqlServer();
                services.AddDbContext<ContactDbContext>((sp, options) => 
                    {
                        var sqlOptions = sp.GetRequiredService<IOptions<SqlOptions>>();
                        options.UseSqlServer(sqlOptions.Value.ConnectionString);
                    });
                services.AddScoped<IContactRepository, ContactRepository>();
            }
            return services;
        }

        private class ConfigureSqlOptions : IConfigureOptions<SqlOptions>
        {
            private readonly DaprClient _daprClient;

            public ConfigureSqlOptions(DaprClient daprClient)
            {
                _daprClient = daprClient;
            }

            public void Configure(SqlOptions options)
            {
                options.ConnectionString = _daprClient.GetSecretAsync(SecretConstants.StoreName, SecretConstants.SqlConnectionKey).Result[SecretConstants.SqlConnectionKey];
            }
        }
    }
}