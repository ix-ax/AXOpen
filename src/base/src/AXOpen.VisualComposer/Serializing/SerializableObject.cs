namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableObject
    {
        public SerializableObject(double backgroundWidth, double backgroundHeight, string? imgSrc, string backgroundColor, string backgroundSVGInput, List<SerializableVisualComposerItem> items, string theme, double scale, double translateX, double translateY, bool allowZoomingAndPanning)
        {
            BackgroundWidth = backgroundWidth;
            BackgroundHeight = backgroundHeight;
            ImgSrc = imgSrc;
            BackgroundColor = backgroundColor;
            BackgroundSVGInput = backgroundSVGInput;
            Items = items;
            Theme = theme;
            Scale = scale;
            TranslateX = translateX;
            TranslateY = translateY;
            AllowZoomingAndPanning = allowZoomingAndPanning;
        }

        public double BackgroundWidth { get; set; }
        public double BackgroundHeight { get; set; }
        public string? ImgSrc { get; set; }
        public string BackgroundColor { get; set; }

        public string BackgroundSVGInput { get; set; }
        public List<SerializableVisualComposerItem> Items { get; set; }

        public string Theme { get; set; }

        public double Scale { get; set; }
        public double TranslateX { get; set; }
        public double TranslateY { get; set; }
        public bool AllowZoomingAndPanning { get; set; }
    }
}
