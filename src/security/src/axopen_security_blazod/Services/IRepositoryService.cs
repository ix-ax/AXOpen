using AxOpen.Security.Entities;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AxOpen.Security.Services
{
    public interface IRepositoryService : IDisposable
    {
        IRepository<User> UserRepository { get; }
        RoleGroupManager RoleInAppRepository { get; }

    }
}
