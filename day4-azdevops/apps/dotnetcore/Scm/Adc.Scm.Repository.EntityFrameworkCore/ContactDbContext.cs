using Adc.Scm.DomainObjects;
using Microsoft.EntityFrameworkCore;
using System;

namespace Adc.Scm.Repository.EntityFrameworkCore
{
    public class ContactDbContext : DbContext
    {
        public ContactDbContext(DbContextOptions options)
            : base(options)
        {

        }
        public DbSet<Contact> Contacts { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            var contact = builder.Entity<Contact>();
            contact
                .ToTable("contacts")
                .HasKey(c => c.Id)
                .HasName("id");
            contact
                .Property(c => c.Firstname)
                .HasColumnName("fristname")
                .IsUnicode()
                .IsRequired();
            contact
                .Property(c => c.Lastname)
                .HasColumnName("lastname")
                .IsUnicode()
                .IsRequired();
            contact
                .Property(c => c.Email)
                .HasColumnName("email")
                .IsUnicode()
                .IsRequired();
            contact
                .Property(c => c.AvatarLocation)
                .HasColumnName("avatarlocation")
                .IsUnicode();
            contact
                .Property(c => c.Phone)
                .HasColumnName("phone")
                .IsUnicode();
            contact
                .Property(c => c.Mobile)
                .HasColumnName("mobile")
                .IsUnicode();
            contact
                .Property(c => c.Description)
                .HasColumnName("Description")
                .IsUnicode();
            contact
                .Property(c => c.Street)
                .HasColumnName("street")
                .IsUnicode();
            contact
                .Property(c => c.HouseNumber)
                .HasColumnName("housenumber")
                .IsUnicode();
            contact
                .Property(c => c.City)
                .HasColumnName("city")
                .IsUnicode();
            contact
                .Property(c => c.PostalCode)
                .HasColumnName("postalcode")
                .IsUnicode();
            contact
                .Property(c => c.Country)
                .HasColumnName("country")
                .IsUnicode();

            base.OnModelCreating(builder);
        }
    }
}
