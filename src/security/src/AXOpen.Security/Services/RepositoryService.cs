using AxOpen.Security.Entities;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace AxOpen.Security.Services
{
    public class RepositoryService : IRepositoryService
    {
        private readonly IRepository<User>  _userRepository;
        private readonly RoleGroupManager _roleGroupManager;
        private bool _disposed;
        public RepositoryService(IRepository<User> userRepository, RoleGroupManager roleGroupManager)
        {
            _userRepository = userRepository;
            _roleGroupManager = roleGroupManager;
        }
        public IRepository<User> UserRepository
        {
            get
            {
                return _userRepository;
            }
        }

        public RoleGroupManager RoleGroupManager
        {
            get
            {
                return _roleGroupManager;
            }
        }

        public void Dispose()
        {
            _disposed = true;
        }
    }
}
