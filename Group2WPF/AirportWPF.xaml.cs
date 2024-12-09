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
            if (string.IsNullOrEmpty(txtairportId.Text) || string.IsNullOrEmpty(txtairportCode.Text) ||
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
                if (ValidateData())
                {
                    int id;
                    if (!int.TryParse(txtairportId.Text, out id))
                    {
                        MessageBox.Show("Invalid ID format!", "Validation Error");
                        return;
                    }

                    Airport newAirport = new Airport
                    {
                        Id = id, // Set the id manually
                        Code = txtairportCode.Text,
                        Name = txtairportName.Text,
                        Country = txtairportCountry.Text,
                        State = txtairportState.Text,
                        City = txtairportCity.Text
                    };

                    _airportService.InsertAirport(newAirport);
                    MessageBox.Show("Airport added successfully", "Success");
                    LoadAirport();
                    ResetInput();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error adding airport: " + ex.Message, "Error");
            }
        }

        private void Update_Click(object sender, RoutedEventArgs e)
        {
            try
            {
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
            catch (Exception ex)
            {
                MessageBox.Show("Error updating airport: " + ex.Message, "Error");
            }
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            try
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
    }
}
