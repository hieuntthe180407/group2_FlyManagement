using DataAccess;
using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace Group2WPF
{
    /// <summary>
    /// Interaction logic for BookingWPF.xaml
    /// </summary>
    public partial class BookingWPF : Window
    {
        private readonly IBookingService _bookingService;
        private readonly IPassengerService _passengerService;
        private readonly IFlightService _flightService;
        private readonly IBookingPlatformService _bookingPlatformService;
        public BookingWPF()
        {
            InitializeComponent();
            _bookingService = new BookingService();
            _passengerService = new PassengerService();
            _flightService = new FlightService();
            _bookingPlatformService = new BookingPlatformService();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            getAllBooking();
            getAllPassenger();
            getAllFlight();
            getAllBookingPlatform();
        }
        private void getAllBooking()
        {
            dgData.ItemsSource = null;
            // Get all bookings
            var allBookings = _bookingService.getAll();

            // Select only the required properties (Id, PassengerId, FlightId)
            var selectedBookings = allBookings.Select(b => new
            {
                b.Id,
                b.PassengerId,
                b.FlightId,
                b.BookingPlatformId,
                b.BookingTime,
            }).ToList();

            // Bind to the DataGrid
            dgData.ItemsSource = selectedBookings;
        }

        private void getAllPassenger()
        {
            cboPassenger.ItemsSource = _passengerService.GetAll();
            cboPassenger.DisplayMemberPath = "FirstName";
            cboPassenger.SelectedValuePath = "Id";
        }
        private void getAllFlight()
        {
            cboFlight.ItemsSource = _flightService.GetFlights();
            cboFlight.DisplayMemberPath = "Id";
            cboFlight.SelectedValuePath = "Id";
        }
        private void getAllBookingPlatform()
        {
            cboBookingPlatform.ItemsSource = _bookingPlatformService.GetAllBookingPlatforms();
            cboBookingPlatform.DisplayMemberPath= "Name";
            cboBookingPlatform.SelectedValuePath = "Id";
        }

        private void dgData_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            DataGrid dataGrid = sender as DataGrid;
            if (dataGrid.ItemsSource != null)
            {
                DataGridRow row = dataGrid.ItemContainerGenerator
                    .ContainerFromIndex(dataGrid.SelectedIndex) as DataGridRow;
                DataGridCell cell = dataGrid.Columns[0].GetCellContent(row).Parent as DataGridCell;

                string bookingId = ((TextBlock)cell.Content).Text;
                if (!bookingId.Equals(""))
                {
                    Booking booking = _bookingService.getBookingById(Int32.Parse(bookingId));
                    txtId.IsReadOnly = true;  
                    txtId.Text = booking.Id.ToString();  
                    cboBookingPlatform.SelectedValue = booking.BookingPlatformId;
                    cboPassenger.SelectedValue = booking.PassengerId;
                    cboFlight.SelectedValue = booking.FlightId;
                    txtBookingTime.Text = booking.BookingTime.ToString();
                }
            }
        }


        private void ButtonClose_Click(object sender, RoutedEventArgs e)
        {
            this.Close();;
        }

        private void ResetInput()
        {
            txtId.Text = "";  // Không cho phép nhập ID, chỉ hiển thị.
            txtId.IsReadOnly = true;  
            cboPassenger.SelectedValue = null;
            cboFlight.SelectedValue = null;
            cboBookingPlatform.SelectedValue = null;
            txtBookingTime.Text = "";
        }


        private void ButtonUpdate_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = MessageBox.Show("Are you sure you want to create this airline?", "Confirm create", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes)
                {
                    if (txtId.Text.Length > 0)
                    {
                        Booking booking = new Booking();
                        booking.Id = Int32.Parse(txtId.Text);
                        booking.PassengerId = Int32.Parse(cboPassenger.SelectedValue.ToString());
                        booking.FlightId = Int32.Parse(cboFlight.SelectedValue.ToString());
                        booking.BookingPlatformId = Int32.Parse(cboBookingPlatform.SelectedValue.ToString());
                        booking.BookingTime = DateTime.Parse(txtBookingTime.Text);
                        _bookingService.updateBooking(booking);
                        MessageBox.Show("Update successfully");
                    }
                }
                else
                {
                    MessageBox.Show("Please select a Booking");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                getAllBooking();
                ResetInput();
            }
        }

        private void ButtonAdd_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = MessageBox.Show("Are you sure you want to create this airline?", "Confirm create", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes)
                {
                    // Lấy ID lớn nhất hiện tại từ cơ sở dữ liệu
                    var maxId = _bookingService.getAll().Max(b => b.Id);

                    // Tạo đối tượng Booking mới với ID lớn nhất + 1
                    Booking booking = new Booking
                    {
                        Id = maxId + 1,  // Tự động tăng ID
                        PassengerId = Int32.Parse(cboPassenger.SelectedValue.ToString()),
                        FlightId = Int32.Parse(cboFlight.SelectedValue.ToString()),
                        BookingPlatformId = Int32.Parse(cboBookingPlatform.SelectedValue.ToString()),
                        BookingTime = DateTime.Parse(txtBookingTime.Text)
                    };

                    _bookingService.addBooking(booking);

                    MessageBox.Show("Booking added successfully", "Success");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                getAllBooking();
                ResetInput();
            }
        }


        private void ButtonDelete_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = MessageBox.Show("Are you sure you want to Delete this airline?", "Confirm delete", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes)
                {

                    if (txtId.Text.Length > 0)
                    {
                        Booking booking = new Booking();
                        booking.Id = Int32.Parse(txtId.Text);
                        booking.PassengerId = Int32.Parse(cboPassenger.SelectedValue.ToString());
                        booking.FlightId = Int32.Parse(cboFlight.SelectedValue.ToString());
                        booking.BookingPlatformId = Int32.Parse(cboBookingPlatform.SelectedValue.ToString());
                        booking.BookingTime = DateTime.Parse(txtBookingTime.Text);
                        _bookingService.removeBooking(booking);
                        MessageBox.Show("Delete successfully");
                    }
                }
                else
                {
                    MessageBox.Show("Please select a Booking");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                getAllBooking();
                ResetInput();
            }
        }

        private void filter_PassengerID(object sender, TextChangedEventArgs e)
        {
            if(filterPID.Text.Length > 0)
            dgData.ItemsSource = _bookingService.filterByPassengerID(Int32.Parse(filterPID.Text));
            else getAllBooking();
        }
        private void filter_FlightID(object sender, TextChangedEventArgs e)
        {
            if(filterFID.Text.Length > 0)
            dgData.ItemsSource = _bookingService.filterByFlightID(Int32.Parse(filterFID.Text));
            else getAllBooking();
        }
        private void filter_BookingPlatformID(object sender, TextChangedEventArgs e)
        {
            if(filterBPID.Text.Length > 0)
            dgData.ItemsSource = _bookingService.filterByBookingPlatformID(Int32.Parse(filterBPID.Text));
            else getAllBooking();
        }

        private void datePicker_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (datePicker.Text.Length > 0)
                dgData.ItemsSource = _bookingService.filterByBookingTime(datePicker.Text);
            else getAllBooking();
        }
        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            Window1 mainWindow = new Window1();
            mainWindow.Show();
            this.Close();
        }
    }
}
