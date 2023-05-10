using BlazorAuthApp.Identity.Data;
using AXOpen.Base.Data;

namespace BlazorAuthApp.Identity.Services
{
    public interface IRepositoryService : IDisposable
    {
        IRepository<UserData> UserRepository { get; }
        RoleGroupManager RoleGroupManager { get; }
    }
}
