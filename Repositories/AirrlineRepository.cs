using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public class AirrlineRepository : IAirlineRepository
    {

        private readonly FlightManagementDbContext _context;

        public AirrlineRepository()
        {
            _context = new FlightManagementDbContext();
        }
        public void DeleteAirline(Airline airline)
        {
            _context.Airlines.Remove(airline);
            _context.SaveChanges();
        }

        public Airline? GetAirlinebyId(int id)
        {
            Airline? airline = _context.Airlines.FirstOrDefault(x => x.Id == id);
            return airline;
        }
        public List<Airline> GetAirlines()
        {
            return _context.Airlines.ToList();
        }

        public void InsertAirline(Airline airline)
        {
            _context.Airlines.Add(airline);
            _context.SaveChanges();
        }

        public void UpdateAirline(Airline airline)
        {
            foreach (Airline ae1 in _context.Airlines)
            {
                if (ae1.Id == airline.Id)
                {
                    ae1.Code = airline.Code;
                    ae1.Name = airline.Name;
                    ae1.Country = airline.Country;
                }
            }
            _context.SaveChanges();
        }
     public List<Airline> FillterName(string name)
        {

            return _context.Airlines.Where(a => a.Name.ToLower().Contains( name.ToLower())).ToList();

        }
    }
}
