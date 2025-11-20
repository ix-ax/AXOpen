using AXOpen.Core.Blazor;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Components.Pneumatics
{
    public partial class AxoCylinderView : AxoComponentViewBase<AxoCylinder>
    {
       
    }

    public class AxoCylinderStatusView : AxoCylinderView
    {
        public AxoCylinderStatusView()
        {
            this.ViewType = eViewType.Status;
        }                
    }

    public class AxoCylinderCommandView : AxoCylinderView
    {
        public AxoCylinderCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoCylinderSpotView : AxoCylinderView
    {
        public AxoCylinderSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
