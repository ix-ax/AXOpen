using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.Primitives
    {
        [AXSharp.Connector.SourceFileAttribute(@"src/data/tests/AXOpen.Data.Tests_L1/ax/src/Primitives/PrimitivesDataManager.st")]
        public partial class PrimitivesDataManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public PrimitivesDataManager() : base()
            {
            }

            public Tests_L1.Primitives.PrimitivesDataEntity Set { get; set; } = new Tests_L1.Primitives.PrimitivesDataEntity();
        }
    }
}