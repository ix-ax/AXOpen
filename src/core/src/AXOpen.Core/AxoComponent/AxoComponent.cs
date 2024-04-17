using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public partial class AxoComponent
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
    public class DisplayRoleAttribute : Attribute
    {
        public DisplayRoleAttribute()
        {
        }

        public DisplayRoleAttribute(string roleName)
        {
            RoleName = roleName;
        }

        public string RoleName { get; }
    }
}
