using AXOpen.Base.Data;
using Microsoft.AspNetCore.Identity;

namespace AxOpen.Security.Entities
{
    public class User : IdentityUser<string>, IBrowsableDataObject
    {
        public string Group { get; set; }
        public bool CanUserChangePassword { get; set; }
        public string RoleHash { get; set; }
        public dynamic RecordId { get; set; }
        public string DataEntityId { get; set; }
        public string Created { get; set; }
        public string Modified { get; set; }

        public User(string username, string email, string group, bool canUserChangePassword)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            UserName = username;
            NormalizedUserName = normalizer.NormalizeName(UserName);            
            Email = email;
            NormalizedEmail = normalizer.NormalizeEmail(email);       
            Group = group;
            CanUserChangePassword = canUserChangePassword;
            Id = Guid.NewGuid().ToString();
        }

    }
}
