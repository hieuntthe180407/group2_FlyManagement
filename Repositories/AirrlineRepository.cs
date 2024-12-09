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
            try
            {
                // Step 1: Retrieve all flights involving the airline
                var flights = _context.Flights
                    .Where(f => f.AirlineId == airline.Id)
                    .ToList();

                // Step 2: Retrieve all bookings related to these flights
                var flightIds = flights.Select(f => f.Id).ToList();
                var bookings = _context.Bookings
                    .Where(b => flightIds.Contains((int)b.FlightId))
                    .ToList();

                // Step 3: Delete baggage related to these bookings
                var bookingIds = bookings.Select(b => b.Id).ToList();
                var baggages = _context.Baggages
                    .Where(bg => bookingIds.Contains((int)bg.BookingId))
                    .ToList();
                _context.Baggages.RemoveRange(baggages);

                // Step 4: Delete bookings
                _context.Bookings.RemoveRange(bookings);

                // Step 5: Delete flights
                _context.Flights.RemoveRange(flights);

                // Step 6: Delete the airline
                _context.Airlines.Remove(airline);

                // Commit the changes
                _context.SaveChanges();
            }
            catch (Exception ex)
            {
                // Log the error for debugging purposes
                Console.WriteLine($"Error deleting airline and dependencies: {ex.InnerException?.Message ?? ex.Message}");
                throw;
            }
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
