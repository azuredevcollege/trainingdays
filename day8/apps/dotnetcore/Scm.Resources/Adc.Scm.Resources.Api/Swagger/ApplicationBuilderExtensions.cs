using Microsoft.AspNetCore.Builder;

namespace Adc.Scm.Resources.Api.Swagger
{
    public static class ApplicationBuilderExtensions
    {
        public static IApplicationBuilder UseSwaggerWithUI(this IApplicationBuilder app)
        {
            app.UseSwagger(c => 
            {
                c.RouteTemplate = "api/resources/swagger/{documentName}/swagger.json";
            });

            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/api/resources/swagger/v1/swagger.json", "Contacts API v1");
                c.RoutePrefix = "api/resources/swagger";
            });
            return app;
        }
    }
}