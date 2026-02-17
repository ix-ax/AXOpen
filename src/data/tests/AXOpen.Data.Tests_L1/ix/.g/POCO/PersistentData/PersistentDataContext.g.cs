using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.PersistentData
    {
        public partial class PersistentDataContext : AXOpen.Core.AxoContext, AXSharp.Connector.IPlain
        {
            public PersistentDataContext() : base()
            {
            }

            public AXOpen.Core.AxoObject _rootObject { get; set; } = new AXOpen.Core.AxoObject();
            public AXOpen.Data.AxoDataPersistentExchange DataManager { get; set; } = new AXOpen.Data.AxoDataPersistentExchange();
            public Tests_L1.PersistentData.PersistentRootObject PersistentRootObject { get; set; } = new Tests_L1.PersistentData.PersistentRootObject();
        }
    }
}