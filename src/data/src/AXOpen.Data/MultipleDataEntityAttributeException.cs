using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data
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
