using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Adc.Scm.Resources.Api.Repositories;
using Adc.Scm.Resources.Api.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Adc.Scm.Resources.Api.Controllers
{
    [ApiController]
    [Route("contactimages")]
    [Produces("application/json")]
    public class ContactImageController : ControllerBase
    {
        private readonly ImageRepository _repository;
        private readonly ServiceBusQueueService _service;

        public ContactImageController(ImageRepository repository, ServiceBusQueueService service)
        {
            _repository = repository;
            _service = service;
        }

        [HttpPost]
        [ProducesResponseType((int)HttpStatusCode.Created)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        public async Task<IActionResult> UploadImage([FromForm(Name = "imageupload")]IFormFile file)
        {
            // validate image extension
            var extension = Path.GetExtension(file.FileName);
            if (string.IsNullOrEmpty(extension))
                return BadRequest($"No file extension specified");

            extension = extension.Replace(".", "");
            var isSupported = Regex.IsMatch(extension, "gif|png|jpe?g", RegexOptions.IgnoreCase);

            if (!isSupported)
                return BadRequest($"{extension} is not supported");

            using (var memstream = new MemoryStream())
            {
                await file.CopyToAsync(memstream);

                var result = await _repository.Add(file.FileName, memstream.ToArray());
                await _service.NotifyImageCreated(result.Item1);

                return Created(result.Item2, null);
            }            
        }

        [HttpPost("binary")]
        [Consumes("image/png", "image/gif", "image/jpeg", "image/jpg")]
        [ProducesResponseType((int)HttpStatusCode.Created)]
        [ProducesResponseType((int)HttpStatusCode.BadRequest)]
        public async Task<IActionResult> BinaryUpload([FromBody]byte[] data)
        {
            var contentType = Request.ContentType;
            var type = contentType.ToString().Split('/')[1];

            var isSupported = Regex.IsMatch(type, "gif|png|jpe?g", RegexOptions.IgnoreCase);

            if (!isSupported)
                return BadRequest($"{type} is not supported");

            var filename = $"{Guid.NewGuid().ToString()}.{type}";

            var result = await _repository.Add(filename, data);
            await _service.NotifyImageCreated(result.Item1);

            return Created(result.Item2, null);
        }

        [HttpGet("{image}")]
        [Produces("application/octet-stream")]
        [ProducesResponseType((int)HttpStatusCode.NotFound)]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        public async Task<IActionResult> DownloadImage(string image)
        {
            var data = await _repository.Get(image);
            if (null == image)
                return NotFound();

            return File(data, "application/octet-stream");            
        }
    }
}