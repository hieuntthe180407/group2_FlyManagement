using DataAccess;
using LiveCharts;
using LiveCharts.Wpf;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Group2WPF
{
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window
	{
		private FlightManagementDbContext _context;
		public SeriesCollection SeriesCollection { get; set; }
		public string[] Labels { get; set; }
		public Func<double, string> YFormatter { get; set; }
		public MainWindow()
		{
            InitializeComponent();
			_context = new FlightManagementDbContext();
			SeriesCollection = new SeriesCollection
			{
				new LineSeries
				{
					Title = "Today",
					Values = new ChartValues<double> { 
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Now, 0, 0),
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Now, 0, 6), 
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Now, 6, 12), 
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Now, 12, 18),
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Now, 18, 24) }
					//Values = new ChartValues<double> { CountRowsWithinTimeRange(_context.Bookings.ToList(), new DateTime(2022, 10, 11), 0, 0), CountRowsWithinTimeRange(_context.Bookings.ToList(), new DateTime(2022, 10, 11), 0, 6), CountRowsWithinTimeRange(_context.Bookings.ToList(), new DateTime(2022, 10, 11), 6, 12), CountRowsWithinTimeRange(_context.Bookings.ToList(), new DateTime(2022, 10, 11), 12, 18), CountRowsWithinTimeRange(_context.Bookings.ToList(), new DateTime(2022, 10, 11), 18, 24) }
				},
				new LineSeries
				{
					Title = "Yesterday",
					Values = new ChartValues<double> { 
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 0, 0),
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 0, 6), 
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 6, 12),
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 12, 18),
						CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 18, 24) },
					//Values = new ChartValues<double> { CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 0, 0), CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 0, 6), CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 6, 12), CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 12, 18), CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 18, 24) },
					PointGeometry = null
				},
				
			};
			double percen = CalculatePercentageIncrease(CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Now, 0, 24), CountRowsWithinTimeRange(_context.Bookings.ToList(), DateTime.Today.AddDays(-1), 0, 24));
			if(percen >= 0)
			{
				lblpercen.Content = $"Increased {percen}% compared to yesterday";
				lblpercen.Background = new SolidColorBrush(Colors.Green);
			}
			else
			{
				lblpercen.Content = $"Decrease {percen}% compared to yesterday";
				lblpercen.Background = new SolidColorBrush(Colors.Red);
			}
			Labels = new[] { "0h", "6h", "12h", "16h", "24h" };
			YFormatter = value => value.ToString("N0");


			DataContext = this;
		}
		private int CountRowsWithinTimeRange(List<Booking> data, DateTime date, int startHour, int endHour)
		{
			var today = date;

			var startTime = today.Date.AddHours(startHour);
			var endTime = today.Date.AddHours(endHour);
			if (endHour == 24)
			{
				endTime = endTime.AddMilliseconds(-1); // 23:59:59.999 của ngày đó
			}
			return data.Count(x => x.BookingTime >= startTime && x.BookingTime <= endTime);
		}
		private double CalculatePercentageIncrease(int todayCount, int yesterdayCount)
		{
			if (yesterdayCount == 0)
			{
				return todayCount > 0 ? 100.0 : 0; 
			}

			return ((double)(todayCount - yesterdayCount) / yesterdayCount) * 100;
		}

        private void btnAirline_Click(object sender, RoutedEventArgs e)
        {
			AirlineWPF airline = new AirlineWPF();
			airline.ShowDialog();
        }

        private void btnAirport_Click(object sender, RoutedEventArgs e)
        {
			AirportWPF airport = new AirportWPF();
			airport.ShowDialog();
        }

        private void btnLogout_Click(object sender, RoutedEventArgs e)
        {
            var confirm = MessageBox.Show(
            "Are You sure?", "LogOut", MessageBoxButton.YesNo, MessageBoxImage.Warning);
            if (confirm == MessageBoxResult.Yes)
            {
                Login login = new Login();
                this.Close();
                login.ShowDialog();
            }
        }
    }
}