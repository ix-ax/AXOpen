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
        }

        public partial class HeaderManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public HeaderManager() : base()
            {
            }

            [AXSharp.Connector.AddedPropertiesAttribute("AttributeName", "Header")]
            public DistributedDataTest.HeaderData Set { get; set; } = new DistributedDataTest.HeaderData();
        }

        public partial class HeaderData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public HeaderData() : base()
            {
            }

            public string ComponentType { get; set; } = string.Empty;
        }

        public partial class StationManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public StationManager() : base()
            {
            }

            [AXSharp.Connector.AddedPropertiesAttribute("AttributeName", "Station")]
            public DistributedDataTest.StationData Set { get; set; } = new DistributedDataTest.StationData();
        }

        public partial class StationData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public StationData() : base()
            {
            }

            public Byte Result { get; set; }
        }
    }
}