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
    public class TokenEchoFragmentController : ControllerBase
    {
        private readonly ILogger<TokenEchoController> _logger;

        public TokenEchoFragmentController(ILogger<TokenEchoController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> EchoToken()
        {            
            await Task.Delay(0);
            return Ok("The id token is returned in the URL as a fragment (/api/tokenechofragment#id_token=eyJ...)");
        }
    }
}