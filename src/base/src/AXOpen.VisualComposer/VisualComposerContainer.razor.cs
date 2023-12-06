using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using System.Xml.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer
    {
        [Parameter]
        public ITwinObject[] Objects { get; set; }

        public string? ImgSrc { get; set; }

        public string Id { get; set; }

        private Guid _imgId = Guid.NewGuid();

        private List<VisualComposerItem> _children = new();

        private IEnumerable<ITwinElement> _childrenOfAxoObject { get; set; }

        public string FileName { get; set; } = "";

        protected override void OnInitialized()
        {
            Id = "";
            foreach(ITwinObject obj in Objects)
            {
                Id += obj.Symbol.ModalIdHelper();
            }
        }

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
            {
                _childrenOfAxoObject = Enumerable.Empty<ITwinElement>();
                foreach (ITwinObject obj in Objects)
                {
                    _childrenOfAxoObject = _childrenOfAxoObject.Concat(obj.GetChildren().Flatten(p => p.GetChildren()));
                    _childrenOfAxoObject = _childrenOfAxoObject.Concat(obj.RetrievePrimitives());
                }

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
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.ratioImgX, child.ratioImgY, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex, child.Roles));
            }

            if (!Directory.Exists("VisualComposerSerialize/" + Id))
            {
                Directory.CreateDirectory("VisualComposerSerialize/" + Id);
            }

            Serializing.Serializing<SerializableObject>.Serialize("VisualComposerSerialize/" + Id + "/" + fileName + ".json", new SerializableObject(ImgSrc, serializableChildren));
        }

        public void Load(string? fileName = "Default")
        {
            SerializableObject? deserialize = Serializing.Serializing<SerializableObject>.Deserialize("VisualComposerSerialize/" + Id + "/" + fileName + ".json");

            if (deserialize != null)
            {
                ImgSrc = deserialize.ImgSrc;
                _children.Clear();

                foreach (var item in deserialize.Items)
                {
                    var a = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper() == item.Id);
                    _children.Add(new VisualComposerItem()
                    {
                        UniqueGuid = Guid.NewGuid(),
                        TwinElement = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper() == item.Id),
                        ratioImgX = item.RatioImgX,
                        ratioImgY = item.RatioImgY,
                        Transform = Types.TransformType.FromString(item.Transform),
                        Presentation = item.Presentation,
                        Width = item.Width,
                        Height = item.Height,
                        ZIndex = item.ZIndex,
                        Roles = item.Roles
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
                SearchResult.Clear();
                foreach (ITwinObject obj in Objects)
                {
                    SearchResult.AddRange(obj.GetChildren().Flatten(p => p.GetChildren()).ToList().FindAll(p => p.Symbol.Contains(SearchValue, StringComparison.OrdinalIgnoreCase)));
                }
            }
        }

        public string? SearchValuePrimitive { get; set; } = null;
        public List<ITwinPrimitive>? SearchResultPrimitive { get; set; } = null;
        public void SearchPrimitive()
        {
            if (SearchValuePrimitive is null || SearchValuePrimitive == "")
            {
                SearchResultPrimitive = null;
            }
            else
            {
                SearchResultPrimitive.Clear();
                foreach (ITwinObject obj in Objects)
                {
                    SearchResultPrimitive.AddRange(obj.RetrievePrimitives().ToList().FindAll(p => p.Symbol.Contains(SearchValuePrimitive, StringComparison.OrdinalIgnoreCase)));
                }
            }
        }

        private bool isFileImported { get; set; } = false;
        private bool isFileImporting { get; set; } = false;

        private async Task UploadFile(InputFileChangeEventArgs e)
        {
            isFileImported = false;
            isFileImporting = true;

            try
            {
                if(!Directory.Exists("wwwroot/Images/"))
                    Directory.CreateDirectory("wwwroot/Images/");

                string newName = Guid.NewGuid().ToString() + Path.GetExtension(e.File.Name);

                await using FileStream fs = new("wwwroot/Images/" + newName, FileMode.Create);
                await e.File.OpenReadStream().CopyToAsync(fs);

                ImgSrc = "Images/" + newName;

                isFileImported = true;
            }
            catch (Exception ex)
            {
                ImgSrc = null;
            }

            isFileImporting = false;
        }
    }
}
