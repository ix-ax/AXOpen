using AXOpen.VisualComposer.Types;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.VisualComposer
{
    public class VisualComposerItemData
    {
        public EventCallback EventCallbackStateHasChanged { get; set; }
        public EventCallback EventCallbackSave { get; set; }

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
        }

        private Guid? _uniqueGuid = null;
        public Guid? UniqueGuid
        {
            get => _uniqueGuid;
            set => _uniqueGuid = value;
        }

        public double _left { get; set; } = 10;
        public double Left
        {
            get => _left;
            set
            {
                _left = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();

                DragElementDelegate?.Invoke();
            }
        }

        public double _top { get; set; } = 10;
        public double Top
        {
            get => _top;
            set
            {
                _top = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();

                DragElementDelegate?.Invoke();
            }
        }

        internal TransformType _transform = TransformType.TopCenter;
        public TransformType Transform
        {
            get => _transform;
            set
            {
                _transform = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
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
                    //if (renderableContentControlRcc != null)
                    //{
                    //    renderableContentControlRcc.Presentation = value;
                    //    renderableContentControlRcc?.ForceRender();
                    //}

                    if (EventCallbackStateHasChanged.HasDelegate)
                        EventCallbackStateHasChanged.InvokeAsync();

                    if (EventCallbackSave.HasDelegate)
                        EventCallbackSave.InvokeAsync();
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

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        internal double _width = -1;
        public double Width
        {
            get => _width;
            set
            {
                _width = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        internal double _height = -1;
        public double Height
        {
            get => _height;
            set
            {
                _height = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        internal int _zIndex = 0;
        public int ZIndex
        {
            get => _zIndex;
            set
            {
                _zIndex = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        internal double _scale = 1;
        public double Scale
        {
            get => _scale;
            set
            {
                _scale = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        internal string _roles = "";
        public string Roles
        {
            get => _roles;
            set
            {
                _roles = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
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

                    if (EventCallbackStateHasChanged.HasDelegate)
                        EventCallbackStateHasChanged.InvokeAsync();

                    if (EventCallbackSave.HasDelegate)
                        EventCallbackSave.InvokeAsync();
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

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        public string _backgroundColor = "#FFFFFF";
        public string BackgroundColor
        {
            get => _backgroundColor;
            set
            {
                _backgroundColor = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        public delegate void EmptyDelegate();

        public EmptyDelegate StateHasChangeModalDelegate;

        public EmptyDelegate DragElementDelegate;

        public VisualComposerItemData(EventCallback eventCallbackStateHasChanged, EventCallback eventCallbackSave, ITwinElement? twinElement, string? id, Guid? uniqueGuid, double left, double top, TransformType transform, string presentation, bool customPresentation, double width, double height, int zIndex, double scale, string roles, string? presentationTemplate, bool background, string backgroundColor)
        {
            EventCallbackStateHasChanged = eventCallbackStateHasChanged;
            EventCallbackSave = eventCallbackSave;
            TwinElement = twinElement;
            _id = id;
            UniqueGuid = uniqueGuid;
            _left = left;
            _top = top;
            _transform = transform;
            _presentation = presentation;
            _customPresentation = customPresentation;
            _width = width;
            _height = height;
            _zIndex = zIndex;
            _scale = scale;
            _roles = roles;
            _presentationTemplate = presentationTemplate;
            _background = background;
            _backgroundColor = backgroundColor;
        }

        public VisualComposerItemData(EventCallback eventCallbackStateHasChanged, EventCallback eventCallbackSave, ITwinElement? twinElement, string? id, Guid? uniqueGuid)
        {
            EventCallbackStateHasChanged = eventCallbackStateHasChanged;
            EventCallbackSave = eventCallbackSave;
            TwinElement = twinElement;
            _id = id;
            UniqueGuid = uniqueGuid;
        }
    }
}
