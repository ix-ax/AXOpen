using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.data
{
    public class DataEntityAttributeNotFoundException : Exception
    {
        public DataEntityAttributeNotFoundException()
        {
        }

        public DataEntityAttributeNotFoundException(string message)
            : base(message)
        {
        }
    }
}
