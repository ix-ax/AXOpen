using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Components.Pneumatics
{
    public partial class AxoCylinderView : RenderableComplexComponentBase<AXOpen.Components.Pneumatics.AxoCylinder>
    {
       
    }

    public class AxoCylinderStatusView : AxoCylinderView
    {
        public AxoCylinderStatusView()
        {
         
        }
    }

    public class AxoCylinderCommandView : AxoCylinderView
    {
        public AxoCylinderCommandView()
        {
            
        }
    }

    public class AxoCylinderSpotView : AxoCylinderView
    {
        public AxoCylinderSpotView()
        {
           
        }
    }
}
