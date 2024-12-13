using ClosedXML.Excel;
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
using ClosedXML.Excel;
using System.Collections.Generic;
using Microsoft.Win32;

namespace Group2WPF
{
    public partial class AirportWPF : Window
    {
        private readonly IAirportService _airportService;

        public AirportWPF()
        {
            InitializeComponent();
            _airportService = new AirportService();
        }
        private void Airport_Loaded(object sender, RoutedEventArgs e)
        {
            LoadAirport();
        }

        private void LoadAirport()
        {
            try
            {
                dgairports.ItemsSource = null;
                dgairports.ItemsSource = _airportService.GetAirports();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Fail to load Airport " + ex.Message, "Fail");
            }
        }

        private void dgAirport_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (dgairports.SelectedItem is Airport selectedAirport)
            {
                txtairportId.Text = selectedAirport.Id.ToString();
                txtairportCode.Text = selectedAirport.Code;
                txtairportName.Text = selectedAirport.Name;
                txtairportCountry.Text = selectedAirport.Country;
                txtairportState.Text = selectedAirport.State;
                txtairportCity.Text = selectedAirport.City;
            }
        }

        private bool ValidateData()
        {
            if ( string.IsNullOrEmpty(txtairportCode.Text) ||
                string.IsNullOrEmpty(txtairportName.Text) || string.IsNullOrEmpty(txtairportCountry.Text) ||
                string.IsNullOrEmpty(txtairportState.Text) || string.IsNullOrEmpty(txtairportCity.Text))
            {
                MessageBox.Show("Please enter all information!", "Validation Error");
                return false;
            }
            return true;
        }

        private void Insert_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = MessageBox.Show("Are you sure you want to create this airline?", "Confirm create", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes) {
                    if (ValidateData())
                    {
                        // Lấy ID lớn nhất hiện tại từ cơ sở dữ liệu
                        var maxId = _airportService.GetAirports().Max(a => a.Id);

                        // Tạo đối tượng Airport mới với ID lớn nhất + 1
                        var newAirport = new Airport
                        {
                            Id = maxId + 1,  // Tự động tăng ID
                            Code = txtairportCode.Text,
                            Name = txtairportName.Text,
                            Country = txtairportCountry.Text,
                            State = txtairportState.Text,
                            City = txtairportCity.Text
                        };

                        // Thêm mới vào cơ sở dữ liệu
                        _airportService.InsertAirport(newAirport);

                        MessageBox.Show("Airport added successfully", "Success");

                        // Tải lại dữ liệu
                        LoadAirport();
                        ResetInput();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error adding airport: " + ex.Message, "Addition Failed");
            }
        }

        private void Update_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = MessageBox.Show("Are you sure you want to Update this airline?", "Confirm Update", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes) {
                    if (ValidateData())
                    {
                        int id = Int32.Parse(txtairportId.Text);
                        Airport existingAirport = _airportService.GetAirportById(id);
                        if (existingAirport == null)
                        {
                            MessageBox.Show("Airport not found", "Error");
                            return;
                        }

                        existingAirport.Code = txtairportCode.Text;
                        existingAirport.Name = txtairportName.Text;
                        existingAirport.Country = txtairportCountry.Text;
                        existingAirport.State = txtairportState.Text;
                        existingAirport.City = txtairportCity.Text;

                        _airportService.UpdateAirport(existingAirport);
                        MessageBox.Show("Airport updated successfully", "Success");

                        LoadAirport();
                        ResetInput();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error updating airport: " + ex.Message, "Error");
            }
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = MessageBox.Show("Are you sure you want to Delete this airline?", "Confirm Delete", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes)
                {
                    int id = Int32.Parse(txtairportId.Text);
                    Airport existingAirport = _airportService.GetAirportById(id);
                    if (existingAirport == null)
                    {
                        MessageBox.Show("Airport not found", "Error");
                        return;
                    }
                    _airportService.DeleteAirport(existingAirport);
                    MessageBox.Show("Airport deleted successfully", "Success");
                    LoadAirport();
                    ResetInput();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error deleting airport: " + ex.Message, "Error");
            }
        }

        private void Reset_Click(object sender, RoutedEventArgs e)
        {
            ResetInput();
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void ResetInput()
        {
            txtairportId.Text = string.Empty;
            txtairportCode.Text = string.Empty;
            txtairportName.Text = string.Empty;
            txtairportCountry.Text = string.Empty;
            txtairportState.Text = string.Empty;
            txtairportCity.Text = string.Empty;
        }

        private void txtFilter_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (txtFilter.Text.Length > 0)
                {
                    string name = txtFilter.Text;
                    dgairports.ItemsSource = null;
                    dgairports.ItemsSource = _airportService.FillterName(name);
                }
                else
                {
                    dgairports.SelectionChanged -= dgAirport_SelectionChanged;
                    LoadAirport();
                    dgairports.SelectionChanged += dgAirport_SelectionChanged;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("You need to reset data: " + ex.Message, "Fail");
            }
        }

        private void ExportButton_Click(object sender, RoutedEventArgs e)
        {
            // Kiểm tra nếu DataGrid có dữ liệu
            if (dgairports.ItemsSource != null)
            {
                // Tạo một workbook mới
                var workbook = new XLWorkbook();
                var worksheet = workbook.Worksheets.Add("Sheet1");

                // Lấy các cột và tạo tiêu đề (header) trong Excel
                for (int i = 0; i < dgairports.Columns.Count; i++)
                {
                    worksheet.Cell(1, i + 1).Value = dgairports.Columns[i].Header.ToString();
                }

                // Lấy dữ liệu từ ItemsSource thay vì Items
                var itemsSource = dgairports.ItemsSource.Cast<object>().ToList();
                for (int rowIndex = 0; rowIndex < itemsSource.Count; rowIndex++)
                {
                    var row = itemsSource[rowIndex];
                    for (int columnIndex = 0; columnIndex < dgairports.Columns.Count; columnIndex++)
                    {
                        // Sử dụng `Binding` để lấy giá trị chính xác
                        var binding = dgairports.Columns[columnIndex].ClipboardContentBinding as Binding;
                        if (binding != null)
                        {
                            var propertyPath = binding.Path.Path;
                            var propertyValue = row.GetType().GetProperty(propertyPath)?.GetValue(row, null);
                            worksheet.Cell(rowIndex + 2, columnIndex + 1).Value = propertyValue?.ToString();
                        }
                    }
                }

                // Lưu workbook vào file
                var saveFileDialog = new Microsoft.Win32.SaveFileDialog
                {
                    Filter = "Excel Files (*.xlsx)|*.xlsx",
                    FileName = "Airport.xlsx"
                };

                if (saveFileDialog.ShowDialog() == true)
                {
                    workbook.SaveAs(saveFileDialog.FileName);
                    MessageBox.Show("Data exported successfully!", "Success");
                }
            }
        }

        private void ImportButton_Click(object sender, RoutedEventArgs e)
        {
            var openFileDialog = new OpenFileDialog
            {
                Filter = "Excel Files (*.xlsx)|*.xlsx",
                Title = "Select an Excel file"
            };

            if (openFileDialog.ShowDialog() == true)
            {
                string filePath = openFileDialog.FileName;

                var airportsList = ReadFromExcel(filePath);

                bool hasErrors = false;
                StringBuilder errorMessages = new StringBuilder();

                foreach (var airport in airportsList)
                {
                    //if (_airportService.GetAirportById(airport.Id) != null)
                    //{
                    //    hasErrors = true;
                    //    errorMessages.AppendLine($"Airport with ID {airport.Id} already exists.");
                    //    continue;
                    //}

                    if (_airportService.GetAirportbyCode(airport.Code) != null)
                    {
                        hasErrors = true;
                        errorMessages.AppendLine($"Airport with ID {airport.Code} already exists.");
                        continue;
                    }

                    if (string.IsNullOrEmpty(airport.Code) || string.IsNullOrEmpty(airport.Name) || string.IsNullOrEmpty(airport.Country) || string.IsNullOrEmpty(airport.State) || string.IsNullOrEmpty(airport.City))
                    {
                        hasErrors = true;
                        errorMessages.AppendLine($"Airport with ID {airport.Id} has invalid data.");
                        continue;
                    }

                    _airportService.InsertAirport(airport);
                }

                if (hasErrors)
                {
                    MessageBox.Show(errorMessages.ToString(), "Errors in the Imported Data");
                }
                else
                {
                    MessageBox.Show("Data imported successfully!", "Success");
                }

                LoadAirport();
            }

        }

        private List<Airport> ReadFromExcel(string filePath)
        {
            List<Airport> airportsList = new List<Airport>();

            using (var workbook = new XLWorkbook(filePath))
            {
                var worksheet = workbook.Worksheets.Worksheet(1);
                var rows = worksheet.RowsUsed();

                foreach (var row in rows.Skip(1))
                {
                    try
                    {
                        int id = row.Cell(1).GetValue<int>();
                        string code = row.Cell(2).GetValue<string>();
                        string name = row.Cell(3).GetValue<string>();
                        string country = row.Cell(4).GetValue<string>();
                        string state = row.Cell(5).GetValue<string>();
                        string city = row.Cell(6).GetValue<string>();

                        if (string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(name) ||
                            string.IsNullOrWhiteSpace(country))

                        {
                            throw new FormatException("Invalid data in row.");
                        }

                        Airport p = new Airport()
                        {
                            Id = id,
                            Code = code,
                            Name = name,
                            Country = country,
                            State = state,
                            City = city,
                        };

                        airportsList.Add(p);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error processing row {row.RowNumber()}: {ex.Message}. Details: {ex.InnerException?.Message}", "Invalid Data Format");
                    }
                }
            }

            return airportsList;
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            MainWindow mainWindow = new MainWindow();
            mainWindow.Show();
            this.Close();
        }
    }
}
