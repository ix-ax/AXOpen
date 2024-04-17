using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using Newtonsoft.Json.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItemModal
    {
        [CascadingParameter(Name = "Parent")]
        private VisualComposerContainer? _parent { get; set; }

        [Parameter]
        public VisualComposerItemData Origin { get; set; }

        protected override void OnAfterRender(bool firstRender)
        {
            Origin.StateHasChangeModalDelegate += StateHasChanged;
        }

        public void Remove()
        {
            _parent.RemoveChildren(Origin);
        }
    }
}
