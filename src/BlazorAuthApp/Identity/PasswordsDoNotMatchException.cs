namespace BlazorAuthApp.Identity
{
    public class PasswordsDoNotMatchException : Exception
    {
        public PasswordsDoNotMatchException(string str) : base(str)
        {

        }
    }
}
