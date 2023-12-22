using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;
using System.ComponentModel;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItem
    {
        private VisualComposerContainer? _parent;
        private Guid _imgId { get; set; }

        [CascadingParameter(Name = "Parent")]
        protected Tuple<VisualComposerContainer, Guid>? Tuple
        {
            set
            {
                _parent = value.Item1;
                _imgId = value.Item2;

                if (value != null)
                    value.Item1.AddChildren(this);
            }
        }

        [Parameter]
        public VisualComposerItem? Origin
        {
            set
            {
                UniqueGuid = value.UniqueGuid;
                TwinElement = value.TwinElement;
                ratioImgX = value.ratioImgX;
                ratioImgY = value.ratioImgY;
                _transform = value.Transform;
                _presentation = value.Presentation;
                _width = value.Width;
                _height = value.Height;
                _zIndex = value.ZIndex;
                Roles = value.Roles;

                Id = value.TwinElement.Symbol.ModalIdHelper();
            }
        }

        [Inject]
        protected IJSRuntime js { get; set; }
        private IJSObjectReference? jsModule;

        public ITwinElement? TwinElement { get; set; }

        public string? IdPlain
        {
            get => _id;
        }

        public string? Id
        {
            get => _id?.ComputeSha256Hash();
            set => _id = value;
        }

        public Guid? UniqueGuid { get; set; } = null;

        private double startX;
        private double startY;

        public double ratioImgX = 10;
        public double ratioImgY = 10;

        public TransformType _transform = TransformType.TopCenter;
        public TransformType Transform
        {
            get => _transform;
            set
            {
                _transform = value;
                StateHasChanged();
            }
        }

        public string _presentation = PresentationType.StatusDisplay.Value;
        public string Presentation
        {
            get => _presentation;
            set
            {
                _presentation = value;
                // CustomPresentation = !PresentationType.IsEnumValue(value);
                StateHasChanged();
            }
        }
        public bool CustomPresentation { get; set; } = false;

        public double _width = -1;
        public double Width
        {
            get => _width;
            set
            {
                _width = value;
                StateHasChanged();
            }
        }

        public double _height = -1;
        public double Height
        {
            get => _height;
            set
            {
                _height = value;
                StateHasChanged();
            }
        }

        public int _zIndex = 0;
        public int ZIndex
        {
            get => _zIndex;
            set
            {
                _zIndex = value;
                StateHasChanged();
            }
        }

        public string Roles = "";
        private string _id;

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

            double offsetX = startX - (ratioImgX / 100 * imageSize.Width);
            double offsetY = startY - (ratioImgY / 100 * imageSize.Height);

            if (imageSize.Width == 0)
                ratioImgX = (args.ClientX - offsetX);
            else
                ratioImgX = ((args.ClientX - offsetX) / imageSize.Width * 100);

            if (imageSize.Height == 0)
                ratioImgY = (args.ClientY - offsetY);
            else
                ratioImgY = ((args.ClientY - offsetY) / imageSize.Height * 100);

            StateHasChanged();
        }

        public void Remove()
        {
            _parent.RemoveChildren(this);
        }
    }
}
