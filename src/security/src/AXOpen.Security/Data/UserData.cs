using AXOpen.Base.Data;
using Microsoft.AspNetCore.Authentication;
using System.Collections.ObjectModel;

namespace AxOpen.Security
{
    public class UserData : IBrowsableDataObject
    {
        public dynamic RecordId { get; set; }
        public string DataEntityId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string HashedPassword { get; set; }
        public bool CanUserChangePassword { get; set; }
        public ObservableCollection<string> Roles { get; set; }
        public string RoleHash { get; set; }
        public TimeSpan LogoutTime { get; set; }
        public DateTime Created { get; set; }
        public DateTime Modified { get; set; }
        public List<string> Changes = new List<string>();
        public string SecurityStamp { get; set; }
        public string AuthenticationToken { get; set; }

        public UserData()
        {
            Roles = new ObservableCollection<string>();
        }
        public UserData(User user)
        {
            UserName = user.UserName;
            Email = user.Email;
            HashedPassword = user.PasswordHash;
            CanUserChangePassword = user.CanUserChangePassword;
            Roles = user.Roles == null ? new ObservableCollection<string>() : new ObservableCollection<string>(user.Roles.ToList());
            RoleHash = user.RoleHash;
            SecurityStamp = user.SecurityStamp;
        }
    }
}
