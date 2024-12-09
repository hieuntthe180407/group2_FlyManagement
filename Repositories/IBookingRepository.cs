using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public interface IBookingRepository 
    {
        public List<Booking> getAll();
        public void addBooking(Booking booking);
        public void updateBooking(Booking booking);
        public void removeBooking(Booking booking);
        public Booking? getBookingById(int id);
        public List<Booking> filterByPassengerID(int passengerID);
        public List<Booking> filterByFlightID(int flightID);
        public List<Booking> filterByBookingPlatformID(int bookingPlatformID);
        public List<Booking> filterByBookingTime(string time);
    }
}
