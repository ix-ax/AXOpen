using AXOpen.Core;
using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System.Xml.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer
    {
        [Parameter]
        public AxoObject AxoObject { get; set; }

        [Parameter]
        public string? ImgSrc { get; set; }

        public string Id { get; set; }

        private Guid _imgId = Guid.NewGuid();

        private List<VisualComposerItem> _children = new();

        private IEnumerable<ITwinElement> _childrenOfAxoObject { get; set; }

        public string FileName { get; set; } = "";

        protected override void OnInitialized()
        {
            Id = AxoObject.HumanReadable.Replace(".", "_").Replace(" ", "_");
        }

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
            {
                _childrenOfAxoObject = AxoObject.GetChildren().Flatten(p => p.GetChildren()).ToList();
                _childrenOfAxoObject = _childrenOfAxoObject.Concat(AxoObject.RetrievePrimitives());

                Load();
            }
        }

        public void AddChildren(ITwinElement item)
        {
            _children.Add(new VisualComposerItem()
            {
                UniqueGuid = Guid.NewGuid(),
                TwinElement = item
            });

            StateHasChanged();
        }

        public void AddChildren(VisualComposerItem item)
        {
            if (!_children.Contains(item))
            {
                VisualComposerItem? find = _children.Find(p => p.UniqueGuid == item.UniqueGuid);
                if (find != null)
                    _children.Remove(find);

                _children.Add(item);
            }
        }

        public void RemoveChildren(VisualComposerItem item)
        {
            _children.Remove(_children.Find(p => p.UniqueGuid == item.UniqueGuid));

            StateHasChanged();
        }

        public void Save(string fileName = "Default")
        {
            foreach (char c in Path.GetInvalidFileNameChars().Concat(Path.GetInvalidPathChars()))
            {
                fileName = fileName.Replace(c, '_');
            }

            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.ratioImgX, child.ratioImgY, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex));
            }

            if (!Directory.Exists("VisualComposerSerialize/" + Id))
            {
                Directory.CreateDirectory("VisualComposerSerialize/" + Id);
            }

            Serializing.Serializing<SerializableVisualComposerItem>.Serialize("VisualComposerSerialize/" + Id + "/" + fileName + ".json", serializableChildren);
        }

        public void Load(string? fileName = "Default")
        {
            List<SerializableVisualComposerItem>? deserialize = Serializing.Serializing<SerializableVisualComposerItem>.Deserialize("VisualComposerSerialize/" + Id + "/" + fileName + ".json");

            if (deserialize != null)
            {
                _children.Clear();

                foreach (var item in deserialize)
                {
                    var a = _childrenOfAxoObject.FirstOrDefault(p => p.HumanReadable.Replace(".", "_").Replace(" ", "_") == item.Id);
                    _children.Add(new VisualComposerItem()
                    {
                        UniqueGuid = Guid.NewGuid(),
                        TwinElement = _childrenOfAxoObject.FirstOrDefault(p => p.HumanReadable.Replace(".", "_").Replace(" ", "_") == item.Id),
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

        public void Remove(string fileName)
        {
            if (File.Exists("VisualComposerSerialize/" + Id + "/" + fileName + ".json"))
            {
                File.Delete("VisualComposerSerialize/" + Id + "/" + fileName + ".json");
            }
        }

        public List<string> GetAllFiles()
        {
            List<string> files = new();

            if (!Directory.Exists("VisualComposerSerialize/" + Id))
                return files;

            try
            {
                Directory.GetFiles("VisualComposerSerialize/" + Id + "/", "*.json").ToList().ForEach(p => files.Add(Path.GetFileNameWithoutExtension(p)));
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }

            if (files.Contains("Default"))
            {
                // Move "Default" to the first position
                files.Remove("Default");
                files.Insert(0, "Default");
            }

            return files;
        }

        public string? SearchValue { get; set; } = null;
        public List<ITwinObject>? SearchResult { get; set; } = null;
        public void Search()
        {
            if (SearchValue is null || SearchValue == "")
            {
                SearchResult = null;
            }
            else
            {
                SearchResult = AxoObject.GetChildren().Flatten(p => p.GetChildren()).ToList().FindAll(p => p.HumanReadable.Contains(SearchValue, StringComparison.OrdinalIgnoreCase));
            }
        }

        public string? SearchValuePrimitive { get; set; } = null;
        public List<ITwinPrimitive>? SearchResultPrimitive { get; set; } = null;
        public void SearchPrimitive()
        {
            if (SearchValuePrimitive is null || SearchValuePrimitive == "")
            {
                SearchResult = null;
            }
            else
            {
                SearchResultPrimitive = AxoObject.RetrievePrimitives().ToList().FindAll(p => p.HumanReadable.Contains(SearchValuePrimitive));
            }
        }
    }
}
