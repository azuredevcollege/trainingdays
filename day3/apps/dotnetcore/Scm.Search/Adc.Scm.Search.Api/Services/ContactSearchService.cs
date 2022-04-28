using Adc.Scm.Search.Api.Models;
using Azure;
using Azure.Search.Documents;
using Microsoft.Extensions.Options;
using System;
using System.Threading.Tasks;

namespace Adc.Scm.Search.Api.Services
{
    public class ContactSearchService
    {
        private readonly ContactSearchOptions _options;

        public ContactSearchService(IOptions<ContactSearchOptions> options)
        {
            _options = options.Value;
        }

        public async Task<object> Search(Guid userId, string phrase)
        {
            AzureKeyCredential credential = new AzureKeyCredential(_options.AdminApiKey);
            SearchClient client = new SearchClient(new Uri($"https://{_options.ServiceName}.search.windows.net"), _options.IndexName, credential);

            var result = await client.SearchAsync<dynamic>($"(userid:{userId}) AND ({phrase})", new SearchOptions
            {
                QueryType = Azure.Search.Documents.Models.SearchQueryType.Full
            });

            return result.Value.GetResults();
        }

        public async Task<object> Search(Guid userId, ContactSearch search)
        {
            AzureKeyCredential credential = new AzureKeyCredential(_options.AdminApiKey);
            SearchClient client = new SearchClient(new Uri($"https://{_options.ServiceName}.search.windows.net"), _options.IndexName, credential);

            var so = new SearchOptions
            {
                QueryType = Azure.Search.Documents.Models.SearchQueryType.Full,
            };
            search.SelectFields.ForEach(selField => so.Select.Add(selField));
            search.SearchFields.ForEach(searchField => so.SearchFields.Add(searchField));

            var result = await client.SearchAsync<dynamic>($"(userid:{userId}) AND ({search.Phrase})", so);

            return result.Value.GetResults();

        }
    }
}
