using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;
using System.ComponentModel;
using AXSharp.Connector.Localizations;

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
                Left = value.Left;
                Top = value.Top;
                _transform = value.Transform;
                _presentation = value.Presentation;
                _width = value.Width;
                _height = value.Height;
                _zIndex = value.ZIndex;
                _scale = value.Scale;
                Roles = value.Roles;
                _presentationTemplate = value.PresentationTemplate;
                _background = value.Background;
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

        internal double _left { get; set; } = 10;
        public double Left
        {
            get => _left;
            set
            {
                _left = value;
                StateHasChanged();
            }
        }

        internal double _top { get; set; } = 10;
        public double Top
        {
            get => _top;
            set
            {
                _top = value;
                StateHasChanged();
            }
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

        private bool _customPresentation = false;
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

        public bool _background = false;
        public bool Background
        {
            get => _background;
            set
            {
                _background = value;
                StateHasChanged();
            }
        }

        private string _id;
        private Guid _imgId1;
        private IJSRuntime _js;
        private ITwinElement? _twinElement;
        private Guid? _uniqueGuid = null;

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                await DragElement();
            }
        }

        public async Task DragElement()
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerItem.razor.js");
            await jsObject.InvokeVoidAsync("dragElement", Id.Replace('.', '_') + "-" + UniqueGuid, DotNetObjectReference.Create(this), Left, Top, _imgId, Parent._zoomableContainer.Scale);
        }

        [JSInvokable]
        public Task SetDataAsync(double left, double top)
        {
            Left = left;
            Top = top;

            return Task.CompletedTask;
        }

        public void Remove()
        {
            Parent.RemoveChildren(this);
        }
    }
}
