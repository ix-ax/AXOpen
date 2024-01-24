﻿namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableVisualComposerItem
    {
        public SerializableVisualComposerItem(string id, 
            double ratioImgX, 
            double ratioImgY, 
            string transform, 
            string presentation, 
            double width, 
            double height, 
            int zIndex, 
            double scale, 
            string roles,
            string presentationTemplate)
        {
            Id = id;
            RatioImgX = ratioImgX;
            RatioImgY = ratioImgY;
            Transform = transform;
            Presentation = presentation;
            Width = width;
            Height = height;
            ZIndex = zIndex;
            Scale = scale;
            Roles = roles;
            PresentationTemplate = presentationTemplate;
        }

        public string Id { get; set; }
        public double RatioImgX { get; set; } = 10;
        public double RatioImgY { get; set; } = 10;
        public string Transform { get; set; } = "TopCenter";
        public string Presentation { get; set; } = "Status-Display";
        public double Width { get; set; } = -1;
        public double Height { get; set; } = -1;
        public int ZIndex { get; set; } = 0;
        public double Scale { get; set; } = 1;
        public string Roles { get; set; } = "";
        public string PresentationTemplate { get; set; } = "";
    }
}
