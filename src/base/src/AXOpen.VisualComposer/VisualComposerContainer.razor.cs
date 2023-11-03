using AXOpen.VisualComposer.Serializing;
using Microsoft.AspNetCore.Components;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer
    {
        [Parameter]
        public RenderFragment? ChildContent { get; set; }

        [Parameter]
        public string? ImgSrc { get; set; }

        private string? _id;

        [Parameter]
        public string? Id
        {
            get => _id;
            set
            {
                _id = value?.Replace('.', '_');
            }
        }

        private Guid _imgId = Guid.NewGuid();

        private List<VisualComposerItem> _children = new();

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
                Load();
        }

        public void AddChild(VisualComposerItem child)
        {
            if (!_children.Contains(child))
                _children.Add(child);
        }

        public void Save()
        {
            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                if(child.ratioImgX == 10 && child.ratioImgY == 10 && !child.Show && child.Transform.Value == Types.TransformType.TopCenter.Value && child.Presentation == Types.PresentationType.StatusDisplay.Value)
                    continue;

                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.ratioImgX, child.ratioImgY, child.Show, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex));
            }

            Serializing.Serializing.Serialize(Id + ".json", serializableChildren);
        }

        public void Load()
        {
            List<SerializableVisualComposerItem>? deserialize = Serializing.Serializing.Deserialize(Id + ".json");

            if(deserialize != null)
            {
                foreach (var item in deserialize)
                {
                    var child = _children.Find(x => x.Id == item.Id);
                    if (child != null)
                    {
                        child.ratioImgX = item.RatioImgX;
                        child.ratioImgY = item.RatioImgY;
                        child.Show = item.Show;
                        child.Transform = Types.TransformType.FromString(item.Transform);
                        child.Presentation = item.Presentation;
                        child.Width = item.Width;
                        child.Height = item.Height;
                        child.ZIndex = item.ZIndex;
                    }
                }
            }
            StateHasChanged();
        }

        public static List<List<VisualComposerItem>> BuildHierarchy(List<VisualComposerItem> items, int level)
        {
            var result = new List<List<VisualComposerItem>>();

            foreach (var item in items)
            {
                string[] parts = item.Id.Split('.');
                if (level >= parts.Length)
                {
                    result.Add(new List<VisualComposerItem> { item });
                    continue;
                }

                string key = parts[level];
                int index = result.FindIndex(p => p.First().Id.Split('.')[level] == key);

                if (index == -1)
                {
                    result.Add(new List<VisualComposerItem> { item });
                }
                else
                {
                    result[index].Add(item);
                }
            }

            return result;
        }
    }
}
