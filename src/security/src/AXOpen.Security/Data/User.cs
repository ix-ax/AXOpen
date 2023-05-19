using Microsoft.AspNetCore.Identity;

namespace AxOpen.Security
{
    public class User : IdentityUser<string>, IUser
    {
        public string[] Roles { get; set; }
        public bool CanUserChangePassword { get; set; }
        public string Level { get; set; }
        public string RoleHash { get; set; }

        public User(string username, string email, string[] roles, bool canUserChangePassword)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            UserName = username;
            NormalizedUserName = normalizer.NormalizeName(UserName);            
            Email = email;
            NormalizedEmail = normalizer.NormalizeEmail(email);       
            Roles = roles?.ToArray();
            CanUserChangePassword = canUserChangePassword;  
        }

        public User(UserData userData)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            UserName = userData.UserName;
            NormalizedUserName = normalizer.NormalizeName(UserName);
            Email = userData.Email;
            NormalizedEmail = normalizer.NormalizeEmail(Email);
            Roles = userData.Roles.ToArray();
            RoleHash = userData.RoleHash;
            CanUserChangePassword = userData.CanUserChangePassword;
            PasswordHash = userData.HashedPassword;
            SecurityStamp = userData.SecurityStamp;
            Id = userData.DataEntityId;
        }
    }
}
