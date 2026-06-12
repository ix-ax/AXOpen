using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1
    {
        [AXSharp.Connector.SourceFileAttribute(@"src/data/tests/AXOpen.Data.Tests_L1/ax/src/StationData/StationDataManager.st")]
        public partial class StationDataManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public StationDataManager() : base()
            {
            }

            public Tests_L1.StationData Set { get; set; } = new Tests_L1.StationData();
        }
    }
}