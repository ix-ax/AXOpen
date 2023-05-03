namespace BlazorAuthApp.Identity
{
    public interface IExternalAuthorization
    {
        void RequestAuthorization(string token, bool deauthenticateWhenSame);
        void RequestTokenChange(string token);

        string AuthorizationErrorMessage { get; }
        bool WillChangeToken { get; set; }
        event AuthorizationRequestDelegate AuthorizationRequest;
        event AuthorizationTokenChangeRequestDelegate AuthorizationTokenChange;
    }

    public delegate void AuthorizationRequestDelegate(string token, bool deauthenticateWhenSame);
    public delegate void AuthorizationTokenChangeRequestDelegate(string token);
}
