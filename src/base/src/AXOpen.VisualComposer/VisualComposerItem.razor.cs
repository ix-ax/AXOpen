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
        private Guid _imgId { get; set; }

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

                Id = value.TwinElement?.Symbol.ModalIdHelper();
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

        public double Left { get; set; } = 10;
        public double Top { get; set; } = 10;

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

        public double _scale = 1;
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
