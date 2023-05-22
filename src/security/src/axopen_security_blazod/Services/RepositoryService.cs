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
        private readonly RoleGroupManager _roleInAppRepository;
        private bool _disposed;
        public RepositoryService(IRepository<User> userRepository, RoleGroupManager roleInAppRepository)
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

        public RoleGroupManager RoleInAppRepository
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
