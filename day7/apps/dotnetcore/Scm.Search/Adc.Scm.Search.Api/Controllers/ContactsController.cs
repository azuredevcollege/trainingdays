using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Adc.Scm.Search.Api.Models;
using Adc.Scm.Search.Api.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Adc.Scm.Search.Api.Controllers
{
    [ApiController]
    [Route("contacts")]    
    [Produces("application/json")]
    public class ContactsController : ControllerBase
    {
        private readonly ContactSearchService _service;
        private readonly ClaimsProviderService _claimsProvider;

        public ContactsController(ContactSearchService service, ClaimsProviderService claimsProvider)
        { 
            _service = service;
            _claimsProvider = claimsProvider;
        }

        [HttpGet]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        public async Task<object> Search([FromQuery]string phrase)
        {
            var userId = _claimsProvider.GetUserId(Request.HttpContext);
            return Ok(await _service.Search(userId, phrase));           
        }

        [HttpPost]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        public async Task<object> Search([FromBody]ContactSearch search)
        {
            var userId = _claimsProvider.GetUserId(Request.HttpContext);
            return Ok(await _service.Search(userId, search));
        }
    }
}