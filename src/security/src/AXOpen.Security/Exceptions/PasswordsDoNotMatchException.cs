using System;

namespace AxOpen.Security
{
    public class PasswordsDoNotMatchException : Exception
    {
        public PasswordsDoNotMatchException(string str) : base(str)
        {
            
        }        
    }
}
