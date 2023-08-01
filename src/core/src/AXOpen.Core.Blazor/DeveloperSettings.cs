using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor
{
    public static class DeveloperSettings
    {
        /// <summary>
        /// Using SSL certificate for SignalR connection (default value is false).
        /// </summary>
        /// 
        public static bool BypassSSLCertificate { get; set; } = false;
    }
}
