using DataAccess;
using System.Collections.Generic;

namespace Repositories
{
    public interface IBookingPlatformRepository
    {
        List<BookingPlatform> GetAll();
        BookingPlatform GetById(int id);
        void Add(BookingPlatform bookingPlatform);
        void Update(BookingPlatform bookingPlatform);
        void Delete(int id);
        List<BookingPlatform> FilterByName(string name);
    }
}
