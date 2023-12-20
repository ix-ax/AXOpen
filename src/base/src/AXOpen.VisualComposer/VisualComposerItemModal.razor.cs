using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItemModal
    {
        [Parameter]
        public VisualComposerItem Origin { get; set; }

        public void Remove()
        {
            Origin.Remove();
        }
    }
}
