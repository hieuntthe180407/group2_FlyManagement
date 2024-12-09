using DataAccess;
using System.Collections.Generic;
using System.Linq;

namespace Repositories
{
    public class BookingPlatformRepository : IBookingPlatformRepository
    {
        private readonly FlightManagementDbContext _context;

        public BookingPlatformRepository()
        {
            _context = new FlightManagementDbContext();
        }

        public List<BookingPlatform> GetAll()
        {
            return _context.BookingPlatforms.ToList();
        }

        public BookingPlatform GetById(int id)
        {
            return _context.BookingPlatforms.Find(id);
        }

        public void Add(BookingPlatform bookingPlatform)
        {
            _context.BookingPlatforms.Add(bookingPlatform);
            _context.SaveChanges();
        }

        public void Update(BookingPlatform bookingPlatform)
        {
            _context.BookingPlatforms.Update(bookingPlatform);
            _context.SaveChanges();
        }

        public void Delete(int id)
        {
            var bookingPlatform = _context.BookingPlatforms.FirstOrDefault(b => b.Id == id);
            if (bookingPlatform != null)
            {
                _context.BookingPlatforms.Remove(bookingPlatform);
                _context.SaveChanges();
            }
        }

        public List<BookingPlatform> FilterByName(string name)
        {
            return _context.BookingPlatforms
                .Where(bp => bp.Name.Contains(name))
                .ToList();
        }
    }
}
