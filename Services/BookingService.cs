using DataAccess;
using Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    public class BookingService : IBookingService
    {
        private readonly IBookingRepository _bookingRepository;
        public BookingService()
        {
            _bookingRepository = new BookingRepository();
        }

        public void addBooking(Booking booking)
        {
            _bookingRepository.addBooking(booking);
        }

        public List<Booking> filterByBookingPlatformID(int bookingPlatformID)
        {
            return _bookingRepository.filterByBookingPlatformID(bookingPlatformID);
        }

        public List<Booking> filterByBookingTime(string time)
        {
            return _bookingRepository.filterByBookingTime(time);
        }

        public List<Booking> filterByFlightID(int flightID)
        {
            return _bookingRepository.filterByFlightID(flightID);
        }

        public List<Booking> filterByPassengerID(int passengerID)
        {
            return _bookingRepository.filterByPassengerID(passengerID);
        }

        public List<Booking> getAll()
        {
            return _bookingRepository.getAll();
        }

        public Booking? getBookingById(int id)
        {
            return _bookingRepository.getBookingById(id);
        }

        public void removeBooking(Booking booking)
        {
            _bookingRepository.removeBooking(booking);
        }

        public void updateBooking(Booking booking)
        {
            _bookingRepository.updateBooking(booking);
        }
    }
}
