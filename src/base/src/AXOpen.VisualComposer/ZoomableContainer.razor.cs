using KristofferStrube.Blazor.SVGEditor;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Formats.Asn1.AsnWriter;

namespace AXOpen.VisualComposer
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
                double offsetX = ((eventArgs.ClientX - _startX) / Parent.ElementSize.Width * 100) * (1 / Parent.Scale);
                double offsetY = ((eventArgs.ClientY - _startY) / ((Parent!.BackgroundHeight / Parent!.BackgroundWidth) * Parent!.ElementSize.Width) * 100) * (1 / Parent.Scale);

                Parent!.TranslateX += offsetX;
                Parent!.TranslateY += offsetY;

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
                Parent!.Scale = Math.Min(Math.Max(0.5, Parent!.Scale + eventArgs.DeltaY * -0.0001), 2);
                await Parent.SaveAsync();
            }
        }
    }
}
