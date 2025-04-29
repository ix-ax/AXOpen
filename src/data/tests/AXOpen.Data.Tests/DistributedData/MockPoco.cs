using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace DistributedDataTest
    {
        public partial class Context : AXOpen.Core.AxoContext, AXSharp.Connector.IPlain
        {
            public Context() : base()
            {
            }

            public DistributedDataTest.HeaderManager HeaderManager_1 { get; set; } = new DistributedDataTest.HeaderManager();
            public DistributedDataTest.HeaderManager HeaderManager_2 { get; set; } = new DistributedDataTest.HeaderManager();
            public DistributedDataTest.StationManager StationManager_1 { get; set; } = new DistributedDataTest.StationManager();
            public DistributedDataTest.StationManager StationManager_2 { get; set; } = new DistributedDataTest.StationManager();
            public DistributedDataTest.FragmentExchange Fragment { get; set; } = new DistributedDataTest.FragmentExchange();
            public DistributedDataTest.AxoProcess AxoProcess { get; set; } = new DistributedDataTest.AxoProcess();
        }

        public partial class AxoProcess : AXOpen.Core.AxoObject, AXSharp.Connector.IPlain
        {
            public AxoProcess() : base()
            {
            }

            public DistributedDataTest.HeaderManager Header { get; set; } = new DistributedDataTest.HeaderManager();
            public DistributedDataTest.StationManager Station_1 { get; set; } = new DistributedDataTest.StationManager();
            public DistributedDataTest.StationManager Station_2 { get; set; } = new DistributedDataTest.StationManager();
        }

        public partial class FragmentExchange : AXOpen.Data.AxoDataFragmentExchange, AXSharp.Connector.IPlain
        {
            public FragmentExchange() : base()
            {
            }

            public DistributedDataTest.HeaderManager Header { get; set; } = new DistributedDataTest.HeaderManager();
            public DistributedDataTest.StationManager Station_1 { get; set; } = new DistributedDataTest.StationManager();
            public DistributedDataTest.StationManager Station_2 { get; set; } = new DistributedDataTest.StationManager();
        }

        public partial class HeaderManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public HeaderManager() : base()
            {
            }

            [AXSharp.Connector.AddedPropertiesAttribute("AttributeName", @"Shared Header")]
            public DistributedDataTest.HeaderData Set { get; set; } = new DistributedDataTest.HeaderData();
        }

        public partial class HeaderData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public HeaderData() : base()
            {
            }

            public string HeaderPartialName { get; set; } = string.Empty;
            public Int16 HeaderIndex { get; set; }
            public Boolean HeaderGlogalPass { get; set; }
        }

        public partial class StationManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public StationManager() : base()
            {
            }

            [AXSharp.Connector.AddedPropertiesAttribute("AttributeName", @"Station")]
            public DistributedDataTest.StationData Set { get; set; } = new DistributedDataTest.StationData();
        }

        public partial class StationData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public StationData() : base()
            {
            }

            public string StationName { get; set; } = string.Empty;
            public Int16 StaionOperation { get; set; }
            public Boolean StationPass { get; set; }
        }
    }
}