using System;

namespace Security
{
    public class PasswordsDoNotMatchException : Exception
    {
        public PasswordsDoNotMatchException(string str) : base(str)
        {
            
        }        
    }
}
