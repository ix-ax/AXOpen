using AXOpen.Core;
using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer
    {
        [Parameter]
        public AxoObject AxoObject { get; set; }

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

        private List<VisualComposerItem> _childrenToRender = new();
        private List<VisualComposerItem> _children = new();

        private IEnumerable<ITwinElement> _childrenOfAxoObject { get; set; }

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
            {
                _childrenOfAxoObject = AxoObject.GetChildren().Flatten(p => p.GetChildren()).ToList();
                //_childrenOfAxoObject.Concat(AxoObject.RetrievePrimitives());
                Load();
            }
        }

        public void AddChildrenToRender(ITwinElement item)
        {
            _childrenToRender.Clear();
            _childrenToRender.AddRange(_children);

            _childrenToRender.Add(new VisualComposerItem()
            {
                TwinElement = item
            });

            StateHasChanged();
        }

        public void AddChildren(VisualComposerItem item)
        {
            if(!_children.Contains(item))
                _children.Add(item);
        }

        public void RemoveChildren(VisualComposerItem item)
        {
            _children.Remove(item);

            _childrenToRender.Clear();
            _childrenToRender.AddRange(_children);

            StateHasChanged();
        }

        public void Save()
        {
            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.ratioImgX, child.ratioImgY, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex));
            }

            Serializing.Serializing.Serialize(Id + ".json", serializableChildren);

            _childrenToRender.Clear();
            _childrenToRender.AddRange(_children);
        }

        public void Load()
        {
            List<SerializableVisualComposerItem>? deserialize = Serializing.Serializing.Deserialize(Id + ".json");

            if (deserialize != null)
            {
                foreach (var item in deserialize)
                {
                    var a = _childrenOfAxoObject.FirstOrDefault(p => p.HumanReadable == item.Id);
                    _childrenToRender.Add(new VisualComposerItem()
                    {
                        TwinElement = _childrenOfAxoObject.FirstOrDefault(p => p.HumanReadable == item.Id),
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
    }
}
