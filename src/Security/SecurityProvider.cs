﻿using System;
using System.Collections.Generic;
using System.Text;

namespace Security
{
    public class SecurityProvider : ISecurityProvider
    {
        /// <summary>
        /// Prevent creating instance of <see cref="BlazorSecurity provider"/> from outside this type.
        /// </summary>
        /// <param name="authenticationService">Authentication service.</param>
        private SecurityProvider(IAuthenticationService authenticationService)
        {
            AuthenticationService = authenticationService;
        }

        private static void OnAuthenticationEvent(string username)
        {
            OnAnyAuthenticationEvent?.Invoke(username);
        }
        private static SecurityProvider provider;
        private static volatile object mutex = new object();

        /// <summary>
        /// Gets the authentication service for this application.
        /// </summary>
        public IAuthenticationService AuthenticationService
        {
            get;
        }

        /// <summary>
        /// Raised on any authentication change.
        /// </summary>
        public static event OnUserAuthentication OnAnyAuthenticationEvent;

        /// <summary>
        /// Creates new security provider with a authentication service.
        /// </summary>
        /// <param name="authenticationService">Authentication service.</param>
        /// <returns>Security provider.</returns>
        public static SecurityProvider Create(IAuthenticationService authenticationService)
        {
            if (provider == null)
            {
                lock (mutex)
                {
                    if (provider == null)
                    {
                        provider = new SecurityProvider(authenticationService);
                        provider.AuthenticationService.OnDeAuthenticated += OnAuthenticationEvent;
                        provider.AuthenticationService.OnUserAuthenticateFailed += OnAuthenticationEvent;
                        provider.AuthenticationService.OnUserAuthenticateSuccess += OnAuthenticationEvent;
                    }
                }
            }

            return provider;
        }
    }
}
