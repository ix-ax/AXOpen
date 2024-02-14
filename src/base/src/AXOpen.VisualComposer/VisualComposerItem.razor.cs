using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;
using System.ComponentModel;
using AXSharp.Connector.Localizations;
using System.Xml.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItem
    {

        [CascadingParameter(Name = "Parent")]
        public VisualComposerContainer? Parent { get; set; }

        [CascadingParameter(Name = "BackgroundId")]
        private Guid _backgroundId { get; set; }

        [Parameter]
        public VisualComposerItemData? Origin { get; set; }

        private IJSRuntime _js;
        [Inject]
        protected IJSRuntime js
        {
            get => _js;
            set => _js = value;
        }

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                await DragElement();

                Parent.ReDragElementDelegate += async () =>
                {
                    await DragElement();
                };

                Origin.DragElementDelegate += async () =>
                {
                    await DragElement();
                };
            }
        }

        public async Task DragElement()
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerItem.razor.js");
            await jsObject.InvokeVoidAsync("dragElement", Origin.Id.Replace('.', '_') + "-" + Origin.UniqueGuid, DotNetObjectReference.Create(this), Origin.Left, Origin.Top, _backgroundId, Parent._zoomableContainer.Scale);
        }

        [JSInvokable]
        public Task SetDataAsync(double left, double top)
        {
            Origin._left = left;
            Origin._top = top;

            Origin.StateHasChangeModalDelegate?.Invoke();

            Parent?.Save();

            return Task.CompletedTask;
        }
    }
}
