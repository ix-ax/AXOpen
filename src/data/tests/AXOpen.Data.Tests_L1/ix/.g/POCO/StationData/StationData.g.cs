using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1
    {
        public partial class StationData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public StationData() : base()
            {
            }

            public UInt64 CounterDelay { get; set; }
        }
    }
}