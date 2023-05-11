using System;
using System.Runtime.Serialization;

namespace Security
{
    public class ExistingTokenException : Exception
    {
        public ExistingTokenException()
        {
        }

        public ExistingTokenException(string message) : base(message)
        {
        }
    }
}
