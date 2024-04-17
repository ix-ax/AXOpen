using AXOpen.Messaging.Static.Blazor;
using AXOpen.VisualComposer;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoObjectDiagnosticsView
    {
        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            
        }

        private void SetCurrentObject()
        {
            if (RccContainer is RenderableContentControl rccContainer)
            {
                if (rccContainer.ParentContainer is VisualComposerItem composerItem)
                {
                    composerItem.Parent.UpdateDetails(this.Component);
                }
            }
        }
    }
}
