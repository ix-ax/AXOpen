using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1
    {
        [AXSharp.Connector.SourceFileAttribute(@"StationData/StationData.st")]
        public partial class StationData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public StationData() : base()
            {
            }

            public UInt64 CounterDelay { get; set; }
        }
    }
}