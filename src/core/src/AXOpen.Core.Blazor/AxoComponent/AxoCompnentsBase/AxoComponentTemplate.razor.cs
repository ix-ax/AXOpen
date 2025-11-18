using AXOpen.Core;
using System;
using System.Collections.Generic;
using System.Net.NetworkInformation;
using System.Text;
using AXOpen.Core.Blazor;

namespace AXOpen.Core
{
    public partial class AxoComponentTemplate : AxoComponentViewBase<AxoComponent> //TODO: Replace AxoComponent with the actual component type
    {
        
    }

    public class AxoComponentTemplateStatusView : AxoComponentTemplate
    {
        public AxoComponentTemplateStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoComponentTemplateCommandView : AxoComponentTemplate
    {
        public AxoComponentTemplateCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoComponentTemplateSpotView : AxoComponentTemplate
    {
        public AxoComponentTemplateSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
