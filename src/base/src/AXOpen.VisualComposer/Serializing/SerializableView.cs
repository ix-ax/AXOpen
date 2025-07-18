namespace AXOpen.VisualComposer.Serializing
{
    public class SerializableView
    {
        public bool IsWatchTable { get; set; }
        public double BackgroundWidth { get; set; }
        public double BackgroundHeight { get; set; }
        public string? ImgSrc { get; set; }
        public string BackgroundColor { get; set; }

        public string BackgroundSVGInput { get; set; }
        public List<SerializableItem> Items { get; set; }

        public string Theme { get; set; }

        public double Scale { get; set; } = 1.0;
        public double TranslateX { get; set; }
        public double TranslateY { get; set; }
        public bool AllowZoomingAndPanning { get; set; }

        public SerializableView()
        {
            Items = new List<SerializableItem>();
        }

        public SerializableView(bool isWatchTable, double backgroundWidth, double backgroundHeight, string? imgSrc, string backgroundColor, string backgroundSVGInput, List<SerializableItem> items, string theme, double scale, double translateX, double translateY, bool allowZoomingAndPanning)
        {
            IsWatchTable = isWatchTable;
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
    }
}
