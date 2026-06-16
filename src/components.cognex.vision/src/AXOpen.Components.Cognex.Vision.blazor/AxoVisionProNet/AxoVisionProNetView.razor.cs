using AXOpen.Core.Blazor;

namespace AXOpen.Components.Cognex.Vision
{
    public partial class AxoVisionProNetView : AxoComponentViewBase<AxoVisionProNet>
    {
    }

    public class AxoVisionProNetStatusView : AxoVisionProNetView
    {
        public AxoVisionProNetStatusView()  { this.ViewType = eViewType.Status;  }
    }

    public class AxoVisionProNetCommandView : AxoVisionProNetView
    {
        public AxoVisionProNetCommandView() { this.ViewType = eViewType.Command; }
    }

    public class AxoVisionProNetSpotView : AxoVisionProNetView
    {
        public AxoVisionProNetSpotView()    { this.ViewType = eViewType.Spot;    }
    }
}
