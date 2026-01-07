using AXOpen.Core.Blazor;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Components.Mitsubishi.Robotics.v_1_x_x
{
    public partial class AxoCr800View : AxoComponentViewBase<AxoCr800>
    {
       
    }

    public class AxoCr800StatusView : AxoCr800View
    {
        public AxoCr800StatusView()
        {
            this.ViewType = eViewType.Status;
        }                
    }

    public class AxoCr800CommandView : AxoCr800View
    {
        public AxoCr800CommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoCr800SpotView : AxoCr800View
    {
        public AxoCr800SpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
