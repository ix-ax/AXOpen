using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector;

namespace AXOpen.Core
{
    public partial class AxoObject : AXSharp.Connector.Identity.ITwinIdentity
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            parent?.GetConnector()?.IdentityProvider?.AddIdentity(this);
        }
    }
}
