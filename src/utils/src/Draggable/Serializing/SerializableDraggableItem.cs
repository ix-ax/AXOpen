using Draggable.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Draggable.Serializing
{
    internal class SerializableDraggableItem
    {
        public SerializableDraggableItem(string id, double ratioImgX, double ratioImgY, bool show, string transform, string presentation, double width, double height, int zIndex)
        {
            Id = id;
            RatioImgX = ratioImgX;
            RatioImgY = ratioImgY;
            Show = show;
            Transform = transform;
            Presentation = presentation;
            Width = width;
            Height = height;
            ZIndex = zIndex;
        }

        public string Id { get; set; }
        public double RatioImgX { get; set; } = 10;
        public double RatioImgY { get; set; } = 10;
        public bool Show { get; set; } = false;
        public string Transform { get; set; } = "TopCenter";
        public string Presentation { get; set; } = "Status-Display";
        public double Width { get; set; } = -1;
        public double Height { get; set; } = -1;
        public int ZIndex { get; set; } = 0;
    }
}
