using AngleSharp.Dom;
using AXOpen.VisualComposer.Serializing;
using AXOpen.VisualComposer.Types;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using Newtonsoft.Json.Linq;
using Operon.Components;
using System.Buffers;
using System.Diagnostics;
using System.Drawing;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using static System.Net.Mime.MediaTypeNames;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerContainer : IDisposable
    {
        [Parameter]
        public ITwinObject[] Objects { get; set; }

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

        public double TranslateX { get; set; } = 0;

        public double TranslateY { get; set; } = 0;

        public double Scale { get; set; } = 1;

        public bool AllowZoomingAndPanning { get; set; } = true;

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

            detailsRcc = new RenderableContentControl();
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
        public void OnResize(Size? windowSize, Size? elementSize)
        {
            if (windowSize == null || elementSize == null)
                return;

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

        public void AddChildren(ITwinElement item, double left, double top, TransformType transform,
            string presentation,
            double width,
            double height,
            int zIndex,
            double scale,
            string roles,
            string? presentationTemplate,
            bool background,
            string backgroundColor,
            int pollingInterval)
        {
            _children.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), item, item.Symbol.ModalIdHelper(),
                                                        Guid.NewGuid(), left, top, transform, presentation, width, height, zIndex, scale, roles, presentationTemplate, background, backgroundColor, pollingInterval));
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

            await Serializing.Serializing<SerializableObject>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", new SerializableObject(1000, 350, null, "#EBF9EB", "", new List<SerializableVisualComposerItem>(), "text-dark", 1, 0, 0, true));

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
                serializableChildren.Add(new SerializableVisualComposerItem(child.Id,
                    child.Left,
                    child.Top,
                    child.Transform.ToString(),
                    child.Presentation,
                    child.Width,
                    child.Height,
                    child.ZIndex,
                    child.Scale,
                    child.Roles,
                    child.PresentationTemplate,
                    child.Background,
                    child.BackgroundColor,
                    child.PollingInterval));
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
                                                        TranslateY,
                                                        AllowZoomingAndPanning));
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
                    var childObject = _childrenOfAxoObject.FirstOrDefault(p => p.Symbol.ModalIdHelper() == item.Id);
                    if (childObject != null)
                    {
                        _children.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged),
                            EventCallback.Factory.Create(this, SaveAsync),
                            childObject,
                            childObject.Symbol.ModalIdHelper(),
                            Guid.NewGuid(),
                            item.Left,
                            item.Top,
                            Types.TransformType.FromString(item.Transform),
                            item.Presentation,
                            item.Width,
                            item.Height,
                            item.ZIndex,
                            item.Scale,
                            item.Roles,
                            item.PresentationTemplate,
                            item.Background,
                            item.BackgroundColor,
                            item.PollingInterval));
                    }
                }

                Scale = deserialize.Scale;
                TranslateX = deserialize.TranslateX;
                TranslateY = deserialize.TranslateY;

                AllowZoomingAndPanning = deserialize.AllowZoomingAndPanning;
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
            if (Theme == "text-gray-900")
                Theme = "text-gray-100";
            else
                Theme = "text-gray-900";

            await SaveAsync();
        }

        public async Task ClearScaleAndTranslateAsync(string fileName)
        {
            if (fileName == CurrentView)
            {
                Scale = 1;
                TranslateX = 0;
                TranslateY = 0;

                await SaveAsync();
            }
            else
            {
                SerializableObject? deserialize = await Serializing.Serializing<SerializableObject>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");
                if (deserialize != null)
                {
                    deserialize.Scale = 1;
                    deserialize.TranslateX = 0;
                    deserialize.TranslateY = 0;

                    await _fileWriterBuffer.AddToBufferAsync(null, null);

                    await Serializing.Serializing<SerializableObject>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json", deserialize);
                }
            }

            //NavigationManager.NavigateTo(NavigationManager.Uri, forceLoad: true);
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

        public List<(string file, double scale, double translateX, double translateY, bool allowZoomingAndPanning)> GetAllVisualComposerContainer()
        {
            List<(string, double, double, double, bool)> data = new();
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

            if (!Views.Contains(fileName))
                Views.Add(fileName);

            await Serializing.Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", new SerializableConfiguration(Views, DefaultView));
        }

        public async Task ChangeAllowZoomingAndPanningAsync(string fileName)
        {
            SerializableObject? deserialize = await Serializing.Serializing<SerializableObject>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + fileName.CorrectFilePath() + ".json");

            if (deserialize != null)
            {
                deserialize.AllowZoomingAndPanning = !deserialize.AllowZoomingAndPanning;

                await _fileWriterBuffer.AddToBufferAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + CurrentView.CorrectFilePath() + ".json", deserialize);

                if (CurrentView == fileName)
                    AllowZoomingAndPanning = deserialize.AllowZoomingAndPanning;
            }
        }

        public string? SearchValue { get; set; } = null;
        public List<ITwinElement>? SearchResult { get; set; } = null;
        public void Search()
        {
            if (SearchValue is null || SearchValue == "")
            {
                SearchResult = null;
                return;
            }

            if (SearchResult == null)
                SearchResult = new();
            else
                SearchResult.Clear();

            if (SearchValue[0] == '"' && SearchValue[SearchValue.Length - 1] == '"')
            {
                var regex = new Regex(SearchValue, RegexOptions.IgnoreCase | RegexOptions.Compiled);

                foreach (ITwinObject obj in Objects)
                {
                    var flatChildren = obj.GetChildren().Flatten(p => p.GetChildren());
                    var primitives = obj.RetrievePrimitives();

                    var matchingChildren = flatChildren.Where(p => regex.IsMatch(p.Symbol));

                    var matchingPrimitives = primitives.Where(p => regex.IsMatch(p.Symbol));

                    SearchResult.AddRange(matchingChildren);
                    SearchResult.AddRange(matchingPrimitives);
                }
            }
            else
            {
                var searchTerms = SearchValue
                    .Split(new[] { '.', ' ' }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(term => term.Trim())
                    .ToList();

                foreach (ITwinObject obj in Objects)
                {
                    var flatChildren = obj.GetChildren().Flatten(p => p.GetChildren());
                    var primitives = obj.RetrievePrimitives();

                    var matchingChildren = flatChildren.Where(p =>
                        searchTerms.All(term =>
                            p.Symbol.Contains(term, StringComparison.OrdinalIgnoreCase)));

                    var matchingPrimitives = primitives.Where(p =>
                        searchTerms.All(term =>
                            p.Symbol.Contains(term, StringComparison.OrdinalIgnoreCase)));

                    SearchResult.AddRange(matchingChildren);
                    SearchResult.AddRange(matchingPrimitives);
                }
            }

            //foreach (ITwinObject obj in Objects)
            //{
            //    SearchResult.AddRange(obj.GetChildren().Flatten(p => p.GetChildren()).ToList().FindAll(p => p.Symbol.Contains(SearchValue, StringComparison.OrdinalIgnoreCase)));
            //    SearchResult.AddRange(obj.RetrievePrimitives().ToList().FindAll(p => p.Symbol.Contains(SearchValue, StringComparison.OrdinalIgnoreCase)));
            //}
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



        private RenderableContentControl detailsRcc { get; set; }

        public Modal DetailsModalWindow { get; set; }

        //private string detailsPresentationType;

        //public string DetailsPresentationType
        //{
        //    get => detailsPresentationType;
        //    set
        //    {
        //        detailsPresentationType = value;
        //        detailsRcc.Presentation = value;
        //        this.StateHasChanged();
        //    }
        //}

        private RenderFragment RenderableContentControlFragment => builder =>
        {
            builder.OpenComponent<RenderableContentControl>(0);
            builder.AddAttribute(1, "Context", detailsRcc.Context);
            builder.AddAttribute(2, "Presentation", detailsRcc.Presentation);
            builder.CloseComponent();
        };

        public async Task OpenDetails(ITwinElement element, string presentationType = "Status-Display")
        {
            DetailsModalWindow.Toggle();

            // Ensure the RenderableContentControl is rendered before interacting with it
            await InvokeAsync(() =>
            {
                if (detailsRcc != null)
                {
                    detailsRcc.Context = element;
                    detailsRcc.Presentation = presentationType;
                    detailsRcc.ForceRender();
                }
            });
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

        private void Move(PointerEventArgs eventArgs)
        {
            foreach (var child in _children)
            {
                if (child.MoveEvent != null)
                    child.MoveEvent.Invoke(this, eventArgs);
            }
        }

        private void Leave(PointerEventArgs eventArgs)
        {
            foreach (var child in _children)
            {
                if (child.LeaveEvent != null)
                    child.LeaveEvent.Invoke(this, eventArgs);
            }
        }
    }
}
