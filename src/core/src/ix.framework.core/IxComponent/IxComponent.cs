using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public partial class IxComponent
    {        
     
        
    }

    
    public class ComponentHeaderAttribute : Attribute
    {
        public ComponentHeaderAttribute()
        {
        }
        public ComponentHeaderAttribute(string tabName)
        {
            TabName = tabName;
        }

        public string TabName { get; }
    }

    
    public class ComponentDetailsAttribute : Attribute
    {
        public ComponentDetailsAttribute()
        {
        }

        public ComponentDetailsAttribute(string tabName)
        {
            TabName = tabName;
        }

        public string TabName { get; }
    }
}
