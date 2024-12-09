using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public class BaggageRepository : IBaggageRepository
    {
        private readonly FlightManagementDbContext _context;

        public BaggageRepository(FlightManagementDbContext context)
        {
            _context = context;
        }

        public IEnumerable<Baggage> GetAll()
        {
            return _context.Baggages.ToList();
        }

        public Baggage GetById(int id)
        {
            return _context.Baggages.Find(id);
        }

        public void Add(Baggage baggage)
        {
            _context.Baggages.Add(baggage);
            _context.SaveChanges();
        }

        public void Update(Baggage baggage)
        {
            _context.Baggages.Update(baggage);
            _context.SaveChanges();
        }

        public void Delete(int id)
        {
            var baggage = _context.Baggages.Find(id);
            if (baggage != null)
            {
                _context.Baggages.Remove(baggage);
                _context.SaveChanges();
            }
        }
    }
}