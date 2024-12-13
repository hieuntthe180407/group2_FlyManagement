using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public interface IAirportService
    {
        List<Airport> GetAirports();
        void InsertAirport(Airport airport);
        void DeleteAirport(Airport airport);
        void UpdateAirport(Airport airport);
        Airport? GetAirportById(int id);
        Airport? GetAirportbyCode(string code);

        List<Airport> FillterName(string name);
    }
}
