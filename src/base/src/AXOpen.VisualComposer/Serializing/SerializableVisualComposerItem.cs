namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableVisualComposerItem
    {
        public SerializableVisualComposerItem(string id, double left, double top, string transform, string presentation, double width, double height, int zIndex, double scale, string roles, string presentationTemplate, bool background, string backgroundColor)
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
            PresentationTemplate = presentationTemplate;
            Background = background;
            BackgroundColor = backgroundColor;
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
        public string PresentationTemplate { get; set; } = "";
        public bool Background { get; set; } = false;
        public string BackgroundColor { get; set; } = "";
    }
}
