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
    /// <summary>
    /// Interaction logic for AirlineWPF.xaml
    /// </summary>
    public partial class AirlineWPF : Window
    {
        private readonly IAirlineService _airlineService;
        public AirlineWPF()
        {
            InitializeComponent();
            _airlineService = new AirlineService();
        }

        private void Airline_Loaded(object sender, RoutedEventArgs e)
        {
            LoadAirlines();
        }

        private void LoadAirlines()
        {
            try
            {
                AirlineDataGrid.ItemsSource = null;
                AirlineDataGrid.ItemsSource = _airlineService.GetAirlines();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to load airlines: " + ex.Message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void AirlineDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (AirlineDataGrid.SelectedItem is Airline selectedAirline)
            {
                txtairlineid.Text = selectedAirline.Id.ToString();
                txtairlinecode.Text = selectedAirline.Code;
                txtairlinename.Text = selectedAirline.Name;
                txtairlinecountry.Text = selectedAirline.Country;
            }
        }

        private bool ValidateData()
        {
            if ( string.IsNullOrWhiteSpace(txtairlinename.Text) ||
                string.IsNullOrWhiteSpace(txtairlinecode.Text) || string.IsNullOrWhiteSpace(txtairlinecountry.Text))
            {
                MessageBox.Show("Please enter all information!", "Validation Error");
                return false;
            }
            return true;
        }

        private void UpdateAirlineButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (ValidateData())
                {
                    if (!int.TryParse(txtairlineid.Text, out int id))
                    {
                        MessageBox.Show("Please enter a valid numeric ID", "Invalid Input");
                        return;
                    }

                    var airline = _airlineService.GetAirlinebyId(id);
                    if (airline == null)
                    {
                        MessageBox.Show("Airline not found", "Error");
                        return;
                    }

                    airline.Code = txtairlinecode.Text;
                    airline.Name = txtairlinename.Text;
                    airline.Country = txtairlinecountry.Text;

                    _airlineService.UpdateAirline(airline);
                    MessageBox.Show("Airline updated successfully", "Success");

                    LoadAirlines(); // Reload data after update
                    ResetInput();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Update failed: " + ex.Message, "Failure");
            }
        }

        private void AddAirlineButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (ValidateData())
                {
                    
                    var maxId = _airlineService.GetAirlines().Max(a => a.Id);

                    
                    var newAirline = new Airline
                    {
                        Id = maxId + 1, 
                        Code = txtairlinecode.Text,
                        Name = txtairlinename.Text,
                        Country = txtairlinecountry.Text
                    };

                   
                    _airlineService.InsertAirline(newAirline);

                    MessageBox.Show("Airline added successfully", "Success");

                    // Tải lại dữ liệu
                    LoadAirlines();
                    ResetInput();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error adding airline: " + ex.Message, "Addition Failed");
            }
        }


        private void DeleteAirlineButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (!int.TryParse(txtairlineid.Text, out int id))
                {
                    MessageBox.Show("Please enter a valid numeric ID", "Invalid Input");
                    return;
                }

                var existingAirline = _airlineService.GetAirlinebyId(id);
                if (existingAirline == null)
                {
                    MessageBox.Show("Airline not found", "Error");
                    return;
                }

                _airlineService.DeleteAirline(existingAirline);
                MessageBox.Show("Airline deleted successfully", "Success");

                LoadAirlines(); // Reload data after delete
                ResetInput();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error deleting airline: " + ex.Message, "Deletion Failed");
            }
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            ResetInput();
        }

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
        private void ResetInput()
        {
            txtairlineid.Text = string.Empty;
            txtairlinecode.Text = string.Empty;
            txtairlinename.Text = string.Empty;
            txtairlinecountry.Text = string.Empty;
        }


        private void txtFilterName_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (txtFilterName.Text.Length > 0)
                {
                    string filterText = txtFilterName.Text.Trim();
                    AirlineDataGrid.ItemsSource = null;
                   

                    // Call the service to filter airlines by name
                    AirlineDataGrid.ItemsSource = _airlineService.FillerName(filterText);
                }
                else
                {
                    AirlineDataGrid.SelectionChanged -= AirlineDataGrid_SelectionChanged;
                    // If the filter text is empty, load all airlines
                    LoadAirlines();
                    AirlineDataGrid.SelectionChanged += AirlineDataGrid_SelectionChanged;

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to filter airlines: " + ex.Message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ExportButton_Click(object sender, RoutedEventArgs e)
        {
            // Kiểm tra nếu DataGrid có dữ liệu
            if (AirlineDataGrid.ItemsSource != null)
            {
                // Tạo một workbook mới
                var workbook = new XLWorkbook();
                var worksheet = workbook.Worksheets.Add("Sheet1");

                // Lấy các cột và tạo tiêu đề (header) trong Excel
                for (int i = 0; i < AirlineDataGrid.Columns.Count; i++)
                {
                    worksheet.Cell(1, i + 1).Value = AirlineDataGrid.Columns[i].Header.ToString();
                }

                // Lấy dữ liệu từ ItemsSource thay vì Items
                var itemsSource = AirlineDataGrid.ItemsSource.Cast<object>().ToList();
                for (int rowIndex = 0; rowIndex < itemsSource.Count; rowIndex++)
                {
                    var row = itemsSource[rowIndex];
                    for (int columnIndex = 0; columnIndex < AirlineDataGrid.Columns.Count; columnIndex++)
                    {
                        // Sử dụng `Binding` để lấy giá trị chính xác
                        var binding = AirlineDataGrid.Columns[columnIndex].ClipboardContentBinding as Binding;
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
                    FileName = "AirlineExport.xlsx"
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

                var airlinesList = ReadPassengersFromExcel(filePath);

                bool hasErrors = false;
                StringBuilder errorMessages = new StringBuilder();

                foreach (var airline in airlinesList)
                {
                    if (_airlineService.GetAirlinebyId(airline.Id) != null)
                    {
                        hasErrors = true;
                        errorMessages.AppendLine($"Airline with ID {airline.Id} already exists.");
                        continue;
                    }

                    if (string.IsNullOrEmpty(airline.Code) || string.IsNullOrEmpty(airline.Name) || string.IsNullOrEmpty(airline.Country))
                    {
                        hasErrors = true;
                        errorMessages.AppendLine($"Airline with ID {airline.Id} has invalid data.");
                        continue;
                    }

                    _airlineService.InsertAirline(airline);
                }

                if (hasErrors)
                {
                    MessageBox.Show(errorMessages.ToString(), "Errors in the Imported Data");
                }
                else
                {
                    MessageBox.Show("Data imported successfully!", "Success");
                }

                LoadAirlines();
            }

        }

        private List<Airline> ReadPassengersFromExcel(string filePath)
        {
            List<Airline> airlinesList = new List<Airline>();

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

                        if (string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(name) ||
                            string.IsNullOrWhiteSpace(country))

                        {
                            throw new FormatException("Invalid data in row.");
                        }

                        Airline p = new Airline()
                        {
                            Id = id,
                            Code = code,
                            Name = name,
                            Country = country,
                        };

                        airlinesList.Add(p);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error processing row {row.RowNumber()}: {ex.Message}. Details: {ex.InnerException?.Message}", "Invalid Data Format");
                    }
                }
            }

            return airlinesList;
        }
    }
}
