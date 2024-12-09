using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public class FlightService : IFlightService
    {
        private readonly IFlightRepository iFlightRepository;

        public FlightService()
        {
            iFlightRepository = new FlightRepository();
        }

        public List<Flight> GetFlights() => iFlightRepository.GetFlights();
        
        public void InsertFlight(Flight flight) => iFlightRepository.InsertFlight(flight);

        public void UpdateFlight(Flight flight) => iFlightRepository.UpdateFlight(flight);

        public void DeleteFlight(Flight flight) => iFlightRepository.DeleteFlight(flight);

        public Flight? GetFlightById(int id) => iFlightRepository.GetFlightById(id);

        public List<Flight> GetFlightByFlightID(int flightId) => iFlightRepository.GetFlightByFlightID(flightId);

        public List<Flight> GetFlightByAirlineID(int airlineId) => iFlightRepository.GetFlightByAirlineID(airlineId);

        public List<Flight> GetFlightByDepartingAirport(int airportId) => iFlightRepository.GetFlightByDepartingAirport(airportId);

        public List<Flight> GetFlightByArrivingAirport(int airportId) => iFlightRepository.GetFlightByArrivingAirport(airportId);
    }
}
