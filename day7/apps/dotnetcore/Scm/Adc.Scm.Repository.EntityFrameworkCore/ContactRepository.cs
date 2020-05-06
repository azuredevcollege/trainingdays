using Adc.Scm.DomainObjects;
using Adc.Scm.Repository.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Repository.EntityFrameworkCore
{
    public class ContactRepository : IContactRepository
    {
        private readonly ContactDbContext _context;

        public ContactRepository(ContactDbContext context)
        {
            _context = context;
        }

        public async Task<Contact> Add(Guid userId, Contact contact)
        {
            await _context.Database.EnsureCreatedAsync();

            contact.Id = Guid.NewGuid();
            contact.UserId = userId;
            _context.Contacts.Add(contact);
            await _context.SaveChangesAsync();
            return contact;
        }

        public async Task<Contact> Delete(Guid userId, Guid id)
        {
            await _context.Database.EnsureCreatedAsync();

            var contact = await _context.Contacts.FirstOrDefaultAsync(c => c.Id == id && c.UserId == userId);
            if (null == contact)
                return null;

            _context.Contacts.Remove(contact);
            await _context.SaveChangesAsync();
            return contact;
        }

        public async Task<Contact> Get(Guid userId, Guid id)
        {
            await _context.Database.EnsureCreatedAsync();

            return await _context.Contacts.FirstOrDefaultAsync(c => c.Id == id && c.UserId == userId);
        }

        public async Task<List<Contact>> Get(Guid userId)
        {
            await _context.Database.EnsureCreatedAsync();

            return await _context.Contacts.Where(c => c.UserId == userId).ToListAsync();
        }

        public async Task<Contact> Save(Guid userId, Contact contact)
        {
            contact.UserId = userId;
            await _context.Database.EnsureCreatedAsync();

            _context.Contacts.Update(contact);
            await _context.SaveChangesAsync();
            return contact;
        }
    }
}
