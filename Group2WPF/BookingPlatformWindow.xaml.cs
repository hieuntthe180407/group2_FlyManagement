using DataAccess;
using Repositories;
using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Group2WPF
{
    /// <summary>
    /// Interaction logic for BookingPlatformWindow.xaml
    /// </summary>
    public partial class BookingPlatformWindow : Window
    {
        private readonly IBookingPlatformService _bookingPlatformService;

        public BookingPlatformWindow()
        {
            InitializeComponent();
            _bookingPlatformService = new BookingPlatformService();
            LoadData();
        }

        private void LoadData()
        {
            List<BookingPlatform> bookingPlatforms = _bookingPlatformService.GetAllBookingPlatforms();
            DataGrid.ItemsSource = bookingPlatforms;
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (int.TryParse(IdTextBox.Text, out int id))
            {
                if (_bookingPlatformService.GetBookingPlatformById(id) != null)
                {
                    MessageBox.Show("Duplicate ID. Please enter a unique ID.");
                    return;
                }

                BookingPlatform newBookingPlatform = new BookingPlatform
                {
                    Id = id,
                    Name = NameTextBox.Text,
                    Url = UrlTextBox.Text
                };

                _bookingPlatformService.AddBookingPlatform(newBookingPlatform);
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
            if (DataGrid.SelectedItem != null && DataGrid.SelectedItem is BookingPlatform selectedBookingPlatform)
            {
                if (selectedBookingPlatform.Id != int.Parse(IdTextBox.Text) && _bookingPlatformService.GetBookingPlatformById(int.Parse(IdTextBox.Text)) != null)
                {
                    MessageBox.Show("Duplicate ID. Please enter a unique ID.");
                    return;
                }

                selectedBookingPlatform.Name = NameTextBox.Text;
                selectedBookingPlatform.Url = UrlTextBox.Text;

                _bookingPlatformService.UpdateBookingPlatform(selectedBookingPlatform);
                LoadData();
                ResetFields();
            }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (DataGrid.SelectedItem != null && DataGrid.SelectedItem is BookingPlatform selectedBookingPlatform)
            {
                _bookingPlatformService.DeleteBookingPlatform(selectedBookingPlatform.Id);
                LoadData();
            }
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            ResetFields();
        }

        private void FilterTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            string filterName = FilterTextBox.Text.Trim();
            List<BookingPlatform> filteredPlatforms = _bookingPlatformService.FilterBookingPlatformsByName(filterName);
            DataGrid.ItemsSource = filteredPlatforms;
        }

        private void ResetFields()
        {
            IdTextBox.Text = "";
            NameTextBox.Text = "";
            UrlTextBox.Text = "";

            DataGrid.SelectedItem = null;
        }

        private void DataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (DataGrid.SelectedItem != null && DataGrid.SelectedItem is BookingPlatform selectedBookingPlatform)
            {
                IdTextBox.Text = selectedBookingPlatform.Id.ToString();
                NameTextBox.Text = selectedBookingPlatform.Name;
                UrlTextBox.Text = selectedBookingPlatform.Url;
            }
        }
        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

    }
}
