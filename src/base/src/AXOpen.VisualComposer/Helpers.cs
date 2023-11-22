using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.VisualComposer
{
    public static class Helpers
    {
        public static string ModalIdHelper(this string id)
        {
            return id.Replace('.', '_').Replace(' ', '_').Replace('=', '_').Replace('\'', '_').Replace('"', '_').Replace('[', '_').Replace(']', '_').Replace('<', '_').Replace('>', '_').Replace('{', '_').Replace('}', '_').Replace('(', '_').Replace(')', '_');
        }
    }
}
