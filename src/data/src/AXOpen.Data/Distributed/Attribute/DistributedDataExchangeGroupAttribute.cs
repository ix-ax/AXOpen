using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data.Distributed
{
    [AttributeUsage(AttributeTargets.Property)]
    public class DistributedDataExchangeGroupAttribute : Attribute
    {
        public DistributedDataExchangeGroupAttribute(params string[] groups)
        {
            ArgumentNullException.ThrowIfNull(groups);
            Groups = groups;
        }

        private IEnumerable<string> Groups { set; get; } = new List<string>();
    }
}