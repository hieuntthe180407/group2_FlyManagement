using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public class AirportRepository : IAirportRepository
    {
        private readonly FlightManagementDbContext _context;

        public AirportRepository()
        {
            _context = new FlightManagementDbContext();
        }
        public void DeleteAirport(Airport airport)
        {
            _context.Airports.Remove(airport);
            _context.SaveChanges();
        }

        public Airport? GetAirportbyId(int id)
        {
            Airport? airport = _context.Airports.FirstOrDefault(a => a.Id == id);
            return airport;
        }

        public void InsertAirprot(Airport airport)
        {
            _context.Airports.Add(airport);
            _context.SaveChanges();
        }

        public void UpdateAirport(Airport airport)
        {
            foreach (Airport a in _context.Airports)
            {
                if (a.Id == airport.Id)
                {
                    a.Code = airport.Code;
                    a.Name = airport.Name;
                    a.State = airport.State;
                    a.City = airport.City;
                }
            }
            _context.SaveChanges();
        }
        public List<Airport> Filltername(string name)
        {
            return _context.Airports.Where(a => a.Name.ToLower().Contains( name.ToLower())).ToList();
        }

        public List<Airport> GetAirport()
        {
            return _context.Airports.ToList();
        }
    }
}
