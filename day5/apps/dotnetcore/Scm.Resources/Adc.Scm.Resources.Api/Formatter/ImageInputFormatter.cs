using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.Net.Http.Headers;
using System.IO;
using System.Threading.Tasks;

namespace Adc.Scm.Resources.Api.Formatter
{
    public class ImageInputFormatter : InputFormatter
    {
        public ImageInputFormatter()
        {
            SupportedMediaTypes.Add(new MediaTypeHeaderValue("image/png"));
            SupportedMediaTypes.Add(new MediaTypeHeaderValue("image/gif"));
            SupportedMediaTypes.Add(new MediaTypeHeaderValue("image/jpeg"));
            SupportedMediaTypes.Add(new MediaTypeHeaderValue("image/jpg"));
        }
        public override bool CanRead(InputFormatterContext context)
        {
            var content = context.HttpContext.Request.ContentType;

            return content == "image/png" || content == "image/gif" || content == "image/jpeg" || content == "image/jpg";
        }

        public override async Task<InputFormatterResult> ReadRequestBodyAsync(InputFormatterContext context)
        {
            using (var memstream = new MemoryStream(2018))
            {
                await context.HttpContext.Request.Body.CopyToAsync(memstream);
                return await InputFormatterResult.SuccessAsync(memstream.ToArray());
            }
        }
    }
}
