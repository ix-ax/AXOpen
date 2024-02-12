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



        [CascadingParameter(Name = "BackgroundId")]
        private Guid _backgroundId { get; set; }

        [Parameter]
        public VisualComposerItem? Origin
        {
            set
            {
                UniqueGuid = value.UniqueGuid;
                TwinElement = value.TwinElement;
                Id = value.TwinElement?.Symbol.ModalIdHelper();
                _left = value.Left;
                _top = value.Top;
                _transform = value.Transform;
                _presentation = value.Presentation;
                _width = value.Width;
                _height = value.Height;
                _zIndex = value.ZIndex;
                _scale = value.Scale;
                _roles = value.Roles;
                _presentationTemplate = value.PresentationTemplate;
                _background = value.Background;
                _backgroundColor = value.BackgroundColor;
            }
        }

        private IJSRuntime _js;
        [Inject]
        protected IJSRuntime js
        {
            get => _js;
            set => _js = value;
        }

        private ITwinElement? _twinElement;
        public ITwinElement? TwinElement
        {
            get => _twinElement;
            set => _twinElement = value;
        }

        private string _id;
        public string? IdPlain
        {
            get => _id;
        }

        public string? Id
        {
            get => _id?.ComputeSha256Hash();
            set => _id = value;
        }

        private Guid? _uniqueGuid = null;
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
                Parent?.Save();
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
                Parent?.Save();
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
                Parent?.Save();
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
                    Parent?.Save();
                }

            }
        }

        private bool _customPresentation = false;
        public bool CustomPresentation
        {
            get => _customPresentation;
            set
            {
                _customPresentation = value;
                Parent?.Save();
            }
        }

        internal double _width = -1;
        public double Width
        {
            get => _width;
            set
            {
                _width = value;
                StateHasChanged();
                Parent?.Save();
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
                Parent?.Save();
            }
        }
        
        // public new async Task StateHasChanged()
        // {
        //     await InvokeAsync(() =>
        //     {
        //         // Your logic here
        //         base.StateHasChanged();
        //     });
        // }
        
        internal int _zIndex = 0;
        public int ZIndex
        {
            get => _zIndex;
            set
            {
                _zIndex = value;
                StateHasChanged();
                Parent?.Save();
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
                Parent?.Save();
            }
        }

        internal string _roles = "";
        public string Roles
        {
            get => _roles;
            set
            {
                _roles = value;
                Parent?.Save();
            }
        }

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
                    Parent?.Save();
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
                Parent?.Save();
            }
        }

        public string _backgroundColor = "#FFFFFF";
        public string BackgroundColor
        {
            get => _backgroundColor;
            set
            {
                _backgroundColor = value;
                StateHasChanged();
                Parent?.Save();
            }
        }

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
            await jsObject.InvokeVoidAsync("dragElement", Id.Replace('.', '_') + "-" + UniqueGuid, DotNetObjectReference.Create(this), Left, Top, _backgroundId, Parent._zoomableContainer.Scale);
        }

        [JSInvokable]
        public Task SetDataAsync(double left, double top)
        {
            _left = left;
            _top = top;

            Parent?.Save();

            return Task.CompletedTask;
        }

        public void Remove()
        {
            Parent.RemoveChildren(this);
        }
    }
}
