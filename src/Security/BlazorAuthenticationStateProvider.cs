using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using System.Text;
using System.Security.Cryptography;
using AXOpen.Base.Data;
using Microsoft.AspNetCore.Identity;

namespace Security
{
    /// <summary>
    /// Authentication state provider.
    /// </summary>
    public class BlazorAuthenticationStateProvider : AuthenticationStateProvider, IAuthenticationService
    {
        private IRepository<UserData> UserRepository;
        private RoleGroupManager roleGroupManager;

        public BlazorAuthenticationStateProvider(IRepository<UserData> userRepo, RoleGroupManager roleGroupManager)
        {
            this.UserRepository = userRepo;
            this.roleGroupManager = roleGroupManager;
        }

        public override Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            if (UserAccessor.Instance.Identity != null && UserAccessor.Instance.Identity.Name != string.Empty)
            {
                var claims = new List<Claim>();
                claims.Add(new Claim(ClaimTypes.Name, UserAccessor.Instance.Identity.Name));

                foreach (var role in UserAccessor.Instance.Identity.Roles)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role));
                }

                var identity = new ClaimsIdentity(claims, "Auth");

                return Task.FromResult(new AuthenticationState(new ClaimsPrincipal(identity)));
            }
            else
            {
                return Task.FromResult(new AuthenticationState(new ClaimsPrincipal(new ClaimsIdentity())));
            }
        }

        public event OnUserAuthentication OnUserAuthenticateSuccess;
        public event OnUserAuthentication OnUserAuthenticateFailed;
        public event OnUserAuthentication OnDeAuthenticating;
        public event OnUserAuthentication OnDeAuthenticated;

        public OnTimedLogoutRequestDelegate OnTimedLogoutRequest { get; set; }

        private List<UserData> _users
        {
            get
            {
                var allUsers = GetAllUsers();
                if (!allUsers.Any())
                {
                    CreateDefaultUser();
                    return GetAllUsers();
                }
                else return allUsers;

            }
        }

        private List<UserData> GetAllUsers() => UserRepository.GetRecords("*", Convert.ToInt32(UserRepository.Count + 1), 0).ToList();

        private void CreateDefaultUser()
        {
            var user = new User("admin", null, new string[] { "AdminGroup" }, false);
            user.SecurityStamp = Guid.NewGuid().ToString();
            user.PasswordHash = Hasher.CalculateHash("admin", "admin");
            user.RoleHash = Hasher.CalculateHash("AdminGroup", "admin");

            var userEntity = new UserData(user);
            UserRepository.Create(userEntity.UserName, userEntity);
        }

        private readonly System.Timers.Timer deauthenticateTimer = new System.Timers.Timer();
        private void SetUserTimedOutDeAuthentication(TimeSpan deauthRequestTime)
        {
            deauthenticateTimer.AutoReset = true;
            deauthenticateTimer.Enabled = false;
            deauthenticateTimer.Stop();
            if (deauthRequestTime.TotalSeconds > 0)
            {
                deauthenticateTimer.Interval = deauthRequestTime.TotalMilliseconds;
                deauthenticateTimer.Elapsed += ATimer_Elapsed;
                deauthenticateTimer.Enabled = true;
            }
        }

        private void ATimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            if (OnTimedLogoutRequest == null)
            {
                this.DeAuthenticateCurrentUser();
                deauthenticateTimer.Stop();
                return;
            }

            if (OnTimedLogoutRequest != null && OnTimedLogoutRequest())
            {
                this.DeAuthenticateCurrentUser();
                deauthenticateTimer.Stop();
            }
        }

        public IUser AuthenticateUser(string username, string password)
        {
            UserData userData = _users.FirstOrDefault(u => u.UserName.Equals(username)
                 && u.HashedPassword.Equals(Hasher.CalculateHash(password, u.UserName))
                 && true);
            //
            if (userData == null)
            {
                OnUserAuthenticateFailed?.Invoke(username);
                this.DeAuthenticateCurrentUser();
                //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"User '{username}' has failed to authenticate with a password.{{payload}}", new { });
                throw new UnauthorizedAccessException("AccessDeniedCredentials");
            }

            Hasher.VerifyHash(userData.Roles, userData.RoleHash, userData.UserName);

            return AuthenticateUser(userData);
        }

        private User AuthenticateUser(UserData userData)
        {
            var user = new User(userData.UserName, userData.Email, userData.Roles.ToArray(), userData.CanUserChangePassword);

            AppIdentity.AppPrincipal customPrincipal = Thread.CurrentPrincipal as AppIdentity.AppPrincipal;
            if (customPrincipal == null)
                throw new ArgumentException("CustomPrincipalError");

            //Authenticate the user
            string[] roles = new string[] { };
            if (user.Roles.Length > 0 && user.Roles[0] != null)
            {
                roles = roleGroupManager.GetRolesFromGroup(user.Roles[0]).ToArray();
            }

            customPrincipal.Identity = new AppIdentity(user.UserName, user.Email, roles, user.CanUserChangePassword, user.Level);
            UserAccessor.Instance.Identity = customPrincipal.Identity;
            OnUserAuthenticateSuccess?.Invoke(user.UserName);
            SetUserTimedOutDeAuthentication(userData.LogoutTime);
            //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"User '{user.UserName}' has authenticated.{{payload}}", new { UserName = user.UserName, CanChangePassword = user.CanUserChangePassword, Roles = string.Join(",", user.Roles), Id = user.Id });
            return user;
        }

        public void DeAuthenticateCurrentUser()
        {
            AppIdentity.AppPrincipal customPrincipal = Thread.CurrentPrincipal as AppIdentity.AppPrincipal;
            if (customPrincipal != null)
            {
                var userName = customPrincipal.Identity.Name;
                OnDeAuthenticating?.Invoke(userName);
                //UserAccessor.Instance.Identity = null;
                UserAccessor.Instance.Identity = new AppIdentity.AnonymousIdentity();
                //customPrincipal.Identity = new AppIdentity.AnonymousIdentity();
                OnDeAuthenticated?.Invoke(userName);
                //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"User '{userName}' has de-authenticated.{{payload}}", new { UserName = userName });
            }
        }

        public void ChangePassword(string userName, string password, string newPassword1, string newPassword2)
        {
            if (newPassword1 != newPassword2)
                throw new PasswordsDoNotMatchException("PasswordMismatch");

            var authenticated = AuthenticateUser(userName, password);

            if (authenticated.UserName == userName)
            {
                var user = this.UserRepository.Read(userName);
                user.HashedPassword = Hasher.CalculateHash(newPassword1, userName);
                this.UserRepository.Update(userName, user);
                //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"User '{authenticated.UserName}' has changed password.{{payload}}",
                //    new { UserName = authenticated.UserName, CanChangePassword = authenticated.CanUserChangePassword, Roles = string.Join(",", authenticated.Roles) });
            }
        }

        public bool HasAuthorization(string roles, Action notAuthorizedAction = null)
        {
            return AuthorizationChecker.HasAuthorization(roles, notAuthorizedAction);
        }
    }
}
