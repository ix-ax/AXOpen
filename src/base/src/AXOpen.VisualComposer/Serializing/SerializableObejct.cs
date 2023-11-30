namespace AXOpen.VisualComposer.Serializing
{
    internal class SerializableObject
    {
        public SerializableObject(string imgSrc, List<SerializableVisualComposerItem> items)
        {
            ImgSrc = imgSrc;
            Items = items;
        }

        public string ImgSrc { get; set; }
        public List<SerializableVisualComposerItem> Items { get; set; }
    }
}
