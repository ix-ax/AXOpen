using System;
using System.Security.Principal;

namespace Security
{
    public partial class AppIdentity : IIdentity
    {
        public AppIdentity(string name, string email, string[] roles, bool canUserChangePassword, string level)
        {
            Name = name;
            Email = email;
            Roles = roles;
            Level = level;           
            CanUserChangePassword = canUserChangePassword;
        }

        public string Name { get; private set; }
        public string Email { get; private set; }
        public string[] Roles { get; private set; }

        public string Level { get; private set; }  

        public bool CanUserChangePassword { get; private set;}

        #region IIdentity Members
        public string AuthenticationType { get { return "Custom authentication"; } }

        public bool IsAuthenticated { get { return !string.IsNullOrEmpty(Name); } }
        #endregion

        public class AnonymousIdentity : AppIdentity
        {
            public AnonymousIdentity()
                : base(string.Empty, string.Empty, new string[] { }, false, string.Empty)
            { }
        }

        public class AppPrincipal : IPrincipal
        {
            private AppIdentity _identity;

            public AppIdentity Identity
            {
                get { return _identity ?? new AnonymousIdentity(); }
                set { _identity = value; }
            }

            #region IPrincipal Members
            IIdentity IPrincipal.Identity
            {
                get { return this.Identity; }
            }

            public bool IsInRole(string role)
            {
                return _identity.Roles.Contains(role);
            }
            #endregion
        }
    }
}
