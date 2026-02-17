using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.PersistentData
    {
        public partial class ObjectWithPersistentMember : AXSharp.Connector.IPlain
        {
            public ObjectWithPersistentMember()
            {
            }

            public Int16 NotPersistentVariable { get; set; }
            public Tests_L1.Primitives.InitializedPrimitives InitializedPrimitives { get; set; } = new Tests_L1.Primitives.InitializedPrimitives();
        }
    }
}