namespace AXOpen.VisualComposer.Serializing
{
    public class SerializableView
    {
        public bool IsWatchTable { get; set; } = false;
        public double BackgroundWidth { get; set; } = 1000;
        public double BackgroundHeight { get; set; } = 350;
        public string? ImgSrc { get; set; } = null;
        public string BackgroundColor { get; set; } = "#EBF9EB";

        public string BackgroundSVGInput { get; set; } = "";
        public List<SerializableItem> Items { get; set; }

        public string Theme { get; set; } = "text-dark";

        public double Scale { get; set; } = 1;
        public double TranslateX { get; set; } = 0;
        public double TranslateY { get; set; } = 0;
        public bool AllowZoomingAndPanning { get; set; } = true;

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
