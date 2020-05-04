using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Search.Api.Models
{
    public class ContactSearch
    {
        public string Phrase { get; set; }
        public List<string> SearchFields { get; set; }
        public List<string> SelectFields { get; set; }
    }
}
