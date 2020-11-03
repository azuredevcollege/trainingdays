using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Adc.Scm.Api.Services
{
    public class MapperService
    {
        private static readonly Lazy<IMapper> _mapper = new Lazy<IMapper>(CreateMapper);

        private static IMapper CreateMapper()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<DomainObjects.Contact, Models.Contact>();
                cfg.CreateMap<Models.Contact, DomainObjects.Contact>();

                cfg.CreateMap<DomainObjects.Contact, Events.ContactAddedEvent>();
                cfg.CreateMap<DomainObjects.Contact, Events.ContactChangedEvent>();
                cfg.CreateMap<DomainObjects.Contact, Events.ContactDeletedEvent>();
            });

            return config.CreateMapper();
        }

        public TDestination Map<TSource, TDestination>(TSource source)
        {
            return _mapper.Value.Map<TSource, TDestination>(source);
        }

        public List<TDestination> Map<TSource, TDestination>(List<TSource> source)
        {
            var result = new List<TDestination>();

            foreach (var s in source)
                result.Add(_mapper.Value.Map<TDestination>(s));

            return result;
        }
    }
}
