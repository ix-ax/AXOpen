using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

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

        public ExistingTokenException(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected ExistingTokenException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}
