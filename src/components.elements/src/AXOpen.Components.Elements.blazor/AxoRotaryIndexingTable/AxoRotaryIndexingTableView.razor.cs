using AXOpen.Core.Blazor;

namespace AXOpen.Components.Elements
{
    public partial class AxoRotaryIndexingTableView : AxoComponentViewBase<AxoRotaryIndexingTable>
    {
    }

    public class AxoRotaryIndexingTableStatusView : AxoRotaryIndexingTableView
    {
        public AxoRotaryIndexingTableStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoRotaryIndexingTableCommandView : AxoRotaryIndexingTableView
    {
        public AxoRotaryIndexingTableCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoRotaryIndexingTableSpotView : AxoRotaryIndexingTableView
    {
        public AxoRotaryIndexingTableSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
