using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public interface IBaggageServices
    {
        IEnumerable<Baggage> GetAllBaggages();
        Baggage GetBaggageById(int id);
        void AddBaggage(Baggage baggage);
        void UpdateBaggage(Baggage baggage);
        void DeleteBaggage(int id);
    }
}