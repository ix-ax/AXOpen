﻿namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableObject
    {
        public SerializableObject(string? imgSrc, List<SerializableVisualComposerItem> items, string? theme, double scale, int translateX, int translateY, bool allowZoomingAndPanning)
        {
            ImgSrc = imgSrc;
            Items = items;
            Theme = theme;
            Scale = scale;
            TranslateX = translateX;
            TranslateY = translateY;
            AllowZoomingAndPanning = allowZoomingAndPanning;
        }

        public string? ImgSrc { get; set; }
        public List<SerializableVisualComposerItem> Items { get; set; }

        public string? Theme { get; set; }

        public double Scale { get; set; }
        public int TranslateX { get; set; }
        public int TranslateY { get; set; }
        public bool AllowZoomingAndPanning { get; set; }
    }
}
