namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableObject
    {
        public SerializableObject(int backgroundWidth, int backgroundHeight, string? imgSrc, string backgroundColor, string backgroundSVGInput, List<SerializableVisualComposerItem> items, string theme, double scale, int translateX, int translateY, bool allowZoomingAndPanning)
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

        public int BackgroundWidth { get; set; }
        public int BackgroundHeight { get; set; }
        public string? ImgSrc { get; set; }
        public string BackgroundColor { get; set; } = "";

        public string BackgroundSVGInput { get; set; } = "";
        public List<SerializableVisualComposerItem> Items { get; set; }

        public string Theme { get; set; }

        public double Scale { get; set; }
        public int TranslateX { get; set; }
        public int TranslateY { get; set; }
        public bool AllowZoomingAndPanning { get; set; }
    }
}
