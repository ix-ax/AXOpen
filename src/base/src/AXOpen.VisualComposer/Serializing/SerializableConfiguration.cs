namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableConfiguration
    {
        public List<string> Views { get; set; }

        public string? DefaultView { get; set; }

        public SerializableConfiguration()
        {
            Views = new List<string>();
        }

        public SerializableConfiguration(List<string> views, string? defaultView)
        {
            Views = views;
            DefaultView = defaultView;
        }
    }
}
