using System;

namespace Security
{
    public interface ISecurityProvider
    {
        /// <summary>
        /// Gets the authentication service for this application.
        /// </summary>
        IAuthenticationService AuthenticationService { get; }
    }
}
