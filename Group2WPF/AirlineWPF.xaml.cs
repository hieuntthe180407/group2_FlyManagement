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
            if (string.IsNullOrWhiteSpace(txtairlineid.Text) || string.IsNullOrWhiteSpace(txtairlinename.Text) ||
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
                    if (!int.TryParse(txtairlineid.Text, out int id))
                    {
                        MessageBox.Show("Please enter a valid numeric ID", "Invalid Input");
                        return;
                    }

                    var existingAirline = _airlineService.GetAirlinebyId(id);
                    if (existingAirline != null)
                    {
                        MessageBox.Show("Airline with this ID already exists", "Error");
                        return;
                    }

                    var newAirline = new Airline
                    {
                        Id = id,
                        Code = txtairlinecode.Text,
                        Name = txtairlinename.Text,
                        Country = txtairlinecountry.Text
                    };

                    _airlineService.InsertAirline(newAirline);
                    MessageBox.Show("Airline added successfully", "Success");

                    LoadAirlines(); // Reload data after insert
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

    }
}
