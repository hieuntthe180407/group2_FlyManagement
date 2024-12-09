using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
	public class PassengerService : IPassengerService
	{
		private readonly IPassengerRepository _pasRepo;

		public PassengerService()
		{
			_pasRepo = new PassengerRepository();
		}

		public void Add(Passenger passenger)
		{
			_pasRepo.Add(passenger);
		}

		public void Delete(Passenger passenger)
		{
			_pasRepo?.Delete(passenger);
		}

		public List<Passenger> FilterByDOB(DateOnly dob)
		{
			return _pasRepo.FilterByDOB(dob);
		}

		public List<Passenger> FilterByFNameOrLName(string name)
		{
			return _pasRepo.FilterByFNameOrLName(name);
		}

		public Passenger? Get(int id)
		{
			return _pasRepo.Get(id);
		}

		public List<Passenger> GetAll()
		{
			return _pasRepo.GetAll();
		}

		public void Update(Passenger passenger)
		{
			_pasRepo.Update(passenger);
		}
	}
}
