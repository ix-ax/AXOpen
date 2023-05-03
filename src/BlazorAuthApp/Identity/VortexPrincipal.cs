using System.Security.Principal;

namespace BlazorAuthApp.Identity
{
    public partial class AppIdentity
    {
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
