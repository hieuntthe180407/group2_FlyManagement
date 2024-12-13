using DataAccess;
using DocumentFormat.OpenXml.Office2010.Excel;
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
            // Remove related data first (e.g., flights, bookings, etc.)
            var relatedFlights = _context.Flights.Where(f => f.ArrivingAirport == airport.Id || f.DepartingAirport == airport.Id);
            _context.Flights.RemoveRange(relatedFlights);

            var relatedBookings = _context.Bookings.Where(b => b.Flight.ArrivingAirport == airport.Id || b.Flight.DepartingAirport == airport.Id);
            _context.Bookings.RemoveRange(relatedBookings);

            var relatedBaggage = _context.Baggages.Where(b => b.Booking.Flight.ArrivingAirport == airport.Id || b.Booking.Flight.DepartingAirport == airport.Id);
            _context.Baggages.RemoveRange(relatedBaggage);

            // Finally, remove the airport itself
            _context.Airports.Remove(airport);

            // Save changes to the database
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

        public Airport? GetAirportbyCode(string code)
        {
            Airport? airport = _context.Airports.FirstOrDefault(a => a.Code == code);
            return airport;
        }
    }
}
