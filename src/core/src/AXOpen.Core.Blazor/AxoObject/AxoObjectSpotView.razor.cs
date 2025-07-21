using AXOpen.VisualComposer;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoObjectSpotView
    {
        
    }

    public class AxoObjectSpotControlView : AxoObjectSpotView
    {
        protected override void SetCurrentObject(string presentationType = "Status-Display")
        {
            base.SetCurrentObject("Command-Control"); 
        }
    }

    public class AxoObjectSpotDiagnosticsView : AxoObjectSpotView
    {
        protected override void SetCurrentObject(string presentationType = "Status-Display")
        {
            base.SetCurrentObject("Diagnostics");
        }
    }
}
