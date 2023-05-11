using AXOpen.Base.Data;
using System.Collections.ObjectModel;

namespace Security
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

        public UserData()
        {
            Roles = new ObservableCollection<string>();
        }
        public UserData(User user)
        {
            UserName = user.UserName;
            Email = user.Email;
            HashedPassword = user.PasswordHash;
            SecurityStamp = user.SecurityStamp;
            CanUserChangePassword = user.CanUserChangePassword;
            Roles = user.Roles == null ? new ObservableCollection<string>() : new ObservableCollection<string>(user.Roles.ToList());
            SecurityStamp = user.SecurityStamp;
        }
        public UserData(string username, string email, string hashedPassword, IEnumerable<string> roles)
        {
            UserName = username;
            Email = email;
            HashedPassword = hashedPassword;
            Roles = new ObservableCollection<string>(roles);
        }
             
        public UserData(string username, string hashedPassword, IEnumerable<string> roles)
        {
            UserName = username;
            HashedPassword = hashedPassword;
            Roles = new ObservableCollection<string>(roles);
        }
    }
}
