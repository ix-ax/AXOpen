namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableObject
    {
        public SerializableObject(string? imgSrc, List<SerializableVisualComposerItem> items, double scale, int translateX, int translateY)
        {
            ImgSrc = imgSrc;
            Items = items;
            Scale = scale;
            TranslateX = translateX;
            TranslateY = translateY;
        }

        public string? ImgSrc { get; set; }
        public List<SerializableVisualComposerItem> Items { get; set; }

        public double Scale { get; set; }
        public int TranslateX { get; set; }
        public int TranslateY { get; set; }
    }
}
