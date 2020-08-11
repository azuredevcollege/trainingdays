using Microsoft.AspNetCore.Builder;

namespace Adc.Scm.Api.Swagger
{
    public static class ApplicationBuilderExtensions
    {
        public static IApplicationBuilder UseSwaggerWithUI(this IApplicationBuilder app)
        {
            app.UseSwagger(c => 
            {
                c.RouteTemplate = "api/contacts/swagger/{documentName}/swagger.json";
            });

            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/api/contacts/swagger/v1/swagger.json", "Contacts API v1");
                c.RoutePrefix = "api/contacts/swagger";
            });
            return app;
        }
    }
}