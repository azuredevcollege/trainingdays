using AutoMapper;
using Microsoft.Azure.Search;
using Microsoft.Azure.Search.Models;
using Microsoft.Extensions.Options;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Adc.Scm.Search.Indexer
{
    public class ContactIndexerProcessor
    {
        private readonly ContactIndexerOptions _options;
        private static readonly object _syncRoot = new object();
        private static bool _indexExists = false;
        private static Lazy<IMapper> _mapper = new Lazy<IMapper>(CreateMapper);

        public ContactIndexerProcessor(IOptions<ContactIndexerOptions> options)
        {
            _options = options.Value;
        }

        public async Task Process(ContactMessage msg)
        {
            var client = new SearchServiceClient(_options.ServiceName, new SearchCredentials(_options.AdminApiKey));

            // try to create index once
            if (!_indexExists)
            {
                lock (_syncRoot)
                {
                    if (!_indexExists)
                    {
                        if (!client.Indexes.ExistsAsync(_options.IndexName).Result)
                        {
                            var definition = new Microsoft.Azure.Search.Models.Index()
                            {
                                Name = _options.IndexName,
                                Fields = FieldBuilder.BuildForType<Contact>(new DefaultContractResolver() { NamingStrategy = new JsonLowercaseNamingStrategy() })
                            };

                            client.Indexes.CreateAsync(definition).Wait();
                        }

                        _indexExists = true;
                    }
                }
            }

            var action = default(IndexAction<Contact>);

            if (msg.IsAddedMessage())
            {
                action = IndexAction.Upload(_mapper.Value.Map<Contact>(msg));
            }
            else if (msg.IsChangedMessage())
            {
                action = IndexAction.MergeOrUpload(_mapper.Value.Map<Contact>(msg));
            }
            else if (msg.IsDeletedMessage())
            {
                action = IndexAction.Delete(_mapper.Value.Map<Contact>(msg));
            }
            else
            {                
                throw new InvalidOperationException($"Meesage type {msg.EventType} not supported.");
            }
            
            try
            {
                var indexClient = client.Indexes.GetClient(_options.IndexName);
                indexClient.DeserializationSettings.ContractResolver = new DefaultContractResolver() { NamingStrategy = new JsonLowercaseNamingStrategy() };
                await indexClient.Documents.IndexAsync(IndexBatch.New(new[] { action }));
            }
            catch (IndexBatchException)
            {

            }

            await Task.Delay(0);
        }

        private static IMapper CreateMapper()
        {
            var cfg = new MapperConfiguration(c => 
            {
                c.CreateMap<ContactMessage, Contact>()
                    .ForMember(s => s.Id, m => m.MapFrom(s => s.Id.ToString()))
                    .ForMember(s => s.UserId, m => m.MapFrom(s => s.UserId.ToString()));
            });

            return cfg.CreateMapper();
        }
    }
}
