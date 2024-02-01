namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableConfiguration
    {
        public SerializableConfiguration(List<string> views)
        {
            Views = views;
        }
        public List<string> Views { get; set; }
    }
}
