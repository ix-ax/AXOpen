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
        private readonly BlazorRoleManager _roleInAppRepository;
        private bool _disposed;
        public RepositoryService(IRepository<User> userRepository,BlazorRoleManager roleInAppRepository)
        {
            _userRepository = userRepository;
            _roleInAppRepository = roleInAppRepository;
        }
        public IRepository<User> UserRepository
        {
            get
            {
                return _userRepository;
            }
        }

        public BlazorRoleManager RoleInAppRepository
        {
            get
            {
                return _roleInAppRepository;
            }
        }

        public void Dispose()
        {
            _disposed = true;
        }
    }
}
