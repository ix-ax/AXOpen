using AXOpen.VisualComposer;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoObjectTinySpotView
    {
        
    }

    public class AxoObjectSpotControlSMView : AxoObjectSpotSMView
    {
        protected override void SetCurrentObject(string presentationType = "Status-Display")
        {
            base.SetCurrentObject("Command-Control"); 
        }
    }

    public class AxoObjectSpotDisplaySMView : AxoObjectSpotSMView
    {
        protected override void SetCurrentObject(string presentationType = "Status-Display")
        {
            base.SetCurrentObject("Status-Display");
        }
    }
}
