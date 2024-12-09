using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public class BaggageServices : IBaggageServices
    {
        private readonly IBaggageRepository _baggageRepository;

        public BaggageServices(IBaggageRepository baggageRepository)
        {
            _baggageRepository = baggageRepository;
        }

        public IEnumerable<Baggage> GetAllBaggages()
        {
            return _baggageRepository.GetAll();
        }

        public Baggage GetBaggageById(int id)
        {
            return _baggageRepository.GetById(id);
        }

        public void AddBaggage(Baggage baggage)
        {
            _baggageRepository.Add(baggage);
        }

        public void UpdateBaggage(Baggage baggage)
        {
            _baggageRepository.Update(baggage);
        }

        public void DeleteBaggage(int id)
        {
            _baggageRepository.Delete(id);
        }
    }
}