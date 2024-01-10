namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableVisualComposerItem
    {
        public SerializableVisualComposerItem(string id, double left, double top, string transform, string presentation, double width, double height, int zIndex, double scale, string roles)
        {
            Id = id;
            Left = left;
            Top = top;
            Transform = transform;
            Presentation = presentation;
            Width = width;
            Height = height;
            ZIndex = zIndex;
            Scale = scale;
            Roles = roles;
        }

        public string Id { get; set; }
        public double Left { get; set; } = 10;
        public double Top { get; set; } = 10;
        public string Transform { get; set; } = "TopCenter";
        public string Presentation { get; set; } = "Status-Display";
        public double Width { get; set; } = -1;
        public double Height { get; set; } = -1;
        public int ZIndex { get; set; } = 0;
        public double Scale { get; set; } = 1;
        public string Roles { get; set; } = "";
    }
}
