namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableConfiguration
    {
        public SerializableConfiguration(List<string> views, string? defaultView)
        {
            Views = views;
            DefaultView = defaultView;
        }

        public List<string> Views { get; set; }

        public string? DefaultView { get; set; }
    }
}
