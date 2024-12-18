﻿using DataAccess;
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
            var result = MessageBox.Show("Are you sure you want to create this airline?", "Confirm create", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                // Lấy danh sách BookingPlatform hiện tại
                List<BookingPlatform> existingPlatforms = _bookingPlatformService.GetAllBookingPlatforms();

                // Tìm ID lớn nhất
                int nextId = existingPlatforms.Count > 0 ? existingPlatforms.Max(bp => bp.Id) + 1 : 1;

                // Tạo đối tượng mới với ID tự động
                BookingPlatform newBookingPlatform = new BookingPlatform
                {
                    Id = nextId,
                    Name = NameTextBox.Text,
                    Url = UrlTextBox.Text
                };

                // Thêm đối tượng vào hệ thống
                _bookingPlatformService.AddBookingPlatform(newBookingPlatform);
                MessageBox.Show("Create successfully");
                LoadData();
                ResetFields();
            }
        }


        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Are you sure you want to Update this airline?", "Confirm update", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
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
                    MessageBox.Show("Update successfully");
                    LoadData();
                    ResetFields();
                }
            }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Are you sure you want to delete this airline?", "Confirm delete", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                if (DataGrid.SelectedItem != null && DataGrid.SelectedItem is BookingPlatform selectedBookingPlatform)
                {
                    _bookingPlatformService.DeleteBookingPlatform(selectedBookingPlatform.Id);
                    MessageBox.Show("Delete successfully");
                    LoadData();
                }
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
        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            Window1 mainWindow = new Window1();
            mainWindow.Show();
            this.Close();
        }
    }
}
