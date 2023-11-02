using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItem
    {
        [Parameter]
        public RenderFragment? ChildContent { get; set; }

        private VisualComposerContainer? _parent;

        [CascadingParameter(Name = "Parent")]
        protected VisualComposerContainer? Parent
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
        private string _presentation = PresentationType.StatusDisplay.Value;
        public string Presentation
        {
            get => _presentation;
            set
            {
                _presentation = value;
                CustomPresentation = !PresentationType.IsEnumValue(value);
            }
        }
        public bool CustomPresentation { get; set; } = false;

        public double Width = -1, Height = -1;
        public int ZIndex = 0;

        private void OnDragStart(DragEventArgs args)
        {
            startX = args.ClientX;
            startY = args.ClientY;
        }

        private async void OnDragEnd(DragEventArgs args)
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerItem.razor.js");
            //var windowSize = await jsObject.InvokeAsync<WindowSize>("getWindowSize");
            var imageSize = await jsObject.InvokeAsync<WindowSize>("getImageSize", _imgId);

            offsetX = startX - (ratioImgX / 100 * imageSize.Width);
            offsetY = startY - (ratioImgY / 100 * imageSize.Height);

            ratioImgX = ((args.ClientX - offsetX) / imageSize.Width * 100);
            ratioImgY = ((args.ClientY - offsetY) / imageSize.Height * 100);

            StateHasChanged();
        }
    }
}
