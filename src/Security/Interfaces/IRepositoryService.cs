using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Security
{
    public interface IRepositoryService : IDisposable
    {
        IRepository<UserData> UserRepository { get; }
        RoleGroupManager RoleGroupManager { get; }
    }
}
