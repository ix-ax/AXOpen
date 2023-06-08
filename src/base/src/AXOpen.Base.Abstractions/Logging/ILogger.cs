using AXSharp.Connector;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Principal;

namespace AXOpen.Logging
{
    public interface ILogger
    {
        void Debug(string message, IIdentity identity);
        void Debug(string message, ITwinElement sender, IIdentity identity, object details = null);
        void Verbose(string message, IIdentity identity);
        void Verbose(string message, ITwinElement sender, IIdentity identity, object details = null);
        void Information(string message, IIdentity identity);
        void Information(string message, ITwinElement sender, IIdentity identity, object details = null);
        void Warning(string message, IIdentity identity);
        void Warning(string message, ITwinElement sender, IIdentity identity, object details = null);
        void Error(string message, IIdentity identity);
        void Error(string message, ITwinElement sender, IIdentity identity, object details = null);
        void Fatal(string message, IIdentity identity);
        void Fatal(string message, ITwinElement sender, IIdentity identity, object details = null);
    }
}