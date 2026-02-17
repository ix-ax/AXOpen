using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.Primitives
    {
        public partial class PrimitivesDataManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public PrimitivesDataManager() : base()
            {
            }

            public Tests_L1.Primitives.PrimitivesDataEntity Set { get; set; } = new Tests_L1.Primitives.PrimitivesDataEntity();
        }
    }
}