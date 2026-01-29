using AXOpen.VisualComposer.Serializing;
using AXOpen.VisualComposer.Types;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.VisualComposer.Components.VisualComposerItem
{
    public class VisualComposerItemData
    {
        public bool ModalSettingOpen { get; set; }

        public EventCallback EventCallbackStateHasChanged { get; set; }
        public EventCallback EventCallbackSave { get; set; }


        public EventHandler MoveEvent { get; set; }
        public EventHandler LeaveEvent { get; set; }


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
            get => _id;
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

        internal int _zIndex = 10;
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

        internal double _rotate = 0;
        public double Rotate
        {
            get => _rotate;
            set
            {
                _rotate = value;

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

        public int _pollingInterval = 250;

        public int PollingInterval
        {
            get => _pollingInterval;
            set
            {
                _pollingInterval = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        public string _backgroundColorLight = "var(--color-white)";
        public string BackgroundColorLight
        {
            get => _backgroundColorLight;
            set
            {
                _backgroundColorLight = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        public string _backgroundColorDark = "var(--color-white)";
        public string BackgroundColorDark
        {
            get => _backgroundColorDark;
            set
            {
                _backgroundColorDark = value;

                if (EventCallbackStateHasChanged.HasDelegate)
                    EventCallbackStateHasChanged.InvokeAsync();

                if (EventCallbackSave.HasDelegate)
                    EventCallbackSave.InvokeAsync();
            }
        }

        public delegate void EmptyDelegate();

        public EmptyDelegate StateHasChangeModalDelegate { get; set; }

        public EmptyDelegate DragElementDelegate { get; set; }

        public VisualComposerItemData()
        {
            
        }

        public VisualComposerItemData(EventCallback eventCallbackStateHasChanged,
            EventCallback eventCallbackSave,
            ITwinElement? twinElement,
            double left,
            double top,
            TransformType transform,
            string presentation,
            double width,
            double height,
            int zIndex,
            double scale,
            double rotate,
            string roles,
            string? presentationTemplate,
            bool background,
            string backgroundColorLight,
            string backgroundColorDark,
            int pollingInterval)
        {
            EventCallbackStateHasChanged = eventCallbackStateHasChanged;
            EventCallbackSave = eventCallbackSave;
            TwinElement = twinElement;
            _id = twinElement.Symbol;
            UniqueGuid = Guid.NewGuid();
            _left = left;
            _top = top;
            _transform = transform;
            _presentation = presentation;
            _width = width;
            _height = height;
            _zIndex = zIndex;
            _scale = scale;
            _rotate = rotate;
            _roles = roles;
            _presentationTemplate = presentationTemplate;
            _background = background;
            _backgroundColorLight = backgroundColorLight;
            _backgroundColorDark = backgroundColorDark;
            _pollingInterval = pollingInterval;
        }

        public VisualComposerItemData(EventCallback eventCallbackStateHasChanged,
            EventCallback eventCallbackSave,
            ITwinElement? twinElement)
        {
            EventCallbackStateHasChanged = eventCallbackStateHasChanged;
            EventCallbackSave = eventCallbackSave;
            TwinElement = twinElement;
            _id = twinElement.Symbol;
            UniqueGuid = Guid.NewGuid();
        }

        public VisualComposerItemData(EventCallback eventCallbackStateHasChanged,
            EventCallback eventCallbackSave,
            ITwinElement? twinElement,
            SerializableItem item)
        {
            EventCallbackStateHasChanged = eventCallbackStateHasChanged;
            EventCallbackSave = eventCallbackSave;
            TwinElement = twinElement;
            _id = twinElement?.Symbol ?? item.Id;
            UniqueGuid = Guid.NewGuid();
            _left = item.Left;
            _top = item.Top;
            _transform = Types.TransformType.FromString(item.Transform);
            _presentation = item.Presentation;
            _width = item.Width;
            _height = item.Height;
            _zIndex = item.ZIndex;
            _scale = item.Scale;
            _rotate = item.Rotate;
            _roles = item.Roles;
            _presentationTemplate = item.PresentationTemplate;
            _background = item.Background;
            _backgroundColorLight = item.BackgroundColorLight;
            _backgroundColorDark = item.BackgroundColorDark;
            _pollingInterval = item.PollingInterval;
        }

        public void SetDefaultBackgroundColors()
        {
            BackgroundColorLight = "var(--color-white)";
            BackgroundColorDark = "var(--color-dark-800)";

            if (EventCallbackStateHasChanged.HasDelegate)
                EventCallbackStateHasChanged.InvokeAsync();

            if (EventCallbackSave.HasDelegate)
                EventCallbackSave.InvokeAsync();
        }
    }
}
