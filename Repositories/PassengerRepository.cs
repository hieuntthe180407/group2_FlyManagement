using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
	public class PassengerRepository : IPassengerRepository
	{
		private readonly FlightManagementDbContext _context;
		public PassengerRepository() {
			_context = new FlightManagementDbContext();
		}

		public void Add(Passenger passenger)
		{
			_context.Add(passenger);
			_context.SaveChanges();
		}

		public void Delete(Passenger passenger)
		{
			_context.Passengers.Remove(passenger);
			_context.SaveChanges();
		}

		public List<Passenger> FilterByDOB(DateOnly dob)
		{
			return _context.Passengers.Where(p => p.DateOfBirth == dob).ToList();
		}

		public List<Passenger> FilterByFNameOrLName(string name)
		{
			return _context.Passengers.Where(p => p.FirstName.ToLower().Contains(name.ToLower()) || p.LastName.ToLower().Contains(name.ToLower())).ToList();
		}

		public Passenger? Get(int id)
		{
			Passenger? passenger = _context.Passengers.FirstOrDefault(x => x.Id == id);
			return passenger;
		}

		public List<Passenger> GetAll()
		{
			return _context.Passengers.ToList();
		}

		public void Update(Passenger passenger)
		{
			foreach(Passenger p in _context.Passengers)
			{
				if(p.Id == passenger.Id)
				{
					p.FirstName = passenger.FirstName;
					p.LastName = passenger.LastName;
					p.Email = passenger.Email;
					p.Country = passenger.Country;
					p.DateOfBirth = passenger.DateOfBirth;
					p.Gender = passenger.Gender;
				}
			}
			_context.SaveChanges();
		
		}
	}
}
