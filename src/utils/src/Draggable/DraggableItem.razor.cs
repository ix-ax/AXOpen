using Draggable.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace Draggable
{
    public partial class DraggableItem
    {
        [Parameter]
        public RenderFragment? ChildContent { get; set; }

        private DraggableContainer? _parent;

        [CascadingParameter(Name = "Parent")]
        protected DraggableContainer? Parent
        {
            get => _parent;
            set
            {
                _parent = value;

                Id = AxoObject.HumanReadable;

                _parent?.AddChild(this);
            }
        }

        [CascadingParameter(Name = "ImgId")]
        private Guid _imgId { get; set; }

        [Parameter]
        public AXOpen.Core.AxoObject? AxoObject { get; set; }
        public string Id { get; set; }

        [Inject]
        protected IJSRuntime js { get; set; }
        private IJSObjectReference? jsModule;

        private double startX, startY, offsetX, offsetY;
        public double ratioImgX = 10, ratioImgY = 10;
        public bool Show { get; set; } = false;
        public TransformType Transform { get; set; } = TransformType.TopCenter;
        public PresentationType Presentation { get; set; } = PresentationType.StatusDisplay;
        private string cursor = "default";

        private void OnDragStart(DragEventArgs args)
        {
            startX = args.ClientX;
            startY = args.ClientY;

            cursor = "move";
        }

        private async void OnDragEnd(DragEventArgs args)
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/Draggable/DraggableItem.razor.js");
            //var windowSize = await jsObject.InvokeAsync<WindowSize>("getWindowSize");
            var imageSize = await jsObject.InvokeAsync<WindowSize>("getImageSize", _imgId);

            offsetX = startX - (ratioImgX / 100 * imageSize.Width);
            offsetY = startY - (ratioImgY / 100 * imageSize.Height);

            ratioImgX = ((args.ClientX - offsetX) / imageSize.Width * 100);
            ratioImgY = ((args.ClientY - offsetY) / imageSize.Height * 100);

            cursor = "default";

            StateHasChanged();
        }
    }
}
