using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector.S71500.WebApi;
using System.Net.Security;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;

namespace axopen_integration_tests_l4
{
    public class TwinConnectorSelector
    {
        public static axopen_integration_tests_l4TwinController Plc { get; }
            = new(ConnectorAdapterBuilder.Build().CreateDummy());
    }

    public static class Entry
    {
        public static axopen_integration_tests_l4TwinController Plc { get; } = TwinConnectorSelector.Plc;
    }
}