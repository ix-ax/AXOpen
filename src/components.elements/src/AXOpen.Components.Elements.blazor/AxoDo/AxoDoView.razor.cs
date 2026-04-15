using AXOpen.Core.Blazor;

namespace AXOpen.Components.Elements
{
    public partial class AxoDoView : AxoComponentViewBase<AxoDo>
    {
    }

    public class AxoDoStatusView : AxoDoView
    {
        public AxoDoStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoDoCommandView : AxoDoView
    {
        public AxoDoCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoDoSpotView : AxoDoView
    {
        public AxoDoSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
