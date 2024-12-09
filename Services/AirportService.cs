using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;

namespace Services
{
    public class AirportService : IAirportService
    {
        private readonly IAirportRepository _airportRepository;

        public AirportService()
        {
            _airportRepository = new AirportRepository();
        }

        public void DeleteAirport(Airport airport)
        {
            _airportRepository.DeleteAirport(airport);
        }

        public Airport? GetAirportById(int id)
        {
            return _airportRepository.GetAirportbyId(id);
        }

        public List<Airport> GetAirports()
        {
            return _airportRepository.GetAirport();
        }

        public void InsertAirport(Airport airport)
        {
            _airportRepository.InsertAirprot(airport);
        }

        public void UpdateAirport(Airport airport)
        {
            _airportRepository.UpdateAirport(airport);
        }

        public List<Airport> FillterName(string name)
        {
            return _airportRepository.Filltername(name);
        }
    }
}
