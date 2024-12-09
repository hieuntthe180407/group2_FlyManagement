using System;
using System.Collections.Generic;

namespace DataAccess;

public partial class Passenger
{
    public int Id { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public DateOnly? DateOfBirth { get; set; }

    public string? Country { get; set; }

    public string? Email { get; set; }

    public string? Gender { get; set; }

    public virtual ICollection<Booking> Bookings { get; set; } = new List<Booking>();
}
