using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data
{
    public class AxoDataEntityAttributeNotFoundException : Exception
    {
        public AxoDataEntityAttributeNotFoundException()
        {
        }

        public AxoDataEntityAttributeNotFoundException(string message)
            : base(message)
        {
        }
    }
}
