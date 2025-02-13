using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace RepositoryTestProject_L4.DataExchange
    {
        public partial class AxoProcessDataManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public AxoProcessDataManager() : base()
            {
            }

            public AxoProcessData Set { get; set; } = new AxoProcessData();
        }

        public partial class AxoProcessData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public AxoProcessData() : base()
            {
            }

            public string vString { get; set; } = string.Empty;
            public Int16 vInt { get; set; }

            public Boolean vBool
            {
                get; set;
            }

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