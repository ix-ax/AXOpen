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

        [CascadingParameter(Name = "Parent")]
        public VisualComposerContainer? Parent
        {
            get => _parent;
            protected set
            {
                _parent = value;

                if (value != null)
                    value.AddChildren(this);
            }
        }

        [CascadingParameter(Name = "ImgId")]
        private Guid _imgId
        {
            get => _imgId1;
            set => _imgId1 = value;
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
                _scale = value.Scale;
                Roles = value.Roles;
                PresentationTemplate = value.PresentationTemplate;
                Id = value.TwinElement?.Symbol.ModalIdHelper();
            }
        }

        [Inject]
        protected IJSRuntime js
        {
            get => _js;
            set => _js = value;
        }

        private IJSObjectReference? jsModule;

        public ITwinElement? TwinElement
        {
            get => _twinElement;
            set => _twinElement = value;
        }

        public string? IdPlain
        {
            get => _id;
        }

        public string? Id
        {
            get => _id?.ComputeSha256Hash();
            set => _id = value;
        }

        public Guid? UniqueGuid
        {
            get => _uniqueGuid;
            set => _uniqueGuid = value;
        }

        private double startX;
        private double startY;

        internal double ratioImgX = 10;
        internal double ratioImgY = 10;


        public double PosX
        {
            get { return ratioImgX; }
            set { ratioImgX = value; StateHasChanged(); }
        }

        public double PosY
        {
            get { return ratioImgY; }
            set { ratioImgY = value; StateHasChanged(); }
        }

        
        internal TransformType _transform = TransformType.TopCenter;
        public TransformType Transform
        {
            get => _transform;
            set
            {
                _transform = value;
                StateHasChanged();
            }
        }

        internal string _presentation = PresentationType.StatusDisplay.Value;
        public string Presentation
        {
            get => _presentation;
            set
            {
                if (_presentation != value)
                {
                    _presentation = value;
                    if (renderableContentControlRcc != null)
                    {
                        renderableContentControlRcc.Presentation = value;
                        renderableContentControlRcc?.ForceRender();
                    }                    
                    StateHasChanged();
                }
                
            }
        }

        public bool CustomPresentation
        {
            get => _customPresentation;
            set => _customPresentation = value;
        }

        internal double _width = -1;
        public double Width
        {
            get => _width;
            set
            {
                _width = value;
                StateHasChanged();
            }
        }

        internal double _height = -1;
        public double Height
        {
            get => _height;
            set
            {
                _height = value;
                StateHasChanged();
            }
        }

        internal int _zIndex = 0;
        public int ZIndex
        {
            get => _zIndex;
            set
            {
                _zIndex = value;
                StateHasChanged();
            }
        }

        internal double _scale = 1;
        public double Scale
        {
            get => _scale;
            set
            {
                _scale = value;
                StateHasChanged();
            }
        }

        public string Roles = "";
        private string _id;
        private Guid _imgId1;
        private IJSRuntime _js;
        private ITwinElement? _twinElement;
        private Guid? _uniqueGuid = null;
        private bool _customPresentation = false;


        internal string? _presentationTemplate;
        public string? PresentationTemplate
        {
            get => _presentationTemplate;
            set
            {
                if (_presentationTemplate != value)
                {
                    _presentationTemplate = value;
                    StateHasChanged();
                }
            }
        }

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

            double offsetX = startX - (ratioImgX / 100 * imageSize.Width) * (Parent._zoomableContainer.Scale);
            double offsetY = startY - (ratioImgY / 100 * imageSize.Height) * (Parent._zoomableContainer.Scale);

            if (imageSize.Width == 0)
                ratioImgX = (args.ClientX - offsetX);
            else
                ratioImgX = ((args.ClientX - offsetX) / imageSize.Width * 100) * (1 / Parent._zoomableContainer.Scale);

            if (imageSize.Height == 0)
                ratioImgY = (args.ClientY - offsetY);
            else
                ratioImgY = ((args.ClientY - offsetY) / imageSize.Height * 100) * (1 / Parent._zoomableContainer.Scale);

            StateHasChanged();
        }

        public void Remove()
        {
            Parent.RemoveChildren(this);
        }
    }
}
