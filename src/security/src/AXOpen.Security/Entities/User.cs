using AXOpen.Base.Data;
using Microsoft.AspNetCore.Identity;

namespace AxOpen.Security.Entities
{
    public class User : IdentityUser<string>, IBrowsableDataObject
    {
        public string Group { get; set; }
        public string GroupHash { get; set; }
        public bool CanUserChangePassword { get; set; }
        public dynamic RecordId { get; set; }
        public string _EntityId { get; set; }
        public DateTime Created { get; set; }
        public DateTime Modified { get; set; }
        public bool EnableAutoLogOut { get; set; }
        public uint AutoLogOutTimeOutMinutes { get; set; }
        public string? ExternalAuthId { get; set; }

        public User(string username, string email, string phoneNumber, string group, bool canUserChangePassword, string externalAuthId, bool enableAutoLogOut, uint autoLogOutTimeOutMinutes)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            UserName = username;
            NormalizedUserName = normalizer.NormalizeName(UserName);
            Email = email;
            PhoneNumber = phoneNumber;
            NormalizedEmail = normalizer.NormalizeEmail(email);
            Group = group;
            CanUserChangePassword = canUserChangePassword;
            ExternalAuthId = externalAuthId;
            Id = Guid.NewGuid().ToString();
            Created = DateTime.Now;
            Modified = DateTime.Now;
            EnableAutoLogOut = enableAutoLogOut;
            AutoLogOutTimeOutMinutes = autoLogOutTimeOutMinutes;
        }
    }
}