﻿using AXOpen.VisualComposer.Serializing;
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

        [Inject]
        NavigationManager NavigationManager { get; set; }

        [Parameter]
        public ITwinObject[] Objects { get; set; }

        public string? ImgSrc { get; set; }
        public string? Theme { get; set; }

        [Parameter, EditorRequired]
        public string? Id { get; set; }

        private Guid _imgId = Guid.NewGuid();

        private List<VisualComposerItem> _children = new();
        private ITwinElement _detailsObject;

        public ZoomableContainer _zoomableContainer { get; set; }

        private IEnumerable<ITwinElement> _childrenOfAxoObject { get; set; }

        public string FileName { get; set; } = "";

        public string? CurrentTemplate { get; set; } = "Default";

        public List<string> ShowingTemplates { get; set; } = new List<string>();

        public bool AllowZoomingAndPanning { get; set; } = true;

        protected override void OnInitialized()
        {
            if (Id is null || Id == "")
            {
                Id = "";
                foreach (ITwinObject obj in Objects)
                {
                    Id += obj.Symbol;
                }

                Id = Id.ComputeSha256Hash();
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

        public async Task ReDragElement()
        {
            foreach (var child in _children)
            {
                await child.DragElement();
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

            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.Left, child.Top, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex, child.Scale, child.Roles, child.PresentationTemplate, child.Background));
            }

            if (!Directory.Exists("VisualComposerSerialize/" + Id.CorrectFilePath()))
            {
                Directory.CreateDirectory("VisualComposerSerialize/" + Id.CorrectFilePath());
            }

            Serializing.Serializing<SerializableObject>.Serialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", new SerializableObject(ImgSrc, serializableChildren, Theme, _zoomableContainer.Scale, _zoomableContainer.TranslateX, _zoomableContainer.TranslateY, AllowZoomingAndPanning));
        }

        public void Load(string? fileName = "Default")
        {
            SerializableObject? deserialize = Serializing.Serializing<SerializableObject>.Deserialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");

            if (deserialize != null)
            {
                ImgSrc = deserialize.ImgSrc;
                Theme = deserialize.Theme;

                _children.Clear();

                foreach (var item in deserialize.Items)
                {
                    var childObject = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper().ComputeSha256Hash() == item.Id);
                    if (childObject != null)
                    {
                        _children.Add(new VisualComposerItem()
                        {
                            UniqueGuid = Guid.NewGuid(),
                            TwinElement = childObject,
                            _left = item.Left,
                            _top = item.Top,
                            _transform = Types.TransformType.FromString(item.Transform),
                            _presentation = item.Presentation,
                            _width = item.Width,
                            _height = item.Height,
                            _zIndex = item.ZIndex,
                            _scale = item.Scale,
                            Roles = item.Roles,
                            _presentationTemplate = item.PresentationTemplate,
                            _background = item.Background
                        });
                    }
                }

                if (_zoomableContainer != null)
                {
                    _zoomableContainer.Scale = deserialize.Scale;
                    _zoomableContainer.TranslateX = deserialize.TranslateX;
                    _zoomableContainer.TranslateY = deserialize.TranslateY;
                    AllowZoomingAndPanning = deserialize.AllowZoomingAndPanning;

                    _zoomableContainer.SetDataInJS();
                }
            }

            CurrentTemplate = fileName;


            SerializableConfiguration? deserializeConfiguration = Serializing.Serializing<SerializableConfiguration>.Deserialize("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json");

            if(deserializeConfiguration != null)
                ShowingTemplates = deserializeConfiguration.Templates;


            StateHasChanged();
        }

        public void Remove(string fileName)
        {
            if (File.Exists("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json"))
            {
                File.Delete("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");
            }

            if (ShowingTemplates.Contains(fileName))
            {
                ShowingTemplates.Remove(fileName);
                Serializing.Serializing<SerializableConfiguration>.Serialize("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", new SerializableConfiguration(ShowingTemplates));
            }
        }

        public void ChangeTheme()
        {
            if(Theme == "text-dark")
                Theme = "text-light";
            else
                Theme = "text-dark";
        }

        public void ClearScaleAndTranslate(string fileName)
        {
            SerializableObject? deserialize = Serializing.Serializing<SerializableObject>.Deserialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");

            if (deserialize != null)
            {
                deserialize.Scale = 1;
                deserialize.TranslateX = 0;
                deserialize.TranslateY = 0;

                Serializing.Serializing<SerializableObject>.Serialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", deserialize);
            }

            NavigationManager.NavigateTo(NavigationManager.Uri, forceLoad: true);
        }

        public List<string> GetAllFiles()
        {
            List<string> files = new();

            if (!Directory.Exists("VisualComposerSerialize/" + Id.CorrectFilePath()))
                return files;

            try
            {
                Directory.GetFiles("VisualComposerSerialize/" + Id.CorrectFilePath() + "/", "*.json").ToList().ForEach(p => files.Add(Path.GetFileNameWithoutExtension(p)));
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

        public List<(string file, double scale, int translateX, int translateY, bool allowZoomingAndPanning)> GetAllVisualComposerContainer()
        {
            List<(string, double, int, int, bool)> data = new();
            foreach (var file in GetAllFiles())
            {
                SerializableObject? deserialize = Serializing.Serializing<SerializableObject>.Deserialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + file + ".json");

                if (deserialize != null)
                {
                    data.Add((file, deserialize.Scale, deserialize.TranslateX, deserialize.TranslateY, deserialize.AllowZoomingAndPanning));
                }
            }

            return data;
        }

        public void ChangeShowingTemplateInConfiguration(string fileName)
        {
            if (ShowingTemplates == null)
                ShowingTemplates = new();

            if (ShowingTemplates.Contains(fileName))
                ShowingTemplates.Remove(fileName);
            else
                ShowingTemplates.Add(fileName);

            Serializing.Serializing<SerializableConfiguration>.Serialize("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", new SerializableConfiguration(ShowingTemplates));
        }

        public void ChangeAllowZoomingAndPanning(string fileName)
        {
            SerializableObject? deserialize = Serializing.Serializing<SerializableObject>.Deserialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");

            if (deserialize != null)
            {
                deserialize.AllowZoomingAndPanning = !deserialize.AllowZoomingAndPanning;

                Serializing.Serializing<SerializableObject>.Serialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", deserialize);
            }
        }

        public string? SearchValue { get; set; } = null;
        public List<ITwinElement>? SearchResult { get; set; } = null;
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
                    SearchResult.AddRange(obj.RetrievePrimitives().ToList().FindAll(p => p.Symbol.Contains(SearchValue, StringComparison.OrdinalIgnoreCase)));
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

                if (!Directory.Exists("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath()))
                    Directory.CreateDirectory("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath());

                await using FileStream fs = new("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath(), FileMode.Create);
                await e.File.OpenReadStream().CopyToAsync(fs);

                ImgSrc = "Images/VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath();

                isFileImported = true;
            }
            catch (Exception ex)
            {
                ImgSrc = null;
            }

            isFileImporting = false;
        }

        internal void AddZoomableContainer(ZoomableContainer zoomableContainer)
        {
            _zoomableContainer = zoomableContainer;
        }
    }
}
