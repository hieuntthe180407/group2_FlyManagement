using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
	public interface IPassengerService
	{
		List<Passenger> GetAll();
		void Add(Passenger passenger);
		Passenger? Get(int  id);
		void Update(Passenger passenger);
		void Delete(Passenger passenger);
		List<Passenger> FilterByFNameOrLName(string name);
		List<Passenger> FilterByDOB(DateOnly dob);
	}
}
