﻿using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public interface IAirlineService
    {
        List<Airline> GetAirlines();

        void InsertAirline(Airline airline);

        void UpdateAirline(Airline airline);
        void DeleteAirline(Airline airline);

        Airline? GetAirlinebyId(int id);
        Airline? GetAirlinebyCode(string code);
        List<Airline> FillerName(string name);
    }
}
