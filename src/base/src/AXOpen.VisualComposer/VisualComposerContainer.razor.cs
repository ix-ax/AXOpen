using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using Newtonsoft.Json.Linq;
using System.Diagnostics;
using System.Xml.Linq;
using System.Drawing;
using static System.Net.Mime.MediaTypeNames;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer : IDisposable
    {
        [Inject]
        NavigationManager NavigationManager { get; set; }

        [Parameter]
        public ITwinObject[] Objects { get; set; }

        [Parameter]
        public bool ModalDetailView { get; set; } = true;

        [Parameter, EditorRequired]
        public string? Id { get; set; }

        [Inject]
        protected IJSRuntime js { get; set; }

        private FileWriterBuffer<SerializableObject> _fileWriterBuffer = new FileWriterBuffer<SerializableObject>();

        //SerializableObject
        public double BackgroundWidth { get; set; } = 0;
        public double BackgroundHeight { get; set; } = 0;
        public string? ImgSrc { get; set; }
        public string BackgroundColor { get; set; } = "#FFFFFF";

        public string BackgroundSVGInput { get; set; } = "";

        public string Theme { get; set; } = "";

        public double Scale { get; set; } = 1;
        public double TranslateX { get; set; } = 0;
        public double TranslateY { get; set; } = 0;

        //SerializableConfiguration
        public List<string> Views { get; set; } = new List<string>();

        public string? DefaultView { get; set; }

        public bool EditSVG { get; set; } = false;

        private Guid _backgroundId = Guid.NewGuid();

        private List<VisualComposerItemData> _children = new List<VisualComposerItemData>();
        private ITwinElement _detailsObject;

        public ZoomableContainer _zoomableContainer { get; set; }

        private IEnumerable<ITwinElement> _childrenOfAxoObject { get; set; }

        public string FileName { get; set; } = "";

        public string CurrentView { get; set; } = "";

        public Size ElementSize { get; set; } = new Size();
        public Size WindowSize { get; set; } = new Size();

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

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                _childrenOfAxoObject = Enumerable.Empty<ITwinElement>();
                foreach (ITwinObject obj in Objects)
                {
                    _childrenOfAxoObject = _childrenOfAxoObject.Concat(RetrieveKids(obj));
                }

                await LoadAsync(null);

                ElementSize = await GetElementSize(_backgroundId.ToString());
                WindowSize = await GetWindowSize();

                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerContainer.razor.js");
                await jsObject.InvokeVoidAsync("registerViewportChangeCallback", DotNetObjectReference.Create(this), "OnResize", _backgroundId.ToString());

                StateHasChanged();
            }
        }

        [JSInvokable]
        public void OnResize(Size windowSize, Size elementSize)
        {
            if (WindowSize == null || ElementSize == null || WindowSize.Width != windowSize.Width || WindowSize.Height != windowSize.Height || ElementSize.Width != elementSize.Width || ElementSize.Height != elementSize.Height)
            {
                WindowSize.Width = Math.Round(windowSize.Width);
                WindowSize.Height = Math.Round(windowSize.Height);

                ElementSize.Width = Math.Round(elementSize.Width);
                ElementSize.Height = Math.Round(elementSize.Height);

                StateHasChanged();
            }
        }

        private List<ITwinElement> RetrieveKids(ITwinObject parent)
        {
            List<ITwinElement> kids = new List<ITwinElement>();
            kids.Add(parent);

            foreach (var kid in parent.GetKids())
            {
                if (kid is ITwinObject tobj)
                {
                    kids.AddRange(RetrieveKids(tobj));
                }
                if (kid is ITwinPrimitive prim)
                {
                    kids.Add(prim);
                }
            }

            return kids;
        }

        public async Task AddChildrenAsync(ITwinElement item)
        {
            _children.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), item, item.Symbol.ModalIdHelper(), Guid.NewGuid()));

            StateHasChanged();

            await SaveAsync();
        }

        public async Task RemoveChildrenAsync(VisualComposerItemData item)
        {
            _children.Remove(item);

            StateHasChanged();

            await SaveAsync();
        }

        public async Task CreateNewAsync(string fileName)
        {
            if (fileName == "" || fileName == null)
                return;

            CurrentView = fileName;

            if (!Directory.Exists("VisualComposerSerialize/" + Id.CorrectFilePath()))
            {
                Directory.CreateDirectory("VisualComposerSerialize/" + Id.CorrectFilePath());
            }

            await Serializing.Serializing<SerializableObject>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", new SerializableObject(0, 0, null, "#FFFFFF", "", new List<SerializableVisualComposerItem>(), "text-dark", 1, 0, 0));

            await LoadAsync(fileName);
        }

        public async Task CreateCopyAsync(string fileName)
        {
            if (fileName == "" || fileName == null)
                return;

            CurrentView = fileName;

            if (!Directory.Exists("VisualComposerSerialize/" + Id.CorrectFilePath()))
            {
                Directory.CreateDirectory("VisualComposerSerialize/" + Id.CorrectFilePath());
            }

            await SaveAsync();

            await LoadAsync(fileName);
        }

        public async Task SaveAsync()
        {
            List<SerializableVisualComposerItem> serializableChildren = new List<SerializableVisualComposerItem>();
            foreach (var child in _children)
            {
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id, child.Left, child.Top, child.Transform.ToString(), child.Presentation, child.Width, child.Height, child.ZIndex, child.Scale, child.Roles, child.PresentationTemplate, child.Background, child.BackgroundColor));
            }

            await _fileWriterBuffer.AddToBufferAsync("VisualComposerSerialize/" +
                                                        Id.CorrectFilePath() + "/" +
                                                        CurrentView.CorrectFilePath() + ".json",
                                                     new SerializableObject(BackgroundWidth,
                                                        BackgroundHeight,
                                                        ImgSrc,
                                                        BackgroundColor,
                                                        BackgroundSVGInput,
                                                        serializableChildren,
                                                        Theme,
                                                        Scale,
                                                        TranslateX,
                                                        TranslateY));
        }

        public async Task LoadAsync(string? fileName)
        {
            SerializableConfiguration? deserializeConfiguration = await Serializing.Serializing<SerializableConfiguration>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json");

            if (deserializeConfiguration != null)
            {
                Views = deserializeConfiguration.Views;
                DefaultView = deserializeConfiguration.DefaultView;
            }

            if ((fileName is null || fileName == "") && (DefaultView != null && DefaultView != ""))
                fileName = DefaultView;

            if (fileName is null || fileName == "")
                return;

            SerializableObject? deserialize = await Serializing.Serializing<SerializableObject>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");

            if (deserialize != null)
            {
                BackgroundWidth = deserialize.BackgroundWidth;
                BackgroundHeight = deserialize.BackgroundHeight;
                ImgSrc = deserialize.ImgSrc;
                BackgroundColor = deserialize.BackgroundColor;
                BackgroundSVGInput = deserialize.BackgroundSVGInput;
                Theme = deserialize.Theme;

                _children.Clear();

                foreach (var item in deserialize.Items)
                {
                    var childObject = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper().ComputeSha256Hash() == item.Id);
                    if (childObject != null)
                    {
                        _children.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), childObject, childObject.Symbol.ModalIdHelper(), Guid.NewGuid(), item.Left, item.Top, Types.TransformType.FromString(item.Transform), item.Presentation, false, item.Width, item.Height, item.ZIndex, item.Scale, item.Roles, item.PresentationTemplate, item.Background, item.BackgroundColor));
                    }
                }

                if (_zoomableContainer != null)
                {
                    Scale = deserialize.Scale;
                    TranslateX = deserialize.TranslateX;
                    TranslateY = deserialize.TranslateY;
                }
            }

            CurrentView = fileName;

            StateHasChanged();
        }

        public async Task RemoveAsync(string fileName)
        {
            if (File.Exists("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json"))
            {
                File.Delete("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");
            }

            if (Views.Contains(fileName) || DefaultView == fileName)
            {
                if (Views.Contains(fileName))
                    Views.Remove(fileName);

                if (DefaultView == fileName)
                    DefaultView = null;

                await Serializing.Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", new SerializableConfiguration(Views, DefaultView));
            }

            if (CurrentView == fileName)
                CurrentView = DefaultView;

            await LoadAsync(CurrentView);
        }

        public async Task ChangeThemeAsync()
        {
            if (Theme == "text-dark")
                Theme = "text-light";
            else
                Theme = "text-dark";

            await SaveAsync();
        }

        public async Task ClearScaleAndTranslateAsync(string fileName)
        {
            SerializableObject? deserialize = await Serializing.Serializing<SerializableObject>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");

            if (deserialize != null)
            {
                deserialize.Scale = 1;
                deserialize.TranslateX = 0;
                deserialize.TranslateY = 0;

                await Serializing.Serializing<SerializableObject>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", deserialize);
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

            return files;
        }

        public List<(string file, double scale, double translateX, double translateY)> GetAllVisualComposerContainer()
        {
            List<(string, double, double, double)> data = new();
            foreach (var file in GetAllFiles())
            {
                SerializableObject? deserialize = Serializing.Serializing<SerializableObject>.Deserialize("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + file + ".json");

                if (deserialize != null)
                {
                    data.Add((file, deserialize.Scale, deserialize.TranslateX, deserialize.TranslateY));
                }
            }

            return data;
        }

        public async Task ChangeBaseViewsAsync(string fileName)
        {
            if (Views == null)
                Views = new();

            if (Views.Contains(fileName))
                Views.Remove(fileName);
            else
                Views.Add(fileName);

            await Serializing.Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", new SerializableConfiguration(Views, DefaultView));
        }

        public async Task ChangeDefaultViewAsync(string fileName)
        {
            DefaultView = fileName;

            await Serializing.Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", new SerializableConfiguration(Views, DefaultView));
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

                string newName = CurrentView + Path.GetExtension(e.File.Name);

                if (!Directory.Exists("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath()))
                    Directory.CreateDirectory("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath());

                await using FileStream fs = new("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath(), FileMode.Create);
                await e.File.OpenReadStream().CopyToAsync(fs);

                ImgSrc = "Images/VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath();

                var dimensions = await GetImageDimensions(ImgSrc);
                BackgroundWidth = dimensions.Width;
                BackgroundHeight = dimensions.Height;

                isFileImported = true;
            }
            catch (Exception ex)
            {
                ImgSrc = null;
            }

            isFileImporting = false;

            await SaveAsync();
        }

        private async Task<Size> GetImageDimensions(string filePath)
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerContainer.razor.js");
            return await jsObject.InvokeAsync<Size>("getImageDimensions", filePath);
        }

        private async Task<Size> GetElementSize(string id)
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerContainer.razor.js");
            return await jsObject.InvokeAsync<Size>("getElementSize", id);
        }

        private async Task<Size> GetWindowSize()
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerContainer.razor.js");
            return await jsObject.InvokeAsync<Size>("getWindowSize");
        }

        public class Size
        {
            public double Width { get; set; }
            public double Height { get; set; }
        }

        internal void AddZoomableContainer(ZoomableContainer zoomableContainer)
        {
            _zoomableContainer = zoomableContainer;
        }

        private async Task ShowModal(string id)
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerContainer.razor.js");
            await jsObject.InvokeVoidAsync("showModal", id);
        }


        private RenderableContentControl detailsRcc { get; set; }

        private bool DetailsVisibility { get; set; } = false;

        private string detailsPresentationType;

        public string DetailsPresentationType
        {
            get => detailsPresentationType;
            set
            {
                detailsPresentationType = value;
                detailsRcc.Presentation = value;
                this.StateHasChanged();
            }
        }

        private void ToggleDetailsVisibility()
        {
            DetailsVisibility = !DetailsVisibility;

            if (!DetailsVisibility)
            {
                detailsRcc.Presentation = "empty";
                detailsRcc.ForceRender();
                System.GC.Collect();
            }
            this.StateHasChanged();
        }

        public void UpdateDetails(ITwinElement element)
        {
            if (detailsRcc != null)
            {
                if (ModalDetailView)
                {
                    ShowModal("ModalDetailView-" + @Id.ModalIdHelper());
                }
                else
                {
                    DetailsVisibility = true;
                }

                this.StateHasChanged();
                detailsRcc.Context = element;
                detailsRcc?.ForceRender();
            }
        }

        private bool InDesignMode { get; set; }

        private void ToggleInDesignMode()
        {
            InDesignMode = !InDesignMode;
        }

        public void Dispose()
        {
            _fileWriterBuffer.Dispose();
        }
    }
}
