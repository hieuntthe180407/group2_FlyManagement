using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public interface IBaggageRepository
    {
        IEnumerable<Baggage> GetAll();
        Baggage GetById(int id);
        void Add(Baggage baggage);
        void Update(Baggage baggage);
        void Delete(int id);
    }
}