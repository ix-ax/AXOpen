namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableVisualComposerItem
    {
        public SerializableVisualComposerItem(string id, 
            double left, 
            double top, 
            string transform, 
            string presentation, 
            double width, 
            double height, 
            int zIndex, 
            double scale, 
            string roles, 
            string presentationTemplate, 
            bool background, 
            string backgroundColor, 
            int pollingInterval)
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
            PollingInterval = pollingInterval;
        }

        public string Id { get; set; }
        public double Left { get; set; }
        public double Top { get; set; }
        public string Transform { get; set; }
        public string Presentation { get; set; }
        public double Width { get; set; }
        public double Height { get; set; }
        public int ZIndex { get; set; }
        public double Scale { get; set; }
        public string Roles { get; set; }
        public string PresentationTemplate { get; set; }
        public bool Background { get; set; }
        public string BackgroundColor { get; set; }
        public int PollingInterval { get; set; }
    }
}
