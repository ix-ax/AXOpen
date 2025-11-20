using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Connector;

namespace AXOpen.VisualComposer.Serializing
{
    public class SerializableItem
    {
        public string Id { get; set; }
        public double Left { get; set; }
        public double Top { get; set; }
        public string Transform { get; set; }
        public string Presentation { get; set; }
        public double Width { get; set; }
        public double Height { get; set; }
        public int ZIndex { get; set; }
        public double Scale { get; set; }
        public double Rotate { get; set; }
        public string Roles { get; set; }
        public string PresentationTemplate { get; set; }
        public bool Background { get; set; }
        public string BackgroundColor { get; set; }
        public int PollingInterval { get; set; }

        public SerializableItem()
        {
            
        }

        public SerializableItem(string id, 
            double left, 
            double top, 
            string transform, 
            string presentation, 
            double width, 
            double height, 
            int zIndex, 
            double scale,
            double rotate,
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
            Rotate = rotate;
            Roles = roles;
            PresentationTemplate = presentationTemplate;
            Background = background;
            BackgroundColor = backgroundColor;
            PollingInterval = pollingInterval;
        }

        public SerializableItem(VisualComposerItemData item)
        {
            Id = item.Id;
            Left = item.Left;
            Top = item.Top;
            Transform = item.Transform.ToString();
            Presentation = item.Presentation;
            Width = item.Width;
            Height = item.Height;
            ZIndex = item.ZIndex;
            Scale = item.Scale;
            Rotate = item.Rotate;
            Roles = item.Roles;
            PresentationTemplate = item.PresentationTemplate;
            Background = item.Background;
            BackgroundColor = item.BackgroundColor;
            PollingInterval = item.PollingInterval;
        }
    }
}
