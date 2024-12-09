using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccess;

namespace Repositories
{
    public class BookingRepository : IBookingRepository
    {
        FlightManagementDbContext dbContext = new FlightManagementDbContext();

        public void addBooking(Booking booking)
        {
            dbContext.Bookings.Add(booking);
            dbContext.SaveChanges();
        }

        public List<Booking> getAll()
        {
            return dbContext.Bookings.ToList();
        }

        public Booking? getBookingById(int id)
        {
            return dbContext.Bookings.Find(id);
        }

        public void removeBooking(Booking booking)
        {
            var existingBooking = dbContext.Bookings.Find(booking.Id);
            if (existingBooking != null)
            {
                dbContext.Bookings.Remove(existingBooking);
                dbContext.SaveChanges();
            }
        }

        public void updateBooking(Booking booking)
        {
            var existingBooking = dbContext.Bookings.Find(booking.Id);
            if (existingBooking != null)
            {
                dbContext.Entry(existingBooking).CurrentValues.SetValues(booking);
                dbContext.SaveChanges();
            }
        }
        public List<Booking> filterByPassengerID(int passengerID)
        {
            return dbContext.Bookings.Where(b => b.PassengerId == passengerID).ToList();
        }
        public List<Booking> filterByFlightID(int flightID)
        {
            return dbContext.Bookings.Where(b => b.FlightId == flightID).ToList();
        }
        public List<Booking> filterByBookingPlatformID(int bookingPlatformID)
        {
            return dbContext.Bookings.Where(b => b.BookingPlatformId == bookingPlatformID).ToList();
        }
        public List<Booking> filterByBookingTime(string time)
        {
            return dbContext.Bookings.Where(b => b.BookingTime.ToString().Contains(time)).ToList();
        }
    }
}
