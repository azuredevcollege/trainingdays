using System;

namespace Adc.Scm.Repository.CosmosDb
{
    public class RepositoryOptions
    {
        public string ConnectionString { get; set; }
        public string DatabaseId { get; set; }
        public string ContainerId { get; set; }
        public int Throughput { get; set; }
    }
}
