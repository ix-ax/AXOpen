using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.FragmentData
    {
        [AXSharp.Connector.SourceFileAttribute(@"src/data/tests/AXOpen.Data.Tests_L1/ax/src/FragmentData/FragmentDataManager.st")]
        public partial class FragmentProcessDataManager : AXOpen.Data.AxoDataFragmentExchange, AXSharp.Connector.IPlain
        {
            public FragmentProcessDataManager() : base()
            {
            }

            public Tests_L1.SharedEntityHeaderManager EntityHeader { get; set; } = new Tests_L1.SharedEntityHeaderManager();
            public Tests_L1.StationDataManager Station { get; set; } = new Tests_L1.StationDataManager();
        }
    }
}