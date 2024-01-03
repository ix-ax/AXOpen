using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.VisualComposer
{
    public partial class ZoomableContainer
    {
        [Parameter] public RenderFragment ChildContent { get; set; }







        //<div id="zoomAndMoveContainer" @onmousewheel="OnMouseWheel" @onmousedown="OnMouseDown" @onmouseup="OnMouseUp" @onmousemove="OnMouseMove" @onmouseout="OnMouseOut" style="position: relative; width: 100%; height: 100%; transform: scale(@(Scale)) translate(@(OffsetX)px, @(OffsetY)px);" ondragover="event.preventDefault();">
        //public double Scale = 1.0;

        //private bool _isDragging = false;
        //private double _startX;
        //private double _startY;

        //public double OffsetX = 0;
        //public double OffsetY = 0;

        //private void OnMouseWheel(WheelEventArgs e)
        //{
        //    Scale += e.DeltaY * -0.0001;

        //    Scale = Math.Min(Math.Max(0.5, Scale), 2);

        //    StateHasChanged();
        //}

        //private void OnMouseDown(MouseEventArgs e)
        //{
        //    _isDragging = true;
        //    _startX = e.ClientX - OffsetX;
        //    _startX = e.ClientY - OffsetY;
        //}

        //private void OnMouseUp(MouseEventArgs e)
        //{
        //    _isDragging = false;
        //}

        //private void OnMouseMove(MouseEventArgs e)
        //{
        //    if (_isDragging)
        //    {
        //        OffsetX = e.ClientX - _startX;
        //        OffsetY = e.ClientY - _startX;

        //        StateHasChanged();
        //    }
        //}

        //private void OnMouseOut(MouseEventArgs e)
        //{
        //    //_isDragging = false;
        //}
    }
}
