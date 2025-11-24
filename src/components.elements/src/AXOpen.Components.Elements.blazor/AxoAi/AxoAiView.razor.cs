using AXOpen.Core.Blazor;

namespace AXOpen.Components.Elements
{
    public partial class AxoAiView : AxoComponentViewBase<AxoAi>
    {
    }

    public class AxoAiStatusView : AxoAiView
    {
        public AxoAiStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoAiCommandView : AxoAiView
    {
        public AxoAiCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoAiSpotView : AxoAiView
    {
        public AxoAiSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
