using AutoMapper;
using Azure;
using Azure.Search.Documents;
using Azure.Search.Documents.Indexes;
using Azure.Search.Documents.Indexes.Models;
using Azure.Search.Documents.Models;
using Microsoft.Extensions.Options;
using System;
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
            AzureKeyCredential credential = new AzureKeyCredential(_options.AdminApiKey);
            SearchClient client = new SearchClient(new Uri($"https://{_options.ServiceName}.search.windows.net"), _options.IndexName, credential);
            SearchIndexClient indexClient = new SearchIndexClient(new Uri($"https://{_options.ServiceName}.search.windows.net"), credential);


            // try to create index once
            if (!_indexExists)
            {
                lock (_syncRoot)
                {
                    if (!_indexExists)
                    {
                        try
                        {
                            var index = indexClient.GetIndex(_options.IndexName).Value;
                        }
                        catch (RequestFailedException)
                        {
                            var definition = new SearchIndex(_options.IndexName)
                            {

                                Fields = new FieldBuilder().Build(typeof(Contact)),//, new DefaultContractResolver() { NamingStrategy = new JsonLowercaseNamingStrategy() })
                            };

                            indexClient.CreateIndex(definition);
                        }
                        
                        _indexExists = true;
                    }
                }
            }

            var action = default(IndexDocumentsAction<Contact>);

            if (msg.IsAddedMessage())
            {
                action = IndexDocumentsAction.Upload(_mapper.Value.Map<Contact>(msg));
            }
            else if (msg.IsChangedMessage())
            {
                action = IndexDocumentsAction.MergeOrUpload(_mapper.Value.Map<Contact>(msg));
            }
            else if (msg.IsDeletedMessage())
            {
                action = IndexDocumentsAction.Delete(_mapper.Value.Map<Contact>(msg));
            }
            else
            {
                throw new InvalidOperationException($"Meesage type {msg.EventType} not supported.");
            }

            try
            {
                IndexDocumentsBatch<Contact> batch = IndexDocumentsBatch.Create(action);
                IndexDocumentsOptions options = new IndexDocumentsOptions { ThrowOnAnyError = true };
                await client.IndexDocumentsAsync(batch,options);
            }
            catch (RequestFailedException)
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
