using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1
    {
        [AXSharp.Connector.SourceFileAttribute(@"src/data/tests/AXOpen.Data.Tests_L1/ax/src/SharedEntityHeader/SharedEntityHeader.st")]
        public partial class SharedEntityHeader : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public SharedEntityHeader() : base()
            {
            }

            public Int16 ComesFrom { get; set; }
            public Int16 GoesTo { get; set; }
            public string Name { get; set; } = string.Empty;
        }
    }
}