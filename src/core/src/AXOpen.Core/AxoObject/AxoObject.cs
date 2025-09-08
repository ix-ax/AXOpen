using AXSharp.Connector;
using K4os.Hash.xxHash;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;   

namespace AXOpen.Core
{
    public partial class AxoObject : AXSharp.Connector.Identity.ITwinIdentity
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            parent?.GetConnector()?.IdentityProvider?.AddIdentity(this);
            AxoApplication.Current.SystemDiagnostics.AddDiagnosticsFlag(this._dg_);
            this.Identity.Cyclic = GetIdentity();
        }

        private ulong GetIdentity()
        {
            var bytes = Encoding.UTF8.GetBytes(Symbol ?? string.Empty);
            return XXH64.DigestOf(bytes);
        }
    }
}
