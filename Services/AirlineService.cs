using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public class AirlineService : IAirlineService
    {
        private readonly IAirlineRepository _airliness;

        public AirlineService()
        {
            _airliness = new AirrlineRepository();
        }
        public void DeleteAirline(Airline airline)
        {
            _airliness.DeleteAirline(airline);
        }

        public Airline? GetAirlinebyId(int id)
        {
            return _airliness.GetAirlinebyId(id);
        }

        public List<Airline> GetAirlines()
        {
            return _airliness.GetAirlines();
        }

        public void InsertAirline(Airline airline)
        {
            _airliness.InsertAirline(airline);
        }

        public void UpdateAirline(Airline airline)
        {
            _airliness.UpdateAirline(airline);
        }
        

        public List<Airline> FillerName(string name)
        {
            return _airliness.FillterName(name);
        }
    }
}
