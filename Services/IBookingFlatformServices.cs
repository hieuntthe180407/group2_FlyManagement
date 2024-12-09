using DataAccess;
using System.Collections.Generic;

namespace Services
{
    public interface IBookingPlatformService
    {
        List<BookingPlatform> GetAllBookingPlatforms();
        BookingPlatform GetBookingPlatformById(int id);
        void AddBookingPlatform(BookingPlatform bookingPlatform);
        void UpdateBookingPlatform(BookingPlatform bookingPlatform);
        void DeleteBookingPlatform(int id);
        List<BookingPlatform> FilterBookingPlatformsByName(string name);
    }
}
