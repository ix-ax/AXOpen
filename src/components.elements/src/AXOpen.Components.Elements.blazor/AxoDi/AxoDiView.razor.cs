using AXOpen.Core.Blazor;

namespace AXOpen.Components.Elements
{
    public partial class AxoDiView : AxoComponentViewBase<AxoDi>
    {
    }

    public class AxoDiStatusView : AxoDiView
    {
        public AxoDiStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoDiCommandView : AxoDiView
    {
        public AxoDiCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoDiSpotView : AxoDiView
    {
        public AxoDiSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
