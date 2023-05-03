using BlazorAuthApp.Identity.Data;
using Ix.Base.Data;

namespace BlazorAuthApp.Identity.Services
{
    public class RepositoryService : IRepositoryService
    {
        private readonly IRepository<UserData> _userRepository;
        private readonly RoleGroupManager _roleGroupManager;
        private bool _disposed;
        public RepositoryService(IRepository<UserData> userRepository, RoleGroupManager roleGroupManager)
        {
            _userRepository = userRepository;
            _roleGroupManager = roleGroupManager;
        }
        public IRepository<UserData> UserRepository
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
