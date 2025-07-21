using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

namespace AXOpen.VisualComposer.Components
{
    public partial class ZoomableContainer
    {
        [Parameter] public RenderFragment ChildContent { get; set; }

        private VisualComposerContainer? _parent;

        [Parameter]
        public VisualComposerContainer? Parent
        {
            get => _parent;
            set
            {
                _parent = value;

                if (value != null)
                    value.AddZoomableContainer(this);
            }
        }

        private bool _disable = false;
        [Parameter]
        public bool Disable
        {
            get => _disable;
            set
            {
                if (_disable != value)
                    _disable = value;
            }
        }

        public bool CanDragging { get; set; } = true;
        private bool _isDragging = false;
        private double _startX = 0;
        private double _startY = 0;

        private async Task MoveAsync(PointerEventArgs eventArgs)
        {
            if (_isDragging && !Disable && CanDragging)
            {
                double offsetX = ((eventArgs.ClientX - _startX) / Parent.ElementSize.Width * 100) * (1 / Parent.CurrentView.Scale);
                double offsetY = ((eventArgs.ClientY - _startY) / ((Parent!.CurrentView.BackgroundHeight / Parent!.CurrentView.BackgroundWidth) * Parent!.ElementSize.Width) * 100) * (1 / Parent.CurrentView.Scale);

                Parent!.CurrentView.TranslateX += offsetX;
                Parent!.CurrentView.TranslateY += offsetY;

                _startX = eventArgs.ClientX;
                _startY = eventArgs.ClientY;

                await Parent.SaveAsync();
            }
        }

        private void Down(PointerEventArgs eventArgs)
        {
            _isDragging = true;
            _startX = eventArgs.ClientX;
            _startY = eventArgs.ClientY;
        }

        private void Up(PointerEventArgs eventArgs)
        {
            _isDragging = false;
        }

        private void Leave(PointerEventArgs eventArgs)
        {
            _isDragging = false;
        }

        private async Task WheelAsync(WheelEventArgs eventArgs)
        {
            if (!Disable && CanDragging)
            {
                Parent!.CurrentView.Scale = Math.Min(Math.Max(0.5, Parent!.CurrentView.Scale + eventArgs.DeltaY * -0.0001), 2);
                await Parent.SaveAsync();
            }
        }
    }
}
