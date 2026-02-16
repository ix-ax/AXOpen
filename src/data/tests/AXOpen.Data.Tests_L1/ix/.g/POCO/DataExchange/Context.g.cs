using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.DataExchange
    {
        public partial class DataExchangeContext : AXOpen.Core.AxoContext, AXSharp.Connector.IPlain
        {
            public DataExchangeContext() : base()
            {
            }

            public AXOpen.Core.AxoObject _rootObject { get; set; } = new AXOpen.Core.AxoObject();
            public Tests_L1.SharedEntityHeaderManager SharedHeaderManager { get; set; } = new Tests_L1.SharedEntityHeaderManager();
        }
    }
}