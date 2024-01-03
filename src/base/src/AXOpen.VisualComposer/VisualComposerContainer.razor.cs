using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Web;
using System.Xml.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer
    {
        /// <summary>
        /// Gets or sets element for processing in a detailed view.
        /// </summary>
        public ITwinElement DetailsObject
        {
            get { return _detailsObject; }
            set => _detailsObject = value;
        }

        [Parameter]
        public ITwinObject[] Objects { get; set; }

        public string? ImgSrc { get; set; }

        [Parameter]
        public string? Id
        {
            get => _id?.ComputeSha256Hash();
            set => _id = value;
        }

        private Guid _imgId = Guid.NewGuid();

        private List<VisualComposerItem> _children = new();
        private string? _id;
        private ITwinElement _detailsObject;

        private IEnumerable<ITwinElement> _childrenOfAxoObject { get; set; }

        public string FileName { get; set; } = "";

        public string? CurrentTemplate { get; set; } = "Default";

        protected override void OnInitialized()
        {
            if (Id is null || Id == "")
            {
                Id = "";
                foreach (ITwinObject obj in Objects)
                {
                    Id += obj.Symbol.ModalIdHelper();
                }
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
                //StateHasChanged();
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

        public void Save(string? fileName = null)
        {
            if (fileName is null || fileName == "")
            {
                if (CurrentTemplate is null || CurrentTemplate == "")
                    fileName = "Default";
                else
                    fileName = CurrentTemplate;
            }
            else
            {
                CurrentTemplate = fileName;
            }

            foreach (char c in Path.GetInvalidFileNameChars().Concat(Path.GetInvalidPathChars()))
            {
                fileName = fileName.Replace(c, '_');
            }

            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.ratioImgX, child.ratioImgY, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex, child.Scale, child.Roles));
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
                    var a = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper().ComputeSha256Hash() == item.Id);
                    _children.Add(new VisualComposerItem()
                    {
                        UniqueGuid = Guid.NewGuid(),
                        TwinElement = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper().ComputeSha256Hash() == item.Id),
                        ratioImgX = item.RatioImgX,
                        ratioImgY = item.RatioImgY,
                        _transform = Types.TransformType.FromString(item.Transform),
                        _presentation = item.Presentation,
                        _width = item.Width,
                        _height = item.Height,
                        _zIndex = item.ZIndex,
                        _scale = item.Scale,
                        Roles = item.Roles
                    });
                }
            }

            CurrentTemplate = fileName;

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
                if (SearchResult == null)
                    SearchResult = new();
                else
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
                if (SearchResultPrimitive == null)
                    SearchResultPrimitive = new();
                else
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
                if (!Directory.Exists("wwwroot/Images/"))
                    Directory.CreateDirectory("wwwroot/Images/");

                string newName = CurrentTemplate + Path.GetExtension(e.File.Name);

                if (!Directory.Exists("wwwroot/Images/VisualComposerSerialize/" + Id))
                    Directory.CreateDirectory("wwwroot/Images/VisualComposerSerialize/" + Id);

                await using FileStream fs = new("wwwroot/Images/VisualComposerSerialize/" + Id + "/" + newName, FileMode.Create);
                await e.File.OpenReadStream().CopyToAsync(fs);

                ImgSrc = "Images/VisualComposerSerialize/" + Id + "/" + newName;

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
