using AXOpen.Core.Blazor;

namespace AXOpen.Components.Elements
{
    public partial class AxoAoView : AxoComponentViewBase<AxoAo>
    {
    }

    public class AxoAoStatusView : AxoAoView
    {
        public AxoAoStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoAoCommandView : AxoAoView
    {
        public AxoAoCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoAoSpotView : AxoAoView
    {
        public AxoAoSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
