using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.Distributed
    {
        public partial class ExchangesWrappedInAxoObject : AXOpen.Core.AxoObject, AXSharp.Connector.IPlain
        {
            public ExchangesWrappedInAxoObject() : base()
            {
            }

            public Tests_L1.SharedEntityHeaderManager Header { get; set; } = new Tests_L1.SharedEntityHeaderManager();
            public Tests_L1.StationDataManager Station_1 { get; set; } = new Tests_L1.StationDataManager();
            public Tests_L1.StationDataManager Station_2 { get; set; } = new Tests_L1.StationDataManager();
        }
    }
}