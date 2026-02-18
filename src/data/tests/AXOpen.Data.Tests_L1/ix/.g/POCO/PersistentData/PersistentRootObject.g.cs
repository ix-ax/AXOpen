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
        public partial class PersistentRootObject : AXSharp.Connector.IPlain
        {
            public PersistentRootObject()
            {
            }

            public Boolean NotPersistentVariable { get; set; }
            public Int16 PersistentVariable_1 { get; set; }
            public Int16 PersistentVariable_2 { get; set; }
            public Tests_L1.PersistentData.ObjectWithPersistentMember PropertyWithPersistentMember { get; set; } = new Tests_L1.PersistentData.ObjectWithPersistentMember();
        }
    }
}