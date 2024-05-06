using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;
using System.ComponentModel;
using AXSharp.Connector.Localizations;
using System.Xml.Linq;
using KristofferStrube.Blazor.SVGEditor;
using static System.Formats.Asn1.AsnWriter;
using AngleSharp.Dom.Events;

namespace AXOpen.VisualComposer
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

        private async Task MoveAsync(PointerEventArgs eventArgs)
        {
            if (_isDragging)
            {
                double offsetX = ((eventArgs.ClientX - _startX) / Parent!.ElementSize.Width * 100) * (1 / Parent.Scale);
                double offsetY = ((eventArgs.ClientY - _startY) / ((Parent!.BackgroundHeight / Parent!.BackgroundWidth) * Parent!.ElementSize.Width) * 100) * (1 / Parent.Scale);

                Origin._left += offsetX;
                Origin._top += offsetY;

                _startX = eventArgs.ClientX;
                _startY = eventArgs.ClientY;

                await Parent.SaveAsync();
            }
        }

        private void Down(PointerEventArgs eventArgs)
        {
            Parent._zoomableContainer.CanDragging = false;
            _isDragging = true;
            _startX = eventArgs.ClientX;
            _startY = eventArgs.ClientY;
        }

        private void Up(PointerEventArgs eventArgs)
        {
            Parent._zoomableContainer.CanDragging = true;
            _isDragging = false;
        }

        private void Out(PointerEventArgs eventArgs)
        {
            Parent._zoomableContainer.CanDragging = true;
            _isDragging = false;
        }

        private void Wheel(WheelEventArgs eventArgs)
        {

        }
    }
}
