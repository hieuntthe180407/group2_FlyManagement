using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories
{
    public class AccountRepository : IAccountRepository
    {
        private readonly FlightManagementDbContext _context;
        public AccountRepository()
        {
            _context = new FlightManagementDbContext();   
        }
        public AccountMember? GetAccountById(string accountId)
        {
            AccountMember? account = _context.AccountMembers.FirstOrDefault(a => a.MemberId == accountId);
            return account;
        }
    }
}
