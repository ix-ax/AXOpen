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

        private void Move(PointerEventArgs eventArgs)
        {
            if (_isDragging)
            {
                double offsetX = ((eventArgs.ClientX - _startX) / Parent!.ElementSize.Width * 100);
                double offsetY = ((eventArgs.ClientY - _startY) / ((Parent!.BackgroundHeight / Parent!.BackgroundWidth) * Parent!.ElementSize.Width) * 100);

                Origin._left += offsetX;
                Origin._top += offsetY;

                _startX = eventArgs.ClientX;
                _startY = eventArgs.ClientY;

                Parent.Save();
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

        private void Out(PointerEventArgs eventArgs)
        {
            _isDragging = false;
        }

        private void Wheel(WheelEventArgs eventArgs)
        {

        }
    }
}
