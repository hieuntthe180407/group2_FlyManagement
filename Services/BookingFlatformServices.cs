using DataAccess;
using Repositories;
using System.Collections.Generic;

namespace Services
{
    public class BookingPlatformService : IBookingPlatformService
    {
        private readonly IBookingPlatformRepository _repository;

        public BookingPlatformService()
        {
            _repository = new BookingPlatformRepository();
        }

        public List<BookingPlatform> GetAllBookingPlatforms()
        {
            return _repository.GetAll();
        }

        public BookingPlatform GetBookingPlatformById(int id)
        {
            return _repository.GetById(id);
        }

        public void AddBookingPlatform(BookingPlatform bookingPlatform)
        {
            _repository.Add(bookingPlatform);
        }

        public void UpdateBookingPlatform(BookingPlatform bookingPlatform)
        {
            _repository.Update(bookingPlatform);
        }

        public void DeleteBookingPlatform(int id)
        {
            _repository.Delete(id);
        }

        public List<BookingPlatform> FilterBookingPlatformsByName(string name)
        {
            return _repository.FilterByName(name);
        }
    }
}
