namespace BlazorAuthApp.Identity
{
    public static class AuthorizationChecker
    {

        private static bool IsAuthorized(string roles)
        {
            return roles.Split('|')
                        .Where(p => p != string.Empty)
                        .Select(p => p.ToLower())
                        .Intersect((UserAccessor.Instance.Identity as AppIdentity).Roles.Select(role => role.ToLower()))
                        .Any() ? true : false;
        }

        public static bool HasAuthorization(string roles, Action notAuthorizedAction = null)
        {
            notAuthorizedAction = notAuthorizedAction == null ? null : notAuthorizedAction;

            if (!IsAuthorized(roles) && notAuthorizedAction != null)
            {
                try
                {
                    notAuthorizedAction.Invoke();
                }
                catch (Exception)
                {
                    //++ Ignore
                }

            }

            return IsAuthorized(roles);
        }
    }
}
