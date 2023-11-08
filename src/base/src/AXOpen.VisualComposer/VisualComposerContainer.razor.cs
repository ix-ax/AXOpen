using AXOpen.Core;
using AXOpen.VisualComposer.Serializing;
using Microsoft.AspNetCore.Components;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer
    {
        [Parameter]
        public IEnumerable<AxoObject> AxoObjects { get; set; }

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
            _children.Add(child);
        }

        public void Save()
        {
            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.ratioImgX, child.ratioImgY, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex));
            }

            Serializing.Serializing.Serialize(Id + ".json", serializableChildren);
        }

        public void Load()
        {
            List<SerializableVisualComposerItem>? deserialize = Serializing.Serializing.Deserialize(Id + ".json");

            if (deserialize != null)
            {
                foreach (var item in deserialize)
                {
                    _children.Add(new VisualComposerItem()
                    {
                        AxoObject = AxoObjects.FirstOrDefault(p => p.HumanReadable == item.Id),
                        ratioImgX = item.RatioImgX,
                        ratioImgY = item.RatioImgY,
                        Transform = Types.TransformType.FromString(item.Transform),
                        Presentation = item.Presentation,
                        Width = item.Width,
                        Height = item.Height,
                        ZIndex = item.ZIndex
                    });
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
