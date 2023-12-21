using AXOpen.VisualComposer;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoObjectSpotView
    {
        private void SetCurrentObject()
        {
            if (RccContainer is RenderableContentControl vc)
            {
                if (vc.ParentContainer is VisualComposerItem a)
                {
                    a.Parent.UpdateDetails(this.Component);
                }
            }
        }
    }
}
