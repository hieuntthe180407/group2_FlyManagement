using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public interface IFlightService
    {
        List<Flight> GetFlights();
        void InsertFlight(Flight flight);
        void UpdateFlight(Flight flight);
        void DeleteFlight(Flight flight);
        Flight? GetFlightById(int id);
        List<Flight> GetFlightByFlightID(int flightId);
        List<Flight> GetFlightByAirlineID(int airlineId);
        List<Flight> GetFlightByDepartingAirport(int airportId);
        List<Flight> GetFlightByArrivingAirport(int airportId);
    }
}
