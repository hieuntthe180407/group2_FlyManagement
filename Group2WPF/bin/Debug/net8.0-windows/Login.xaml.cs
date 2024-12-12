using DataAccess;
using Repositories;
using Services;
using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace Group2WPF
{
    public partial class Login : Window
    {
        private readonly IAccountService _accountService;

        public Login()
        {
            InitializeComponent();
            _accountService = new AccountService(new AccountRepository());
        }

        private void btn_Close_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }



        private void btn_login_Click(object sender, RoutedEventArgs e)
        {
            string username = txbTenDangNhap.Text;
            string password = txbMatKhau.Password;

            // Kiểm tra _accountService đã được khởi tạo chưa
            if (_accountService != null)
            {
                // Gọi phương thức GetAccountById để lấy thông tin tài khoản
                AccountMember accountMember = _accountService.GetAccountById(username);

                // Kiểm tra accountMember có null không
                if (accountMember != null)
                {
                    // Kiểm tra mật khẩu
                    if (accountMember.MemberPassword == password)
                    {
                        // Kiểm tra role của tài khoản
                        if (accountMember.MemberRole.HasValue && accountMember.MemberRole.Value == 2)
                        {
                            // Đăng nhập thành công
                            //MainWindow mainWindow = new MainWindow();
                            //mainWindow.Show();
                            Window1 window1 = new Window1();
                            window1.Show();
                            this.Close();
                        }
                        else if (accountMember.MemberRole.HasValue && accountMember.MemberRole.Value == 1)
                        {
                            MainWindow mainWindow = new MainWindow();
                            mainWindow.Show();
                            this.Close();
                        }
                        else
                        {
                            // Thông báo khi tài khoản không có quyền truy cập
                            MessageBox.Show("Your account does not have access permission.");
                        }
                    }
                    else
                    {
                        // Thông báo khi sai mật khẩu
                        MessageBox.Show("Incorrect password. Please try again.");
                    }
                }
                else
                {
                    // Thông báo khi không tìm thấy thông tin tài khoản
                    MessageBox.Show("Account not found. Please check your credentials.");
                }
            }
            else
            {
                // Thông báo lỗi khi _accountService chưa được khởi tạo
                MessageBox.Show("Account service is not initialized.");
            }
        }
    }
}