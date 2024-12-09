using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public interface IAirportRepository
    {

        List<Airport> GetAirport();


        void InsertAirprot(Airport airport);

        void UpdateAirport(Airport airport);
        void DeleteAirport(Airport airport);

        Airport? GetAirportbyId(int id);

        List<Airport> Filltername(string name);
    }
}
