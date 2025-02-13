using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace RepositoryTestProject_L4.FragmentDataExchange
    {
        public partial class AxoProcessDataManager : AXOpen.Data.AxoDataFragmentExchange, AXSharp.Connector.IPlain
        {
            public AxoProcessDataManager() : base()
            {
            }

            public SharedDataHeaderManager Header { get; set; } = new SharedDataHeaderManager();
            public StationProcessDataManager St1 { get; set; } = new StationProcessDataManager();
        }

        public partial class SharedDataHeaderManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public SharedDataHeaderManager() : base()
            {
            }

            [AXSharp.Connector.AddedPropertiesAttribute("AttributeName", "Shared Header")]
            public SharedDataHeaderData Set { get; set; } = new SharedDataHeaderData();
        }

        public partial class SharedDataHeaderData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public SharedDataHeaderData() : base()
            {
            }

            public string vString { get; set; } = string.Empty;
            public Int16 vInt { get; set; }
            public Boolean vBool { get; set; }
        }

        public partial class StationProcessDataManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public StationProcessDataManager() : base()
            {
            }

            [AXSharp.Connector.AddedPropertiesAttribute("AttributeName", "Station")]
            public StationData Set { get; set; } = new StationData();
        }

        public partial class StationData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public StationData() : base()
            {
            }

            public string vString { get; set; } = string.Empty;
            public Int16 vInt { get; set; }
            public Boolean vBool { get; set; }
            public NestingData NestObj { get; set; } = new NestingData();
        }

        public partial class NestingData : AXSharp.Connector.IPlain
        {
            public NestingData()
            {
            }

            public string vString { get; set; } = string.Empty;
            public Int16 vInt { get; set; }
            public Boolean vBool { get; set; }
        }
    }
}