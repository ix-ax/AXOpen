﻿using System;

namespace Ix.Base.Data
{
    public class DuplicateIdException : Exception
    {
        public DuplicateIdException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class UnableToUpdateRecord : Exception
    {
        public UnableToUpdateRecord(string message, Exception innerException) : base(message, innerException) { }
    }
    public class UnableToLocateRecordId : Exception
    {
        public UnableToLocateRecordId(string message, Exception innerException) : base(message, innerException) { }
    }
}
