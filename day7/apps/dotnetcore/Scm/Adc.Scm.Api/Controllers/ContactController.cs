using Adc.Scm.Api.Models;
using Adc.Scm.Api.Services;
using Adc.Scm.Events;
using Adc.Scm.Repository.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;

namespace Adc.Scm.Api.Controllers
{
    [ApiController]
    [Route("contacts")]
    [Produces("application/json")]
    public class ContactController : ControllerBase
    {
        private readonly IContactRepository _repository;
        private readonly ClaimsProviderService _claimsProvider;
        private readonly MapperService _mapper;
        private readonly EventService _eventService;

        public ContactController(
            IContactRepository repository, 
            MapperService mapper, 
            ClaimsProviderService claimsProvider,
            EventService eventService)
        {
            _repository = repository;
            _claimsProvider = claimsProvider;
            _mapper = mapper;
            _eventService = eventService;
        }

        [HttpGet]
        [ProducesResponseType(typeof(List<Contact>), (int)HttpStatusCode.OK)]
        public async Task<IActionResult> Get()
        {
            var userId = _claimsProvider.GetUserId(this.HttpContext);
            var domainObjects = await _repository.Get(userId);
            return Ok(_mapper.Map<List<DomainObjects.Contact>, List<Contact>>(domainObjects));
        }

        [HttpGet("{id}")]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType(typeof(Contact), (int)HttpStatusCode.OK)]
        public async Task<IActionResult> GetById(Guid id)
        {
            var userId = _claimsProvider.GetUserId(this.HttpContext);
            var result = await _repository.Get(userId, id);
            if (null == result)
                return NotFound();

            return Ok(_mapper.Map<DomainObjects.Contact, Contact>(result));
        }

        [HttpPost]
        [ProducesResponseType(typeof(Contact), (int)HttpStatusCode.Created)]
        public async Task<IActionResult> Add([FromBody]Contact contact)
        {
            var userId = _claimsProvider.GetUserId(this.HttpContext);
            var domainContact = await _repository.Add(userId, _mapper.Map<Contact, DomainObjects.Contact>(contact));
            var evt = _mapper.Map<DomainObjects.Contact, ContactAddedEvent>(domainContact);
            await _eventService.Send(evt);
            return CreatedAtAction(nameof(GetById), new { id = domainContact.Id }, _mapper.Map<DomainObjects.Contact, Contact>(domainContact));
        }

        [HttpPut("{id}")]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType(typeof(Contact), (int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        public async Task<IActionResult> Save(Guid id, [FromBody]Contact contact)
        {
            if (id != contact.Id)
                return BadRequest($"Provided id does not match Contact.Id");

            var userId = _claimsProvider.GetUserId(this.HttpContext);
            var domainContact = await _repository.Save(userId, _mapper.Map<Contact, DomainObjects.Contact>(contact));

            if (null == domainContact)
                return NotFound();

            var evt = _mapper.Map<DomainObjects.Contact, ContactChangedEvent>(domainContact);
            await _eventService.Send(evt);
            return Ok(_mapper.Map<DomainObjects.Contact, Contact>(domainContact));
        }

        [HttpDelete("{id}")]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.NoContent)]
        public async Task<IActionResult> Delete(Guid id)
        {
            var userId = _claimsProvider.GetUserId(this.HttpContext);
            var domainContact = await _repository.Delete(userId, id);
            if (null == domainContact)
                return NotFound();

            var evt = _mapper.Map<DomainObjects.Contact, ContactDeletedEvent>(domainContact);
            await _eventService.Send(evt);
            return NoContent();
        }
    }
}
