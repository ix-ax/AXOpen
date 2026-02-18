using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.Distributed
    {
        public partial class DistributedDataContext : AXOpen.Core.AxoContext, AXSharp.Connector.IPlain
        {
            public DistributedDataContext() : base()
            {
            }

            public AXOpen.Core.AxoObject _rootObject { get; set; } = new AXOpen.Core.AxoObject();
            public Tests_L1.SharedEntityHeaderManager HeaderManager_1 { get; set; } = new Tests_L1.SharedEntityHeaderManager();
            public Tests_L1.SharedEntityHeaderManager HeaderManager_2 { get; set; } = new Tests_L1.SharedEntityHeaderManager();
            public Tests_L1.StationDataManager StationManager_1 { get; set; } = new Tests_L1.StationDataManager();
            public Tests_L1.StationDataManager StationManager_2 { get; set; } = new Tests_L1.StationDataManager();
            public Tests_L1.FragmentData.FragmentProcessDataManager Fragment { get; set; } = new Tests_L1.FragmentData.FragmentProcessDataManager();
            public Tests_L1.Distributed.ExchangesWrappedInAxoObject AxoProcess { get; set; } = new Tests_L1.Distributed.ExchangesWrappedInAxoObject();
        }
    }
}