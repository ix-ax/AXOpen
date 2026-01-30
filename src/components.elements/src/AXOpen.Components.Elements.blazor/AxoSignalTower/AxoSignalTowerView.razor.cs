using AXOpen.Core.Blazor;

namespace AXOpen.Components.Elements
{
    public partial class AxoSignalTowerView : AxoComponentViewBase<AxoSignalTower>
    {
    }

    public class AxoSignalTowerStatusView : AxoSignalTowerView
    {
        public AxoSignalTowerStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoSignalTowerCommandView : AxoSignalTowerView
    {
        public AxoSignalTowerCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoSignalTowerSpotView : AxoSignalTowerView
    {
        public AxoSignalTowerSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
