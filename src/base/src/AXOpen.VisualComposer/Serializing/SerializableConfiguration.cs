namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableConfiguration
    {
        public SerializableConfiguration(List<string> templates)
        {
            Templates = templates;
        }
        public List<string> Templates { get; set; }
    }
}
