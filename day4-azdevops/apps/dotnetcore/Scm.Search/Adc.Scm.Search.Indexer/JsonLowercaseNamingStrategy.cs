using Newtonsoft.Json.Serialization;

namespace Adc.Scm.Search.Indexer
{
    public class JsonLowercaseNamingStrategy : NamingStrategy
    {
        protected override string ResolvePropertyName(string name)
        {
            return name.ToLowerInvariant();
        }
    }
}
