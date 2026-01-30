using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;

namespace AXOpen.VisualComposer.Components.VisualComposerItem
{
    public partial class VisualComposerItem
    {

        [CascadingParameter(Name = "Parent")]
        public VisualComposerContainer? Parent { get; set; }

        [Parameter]
        public VisualComposerItemData? Origin { get; set; }


        private bool _isDragging = false;
        private double _startX = 0;
        private double _startY = 0;

        protected override void OnAfterRender(bool firstRender)
        {
            Origin!.MoveEvent = new EventHandler((sender, e) => MoveAsync((PointerEventArgs)e));
            Origin!.LeaveEvent = new EventHandler((sender, e) => Leave((PointerEventArgs)e));
        }

        private async Task MoveAsync(PointerEventArgs eventArgs)
        {
            if (_isDragging)
            {
                double offsetX = ((eventArgs.ClientX - _startX) / Parent!.ElementSize.Width * 100) * (1 / Parent.CurrentView.Scale);
                double offsetY = ((eventArgs.ClientY - _startY) / Parent!.ElementSize.Width * 100) * (1 / Parent.CurrentView.Scale);

                Origin._left += offsetX;
                Origin._top += offsetY;

                _startX = eventArgs.ClientX;
                _startY = eventArgs.ClientY;

                await Parent.SaveAsync();
            }
        }

        private void Down(PointerEventArgs eventArgs)
        {
            Parent.ZoomableContainer.CanDragging = false;
            _isDragging = true;
            _startX = eventArgs.ClientX;
            _startY = eventArgs.ClientY;
        }

        private void Up(PointerEventArgs eventArgs)
        {
            Parent.ZoomableContainer.CanDragging = true;
            _isDragging = false;
        }

        private void Leave(PointerEventArgs eventArgs)
        {
            Parent.ZoomableContainer.CanDragging = true;
            _isDragging = false;
        }

        private void Wheel(WheelEventArgs eventArgs)
        {

        }
    }
}
