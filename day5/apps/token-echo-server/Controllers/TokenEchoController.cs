using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace token_echo_server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TokenEchoController : ControllerBase
    {
        private readonly ILogger<TokenEchoController> _logger;

        public TokenEchoController(ILogger<TokenEchoController> logger)
        {
            _logger = logger;
        }

        [HttpPost]
        public async Task<IActionResult> EchoToken()
        {
            string [] values = null;
            dynamic @return = new ExpandoObject();
            IDictionary<string, object> dict = @return;

            using (var reader = new StreamReader(Request.Body, Encoding.UTF8))
            {
                var result = await reader.ReadToEndAsync();
                values = result.Split('&');
                
                foreach (var val in values)
                {
                    _logger.LogInformation(val);
                    var tmp = val.Split('=');
                    dict.Add(tmp[0], tmp[1]);
                }
            }
            
            return Ok(@return);
        }
    }
}