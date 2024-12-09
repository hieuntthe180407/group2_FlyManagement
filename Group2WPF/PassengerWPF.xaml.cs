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
	/// Interaction logic for PassengerWPF.xaml
	/// </summary>
	public partial class PassengerWPF : Window
	{
		private readonly IPassengerService _passengerService;
		public PassengerWPF()
		{
			InitializeComponent();
			_passengerService = new PassengerService();
		}

		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			LoadPassenger();

		}

		private void LoadPassenger()
		{
			try
			{
				dgPassenger.ItemsSource = null;
				dgPassenger.ItemsSource = _passengerService.GetAll();
			}
			catch(Exception ex)
			{
				MessageBox.Show("Fail to load passenger "+ex.Message, "Fail");
			}
			
		}

		private bool ValidateData()
		{
			if(txtID.Text.Length == 0 || txtFName.Text.Length == 0 ||
				txtLName.Text.Length == 0 || txtGmail.Text.Length == 0 ||
				txtCountry.Text.Length == 0 || dpDOB.Text.Length == 0)
			{
				MessageBox.Show("Let enter your information!");
				return false;
			}
			DateOnly dob = DateOnly.Parse(dpDOB.Text);
			DateOnly today = DateOnly.FromDateTime(DateTime.Now);
			if (dob > today)
			{
				MessageBox.Show("Date of birth is invalid, check your information!");
				return false;
			}
			if(rbMale.IsChecked == false && rbFemale.IsChecked == false) {
				MessageBox.Show("Let select your gender!");
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
					int id = Int32.Parse(txtID.Text);
					string fname = txtFName.Text;
					string lname = txtLName.Text;
					string gmail = txtGmail.Text;
					string country = txtCountry.Text;
					string gender = "";
					DateOnly dob = DateOnly.Parse(dpDOB.Text);
					if (rbFemale.IsChecked == true)
					{
						gender = "Female";
					}
					else
					{
						gender = "Male";
					}
					Passenger? pp = _passengerService.Get(id);
					if(pp != null)
					{
						MessageBox.Show("duplicate");
						return;
					}
					Passenger p = new Passenger()
					{
						Id = id,
						FirstName = fname,
						LastName = lname,
						Email = gmail,
						Country = country,
						Gender = gender,
						DateOfBirth = dob,
					};
					_passengerService.Add(p);
					LoadPassenger();
				}
				else
				{
					return;
				}
			}catch (Exception ex)
			{
				MessageBox.Show("Let check your ID, ID is duplicate", "Fail by duplicate id");
			}
			
			//ResetInput();
		}

		private void Update_Click(object sender, RoutedEventArgs e)
		{
			try
			{
				if (ValidateData())
				{
					int id = Int32.Parse(txtID.Text);
					Passenger? p = _passengerService.Get(id);
					if (p == null)
					{
						MessageBox.Show("Not found passenger", "Fail!");
					}
					else
					{
						string fname = txtFName.Text;
						string lname = txtLName.Text;
						string gmail = txtGmail.Text;
						string country = txtCountry.Text;
						string gender = "";
						DateOnly dob = DateOnly.Parse(dpDOB.Text);
						if (rbFemale.IsChecked == true)
						{
							gender = "Female";
						}
						else
						{
							gender = "Male";
						}
						p = new Passenger()
						{
							Id = id,
							FirstName = fname,
							LastName = lname,
							Email = gmail,
							Country = country,
							Gender = gender,
							DateOfBirth = dob,
						};
						_passengerService.Update(p);
						txtID.IsReadOnly = false;
						ResetInput();
						txtFilterFNameOrLastName.Text = string.Empty;
						dpFilterDOB.Text = string.Empty;
					}
				}

			}
			catch (Exception ex)
			{
				MessageBox.Show("Update fail check again! "+ex.Message, "Fail");
			}
			finally
			{
				dgPassenger.SelectionChanged -= dgPassenger_SelectionChanged;
				LoadPassenger();
				dgPassenger.SelectionChanged += dgPassenger_SelectionChanged;
			}
		}
		private void ResetInput()
		{
			txtID.IsReadOnly = false;
			txtID.Text = string.Empty;
			txtLName.Text = string.Empty;
			txtFName.Text = string.Empty;
			txtCountry.Text = string.Empty;
			txtGmail.Text = string.Empty;
			rbFemale.IsChecked = false;
			rbMale.IsChecked = false;
			dpDOB.Text = string.Empty;
		}
		private void dgPassenger_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			DataGrid? dataGrid = sender as DataGrid;
			if (dataGrid != null)
			{
				DataGridRow? row = dataGrid.ItemContainerGenerator.ContainerFromIndex(dataGrid.SelectedIndex) as DataGridRow;
				DataGridCell? cell = dataGrid.Columns[0].GetCellContent(row).Parent as DataGridCell;
				string Id = ((TextBlock)cell.Content).Text;
				if (!Id.Equals(""))
				{
					Passenger? p = _passengerService.Get(Int32.Parse(Id));
					if (p != null)
					{
						txtID.Text = p.Id.ToString();
						txtLName.Text = p.LastName;
						txtFName.Text = p.FirstName;
						txtCountry.Text = p.Country;
						txtGmail.Text = p.Email;
						dpDOB.Text = p.DateOfBirth.ToString();
						if (p.Gender.Equals("Male"))
						{
							rbMale.IsChecked = true;
						}
						else
						{
							rbFemale.IsChecked = true;
						}
						txtID.IsReadOnly = true;
					}
					
				}
			}
		}

		private void Delete_Click(object sender, RoutedEventArgs e)
		{
			try
			{
				if (ValidateData())
				{
					int id = Int32.Parse(txtID.Text);
					Passenger? p = _passengerService.Get(id);
					if (p == null)
					{
						MessageBox.Show("Not found passenger", "Fail!");
					}
					else
					{
						_passengerService.Delete(p);
						txtID.IsReadOnly = false;
						ResetInput();
					}
				}

			}
			catch (Exception ex)
			{
				MessageBox.Show("Delete fail check again! " + ex.Message, "Fail");
			}
			finally
			{
				dgPassenger.SelectionChanged -= dgPassenger_SelectionChanged;
				LoadPassenger();
				dgPassenger.SelectionChanged += dgPassenger_SelectionChanged;
			}
		}

		private void Close_Click(object sender, RoutedEventArgs e)
		{
            this.Close();
        }

		private void txtFilterFNameOrLastName_TextChanged(object sender, TextChangedEventArgs e)
		{
			try
			{
				
				if (txtFilterFNameOrLastName.Text.Length > 0)
				{
					string fnameLname = txtFilterFNameOrLastName.Text;
					dgPassenger.ItemsSource = null;
					dgPassenger.ItemsSource = _passengerService.FilterByFNameOrLName(fnameLname);

				}
				else
				{
					dgPassenger.SelectionChanged -= dgPassenger_SelectionChanged;
					LoadPassenger();
					dgPassenger.SelectionChanged += dgPassenger_SelectionChanged;
				}
			}catch (Exception ex)
			{
				MessageBox.Show("You need to reset data", "Fail");
			}
		}

		private void dpFilterDOB_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
		{
			try
			{
				if (dpFilterDOB.SelectedDate.HasValue)
				{
					DateOnly dob = DateOnly.Parse(dpFilterDOB.Text);
					dgPassenger.ItemsSource = null;
					dgPassenger.ItemsSource = _passengerService.FilterByDOB(dob);

				}
				else
				{
					dgPassenger.SelectionChanged -= dgPassenger_SelectionChanged;
					LoadPassenger();
					dgPassenger.SelectionChanged += dgPassenger_SelectionChanged;
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show("You need to reset data", "Fail");
			}
		}

		private void Reset_Click(object sender, RoutedEventArgs e)
		{
			ResetInput();
			txtFilterFNameOrLastName.Text = string.Empty;
			dpFilterDOB.Text = string.Empty;
		}
	}
}
