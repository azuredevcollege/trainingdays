using Adc.Scm.DomainObjects;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Adc.Scm.Repository.Interfaces
{
    public interface IContactRepository
    {
        Task<Contact> Add(Guid userId, Contact contact);
        Task<Contact> Save(Guid userId, Contact contact);
        Task<Contact> Delete(Guid userId, Guid id);
        Task<Contact> Get(Guid userId, Guid id);
        Task<List<Contact>> Get(Guid userId);
    }
}
