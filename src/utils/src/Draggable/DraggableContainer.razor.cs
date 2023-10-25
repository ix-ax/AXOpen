using Draggable.Serializing;
using Microsoft.AspNetCore.Components;
using System.Net;

namespace Draggable
{
    public partial class DraggableContainer
    {
        [Parameter]
        public RenderFragment? ChildContent { get; set; }

        [Parameter]
        public string? ImgSrc { get; set; }

        private Guid _imgId = Guid.NewGuid();

        private List<DraggableItem> _children = new List<DraggableItem>();

        private string filePath = "draggableSerialized.json";

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
                Load();
        }

        public void AddChild(DraggableItem child)
        {
            if (!_children.Contains(child))
                _children.Add(child);
        }

        public void Save()
        {
            List<SerializableDraggableItem> serializableChildren = new List<SerializableDraggableItem>();
            foreach (var child in _children)
            {
                if(child.ratioImgX == 10 && child.ratioImgY == 10 && !child.Show && child.Transform.Value == Types.TransformType.TopCenter.Value && child.Presentation.Value == Types.PresentationType.StatusDisplay.Value)
                    continue;

                serializableChildren.Add(new SerializableDraggableItem(child.Id, child.ratioImgX, child.ratioImgY, child.Show, child.Transform.ToString(), child.Presentation.ToString()));
            }

            Serializing.Serializing.Serialize(filePath, serializableChildren);
        }

        public void Load()
        {
            List<SerializableDraggableItem>? deserialize = Serializing.Serializing.Deserialize(filePath);

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
                        child.Presentation = Types.PresentationType.FromString(item.Presentation);
                    }
                }
            }
            StateHasChanged();
        }

        private void Check(DraggableItem draggableItem)
        {
            draggableItem.Show = !draggableItem.Show;
        }
    }
}
