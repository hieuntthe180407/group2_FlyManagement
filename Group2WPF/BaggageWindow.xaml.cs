using DataAccess;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Group2WPF
{
    /// <summary>
    /// Interaction logic for BaggageWindow.xaml
    /// </summary>
    public partial class BaggageWindow : Window
    {
        private FlightManagementDbContext _context;
        private Baggage _selectedBaggage;

        private int pageSize = 10; // Số lượng item trên mỗi trang
        private int pageIndex = 0; // Trang hiện tại
        private List<Baggage> baggages; // Danh sách tất cả các baggage

        public BaggageWindow()
        {
            InitializeComponent();
            _context = new FlightManagementDbContext();
            LoadData();
            LoadBookingIds();
        }

        //private void LoadData()
        //{
        //    BaggageDataGrid.ItemsSource = _context.Baggages.ToList();
        //}

        private void LoadData()
        {
            // Lấy danh sách tất cả các baggage
            baggages = _context.Baggages.ToList();

            // Hiển thị dữ liệu cho trang hiện tại
            DisplayCurrentPage();
        }

        private void DisplayCurrentPage()
        {
            // Tính toán index bắt đầu và số lượng phần tử của trang hiện tại
            var startIndex = pageIndex * pageSize;
            var displayedItems = baggages.Skip(startIndex).Take(pageSize).ToList();

            // Đặt ItemsSource cho DataGrid
            BaggageDataGrid.ItemsSource = displayedItems;
        }

        private void FirstPageButton_Click(object sender, RoutedEventArgs e)
        {
            pageIndex = 0;
            DisplayCurrentPage();
        }

        private void PreviousPageButton_Click(object sender, RoutedEventArgs e)
        {
            if (pageIndex > 0)
            {
                pageIndex--;
                DisplayCurrentPage();
            }
        }

        private void NextPageButton_Click(object sender, RoutedEventArgs e)
        {
            var maxPageIndex = Math.Ceiling((double)baggages.Count / pageSize) - 1;
            if (pageIndex < maxPageIndex)
            {
                pageIndex++;
                DisplayCurrentPage();
            }
        }

        private void LastPageButton_Click(object sender, RoutedEventArgs e)
        {
            var maxPageIndex = Math.Ceiling((double)baggages.Count / pageSize) - 1;
            pageIndex = (int)maxPageIndex;
            DisplayCurrentPage();
        }
        private void LoadBookingIds()
        {
            BookingIdComboBox.ItemsSource = _context.Bookings.ToList();
        }

        private void BaggageDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            _selectedBaggage = (Baggage)BaggageDataGrid.SelectedItem;

            if (_selectedBaggage != null)
            {
                IdTextBox.Text = _selectedBaggage.Id.ToString();
                BookingIdComboBox.SelectedValue = _selectedBaggage.BookingId;
                WeightInKgTextBox.Text = _selectedBaggage.WeightInKg.ToString();
            }
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (int.TryParse(IdTextBox.Text, out int id))
            {
                // Check for duplicate ID
                if (_context.Baggages.Any(b => b.Id == id))
                {
                    MessageBox.Show("Duplicate ID. Please enter a unique ID.");
                    return;
                }

                var newBaggage = new Baggage
                {
                    Id = id,
                    BookingId = (int)BookingIdComboBox.SelectedValue,
                    WeightInKg = decimal.Parse(WeightInKgTextBox.Text)
                };

                _context.Baggages.Add(newBaggage);
                _context.SaveChanges();
                LoadData();
                ResetFields();
            }
            else
            {
                MessageBox.Show("Invalid ID. Please enter a valid numeric ID.");
            }
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            if (_selectedBaggage != null)
            {
                int newId = int.Parse(IdTextBox.Text);

                // Check for duplicate ID
                if (_context.Baggages.Any(b => b.Id == newId && b.Id != _selectedBaggage.Id))
                {
                    MessageBox.Show("Duplicate ID. Please enter a unique ID.");
                    return;
                }

                _selectedBaggage.Id = newId;
                _selectedBaggage.BookingId = (int)BookingIdComboBox.SelectedValue;
                _selectedBaggage.WeightInKg = decimal.Parse(WeightInKgTextBox.Text);

                _context.SaveChanges();
                LoadData();
                ResetFields();
            }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (_selectedBaggage != null)
            {
                _context.Baggages.Remove(_selectedBaggage);
                _context.SaveChanges();
                LoadData();
                ResetFields();
            }
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            ResetFields();
        }

        private void ResetFields()
        {
            IdTextBox.Text = string.Empty;
            BookingIdComboBox.SelectedIndex = -1;
            WeightInKgTextBox.Text = string.Empty;
         
        }
        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            //Window1 window1 = new Window1();
            this.Close();
            //window1.ShowDialog();
        }

        private void WeightInKgTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
    }
}
