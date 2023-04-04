using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.data
{
    public class MultipleDataEntityAttributeException : Exception
    {

        public MultipleDataEntityAttributeException()
        {
        }

        public MultipleDataEntityAttributeException(string message)
            : base(message)
        {
        }
    }
}
