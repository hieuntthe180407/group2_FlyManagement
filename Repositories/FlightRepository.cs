using DataAccess;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public class FlightRepository : IFlightRepository
    {

        public List<Flight> GetFlights()
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            return myContext.Flights.ToList();
        }
        public void InsertFlight(Flight flight)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            myContext.Flights.Add(flight);
            myContext.SaveChanges();
        }

        public void UpdateFlight(Flight flight)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            myContext.Flights.Update(flight);
            myContext.SaveChanges();
        }
        public void DeleteFlight(Flight flight)
        {
            try
            {
                using (var myContext = new FlightManagementDbContext())
                {
                    // Load the flight along with related entities (Bookings and Baggages)
                    var flightToDelete = myContext.Flights
                        .Include(f => f.Bookings) // Load associated bookings
                        .ThenInclude(b => b.Baggages) // Load associated baggages for each booking
                        .FirstOrDefault(f => f.Id == flight.Id);

                    if (flightToDelete != null)
                    {
                        // Delete all bookings related to this flight
                        if (flightToDelete.Bookings != null && flightToDelete.Bookings.Count > 0)
                        {
                            // Remove baggages associated with the bookings first
                            foreach (var booking in flightToDelete.Bookings)
                            {
                                if (booking.Baggages != null && booking.Baggages.Count > 0)
                                {
                                    myContext.Baggages.RemoveRange(booking.Baggages);
                                }
                            }

                            // Remove bookings after removing baggages
                            myContext.Bookings.RemoveRange(flightToDelete.Bookings);
                        }

                        // Remove the flight itself
                        myContext.Flights.Remove(flightToDelete);

                        // Save changes to the database
                        myContext.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception and inspect the inner exception for more details
                Console.WriteLine("Error deleting flight: " + ex.Message);
                if (ex.InnerException != null)
                {
                    Console.WriteLine("Inner exception: " + ex.InnerException.Message);
                }
                throw;
            }
        }




        public Flight? GetFlightById(int id)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            return myContext.Flights.Find(id);
        }

        public List<Flight> GetFlightByFlightID(int flightId)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            return myContext.Flights.Where(f => f.Id == flightId).ToList();
        }

        public List<Flight> GetFlightByAirlineID(int airlineId)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            return myContext.Flights.Where(f => f.AirlineId == airlineId).ToList();
        }

        public List<Flight> GetFlightByDepartingAirport(int airportId)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            return myContext.Flights.Where(f => f.DepartingAirport == airportId).ToList();
        }

        public List<Flight> GetFlightByArrivingAirport(int airportId)
        {
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            return myContext.Flights.Where(f => f.ArrivingAirport == airportId).ToList();
        }
    }
}
