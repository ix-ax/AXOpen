using System;
using AXSharp.Abstractions.Presentation;
using AXSharp.Connector;
using Pocos.AXOpen.Core;
using Pocos.AXOpen.Data;

namespace Pocos
{
    namespace Tests_L1.FragmentData
    {
        public partial class FragmentDataContext : AXOpen.Core.AxoContext, AXSharp.Connector.IPlain
        {
            public FragmentDataContext() : base()
            {
            }

            public AXOpen.Core.AxoObject _rootObject { get; set; } = new AXOpen.Core.AxoObject();
            public Tests_L1.FragmentData.FragmentProcessDataManager DataManager { get; set; } = new Tests_L1.FragmentData.FragmentProcessDataManager();
        }
    }
}