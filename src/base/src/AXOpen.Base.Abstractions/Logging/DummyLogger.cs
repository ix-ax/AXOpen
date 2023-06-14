using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Logging;
using AXSharp.Connector;

namespace AXOpen.Logging
{
    internal class DummyLogger : ILogger
    {
        public string LastMessage { get; private set; }

        public object LastObject { get; private set; }

        public string LastCategory { get; private set; }

        public void Debug(string message, IIdentity identity)
        {
            LastMessage = message;
            LastCategory = "Debug";
        }

        public void Debug(string message, ITwinElement sender, IIdentity identity, object details)
        {
            Debug(message, identity);
            LastObject = sender;
        }

        public void Verbose(string message, IIdentity identity)
        {
            LastMessage = message;
            LastCategory = "Verbose";
        }

        public void Verbose(string message, ITwinElement sender, IIdentity identity, object details)
        {
            Verbose(message, identity);
            LastObject = sender;
        }

        public void Information(string message, IIdentity identity)
        {
            LastMessage = message;
            LastCategory = "Information";
        }

        public void Information(string message, ITwinElement sender, IIdentity identity, object details = null)
        {
            Information(message, identity);
            LastObject = sender;
        }

        public void Warning(string message, IIdentity identity)
        {
            LastMessage = message;
            LastCategory = "Warning";
        }

        public void Warning(string message, ITwinElement sender, IIdentity identity, object details)
        {
            Warning(message, identity);
            LastObject = sender;
        }

        public void Error(string message, IIdentity identity)
        {
            LastMessage = message;
            LastCategory = "Error";
        }

        public void Error(string message, ITwinElement sender, IIdentity identity, object details)
        {
            Error(message, identity);
            LastObject = sender;
        }

        public void Fatal(string message, IIdentity identity)
        {
            LastMessage = message;
            LastCategory = "Fatal";
        }

        public void Fatal(string message, ITwinElement sender, IIdentity identity, object details)
        {
            Fatal(message, identity);
            LastObject = sender;
        }
    }
}
