﻿using System;
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

        public ExistingTokenException(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected ExistingTokenException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}