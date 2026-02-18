using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1
    {
        public partial class SharedEntityHeaderManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public SharedEntityHeaderManager() : base()
            {
            }

            public Tests_L1.SharedEntityHeader Set { get; set; } = new Tests_L1.SharedEntityHeader();
        }
    }
}