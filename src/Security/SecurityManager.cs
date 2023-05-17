using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Security;

namespace Security
{
    ///<summary>
    ///     Provides management of user access. 
    ///     To setup security manager you need an IRepository where you will store the user data 
    ///     
    /// <code>
    ///     SecurityManager.Create(new DefaultUserDataRepository<UserData>()); //you can use RavenDB,Mongo,Json repository for user data persistence.
    ///     
    ///     //grab the service
    ///     IAuthenticationService authService = SecurityProvider.Get.AuthenticationService;
    ///     
    ///     //create a user
    ///     
    ///     var userName = "Admin";
    ///     var password = "AdminPassword";
    ///     var roles = new string[] { "Administrator" };
    ///     authService.UserRepository.Create(userName, new UserData(userName, password, roles.ToList()));  
    ///     
    ///     //login created user
    ///     authService.AuthenticateUser("Admin", "AdminPassword");
    /// </code>
    ///  
    /// To limit execution of methods for privileged user use <see cref="   "/>
    ///</summary>       
    public class SecurityManager
    {
        private SecurityManager(IAuthenticationService service, IRepository<UserData> repository)
        {
            UserRepository = repository;
            
            Service = service;

            Principal = new AppIdentity.AppPrincipal();
            //SecurityProvider.Create(Service);

            if (System.Threading.Thread.CurrentPrincipal?.GetType() != typeof(AppIdentity.AppPrincipal))
            {
                System.Threading.Thread.CurrentPrincipal = Principal;
                AppDomain.CurrentDomain.SetThreadPrincipal(Principal);
            }
        }

        public static IAuthenticationService Create(IAuthenticationService authenticationService, IRepository<UserData> repository)
        {
            if (_manager == null)
            {
                _manager = new SecurityManager(authenticationService, repository);
            }

            return _manager.Service;
        }

        public AppIdentity.AppPrincipal Principal { get; private set; }

        public IAuthenticationService Service { get; set; }

        private static SecurityManager _manager;
        public static SecurityManager Manager
        {
            get
            {
                if (_manager == null)
                {
                    throw new SecurityManagerNotInitializedException("Security manager was not created.");
                }

                return _manager;
            }
        }

        public IRepository<UserData> UserRepository { get; }
    }

    public class SecurityManagerNotInitializedException : Exception
    {
        /// <summary>Initializes a new instance of the <see cref="SecurityManagerNotInitializedException" /> class.</summary>
        public SecurityManagerNotInitializedException()
        {

        }

        /// <summary>Initializes a new instance of the <see cref="SecurityManagerNotInitializedException" /> class with a specified error message.</summary>
        /// <param name="message">The message that describes the error. </param>
        public SecurityManagerNotInitializedException(string message) : base(message)
        {

        }

        /// <summary>Initializes a new instance of the <see cref="SecurityManagerNotInitializedException" /> class with a specified error message and a reference to the inner exception that is the cause of this exception.</summary>
        /// <param name="message">The error message that explains the reason for the exception. </param>
        /// <param name="innerException">The exception that is the cause of the current exception, or a null reference (<see langword="Nothing" /> in Visual Basic) if no inner exception is specified. </param>
        public SecurityManagerNotInitializedException(string message, Exception innerException) : base(message, innerException)
        {

        }

        /// <summary>Initializes a new instance of the <see cref="SecurityManagerNotInitializedException" /> class with serialized data.</summary>
        /// <param name="info">The <see cref="System.Runtime.Serialization.SerializationInfo" /> that holds the serialized object data about the exception being thrown. </param>
        /// <param name="context">The <see cref="System.Runtime.Serialization.StreamingContext" /> that contains contextual information about the source or destination. </param>
        /// <exception cref="System.ArgumentNullException">The <paramref name="info" /> parameter is <see langword="null" />. </exception>
        /// <exception cref="System.Runtime.Serialization.SerializationException">The class name is <see langword="null" /> or <see cref="System.Exception.HResult" /> is zero (0). </exception>
        [SecuritySafeCritical]
        protected SecurityManagerNotInitializedException(SerializationInfo info, StreamingContext context) : base(info, context)
        {

        }
    }
}
