using DataAccess;
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
            FlightManagementDbContext myContext = new FlightManagementDbContext();
            myContext.Flights.Remove(flight);
            myContext.SaveChanges();
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
