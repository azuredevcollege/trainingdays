using Adc.Scm.DomainObjects;
using Adc.Scm.Repository.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;

namespace Adc.Scm.Repository.CosmosDb
{
    public class ContactRepository : IContactRepository
    {
        private static object _syncRoot = new object();
        private static bool _containerCreated = false;

        private readonly RepositoryOptions _options;

        public ContactRepository(IOptions<RepositoryOptions> options)
        {
            _options = options.Value;
        }

        public async Task<Contact> Add(Guid userId, Contact contact)
        {
            var client = GetClient();
            contact.Id = Guid.NewGuid();
            contact.UserId = userId;

            var result = await client.GetContainer(_options.DatabaseId, _options.ContainerId)
                .CreateItemAsync(contact, new PartitionKey(contact.UserId.ToString()));

            return result.Resource;

        }

        public async Task<Contact> Delete(Guid userId, Guid id)
        {
            var client = GetClient();
            var container = client.GetContainer(_options.DatabaseId, _options.ContainerId);

            try
            {
                var contact = await container.ReadItemAsync<Contact>(id.ToString(), new PartitionKey(userId.ToString()));
                await container.DeleteItemAsync<Contact>(id.ToString(), new PartitionKey(userId.ToString()));

                return contact;
            }            
            catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }
        }

        public async Task<Contact> Get(Guid userId, Guid id)
        {
            var client = GetClient();
            var container = client.GetContainer(_options.DatabaseId, _options.ContainerId);


            try
            {
                var contact = await container.ReadItemAsync<Contact>(id.ToString(), new PartitionKey(userId.ToString()));
                return contact.Resource;
            }
            catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }
            
        }

        public async Task<List<Contact>> Get(Guid userId)
        {
            var client = GetClient();
            var container = client.GetContainer(_options.DatabaseId, _options.ContainerId);

            var query = new QueryDefinition($"select * from c where c.userId = '{userId.ToString()}'");
            var iterator = container.GetItemQueryIterator<Contact>(
                query,
                requestOptions: new QueryRequestOptions
                {
                    PartitionKey = new PartitionKey(userId.ToString())
                });

            var result = new List<Contact>();

            while (iterator.HasMoreResults)
            {
                var set = await iterator.ReadNextAsync();

                foreach (var item in set)
                    result.Add(item);
            }

            return result;


        }

        public async Task<Contact> Save(Guid userId, Contact contact)
        {
            var client = GetClient();
            var container = client.GetContainer(_options.DatabaseId, _options.ContainerId);

            try
            {
                var result = await container.ReplaceItemAsync(contact, contact.Id.ToString(), new PartitionKey(contact.UserId.ToString()));
                return result.Resource;
            }
            catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }

        }

        private CosmosClient GetClient()
        {
            var options = new CosmosClientOptions
            {
                ConnectionMode = ConnectionMode.Gateway,
                ConsistencyLevel = ConsistencyLevel.Eventual
            };

            options.SerializerOptions = new CosmosSerializationOptions
            {
                PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase
            };

            var client = new CosmosClient(_options.ConnectionString, options);

            if (!_containerCreated)
            {
                lock (_syncRoot)
                {
                    if (!_containerCreated)
                    {
                        var db = client.CreateDatabaseIfNotExistsAsync(_options.DatabaseId).GetAwaiter().GetResult().Database;
                        db.DefineContainer(_options.ContainerId, "/userId")
                            .WithIndexingPolicy()                                
                                .WithAutomaticIndexing(false)
                                .WithIndexingMode(IndexingMode.None)
                                .Attach()
                            .CreateIfNotExistsAsync(_options.Throughput).GetAwaiter().GetResult();

                        _containerCreated = true;
                    }
                }
            }            

            return client;
        }
    }
}
