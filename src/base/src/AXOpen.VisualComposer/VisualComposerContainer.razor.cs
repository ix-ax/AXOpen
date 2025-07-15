using AngleSharp.Dom;
using AXOpen.VisualComposer.Serializing;
using AXOpen.VisualComposer.Types;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.JSInterop;
using Newtonsoft.Json.Linq;
using Operon.Components;
using System.Buffers;
using System.Diagnostics;
using System.Drawing;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using static AXOpen.VisualComposer.VisualComposerContainer;
using static System.Net.Mime.MediaTypeNames;
using static System.Runtime.InteropServices.JavaScript.JSType;

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

        [Inject]
        private ProtectedLocalStorage _protectedLocalStorage { set; get; }

        private FileWriterBuffer<SerializableView> _fileWriterBuffer = new FileWriterBuffer<SerializableView>();

        private bool _editSVG { get; set; } = false;
        private bool _inDesignMode { get; set; } = false;
        private Guid _backgroundId { get; set; } = Guid.NewGuid();
        public ZoomableContainer ZoomableContainer { get; set; }

        private string _newViewName { get; set; } = "";
        private SaveLocationType _newViewSaveLocation { get; set; } = SaveLocationType.Server;
        private bool _isNewViewWatchTable { get; set; } = false;

        private IEnumerable<ITwinElement> _childrenOfObject { get; set; }
        private List<VisualComposerItemData> _items = new List<VisualComposerItemData>();

        private Dictionary<string, SerializableView> _localStorageData { get; set; } = new Dictionary<string, SerializableView>();

        private string? _currentViewName { get; set; } = "";
        public SerializableView CurrentView { get; set; } = new SerializableView();
        private SerializableConfiguration? _serverStorageConfiguration { get; set; }
        private List<string> _serverStorageAllViews { get; set; } = new List<string>();
        private const string SERVER_STORAGE_MAIN_DIR = "VisualComposerSerialize";

        public Size ElementSize { get; set; } = new Size();
        private Size _windowSize { get; set; } = new Size();

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
                _childrenOfObject = Enumerable.Empty<ITwinElement>();
                foreach (ITwinObject obj in Objects)
                {
                    _childrenOfObject = _childrenOfObject.Concat(RetrieveKids(obj));
                }

                await LoadMainAsync();

                ElementSize = await GetElementSize(_backgroundId.ToString());
                _windowSize = await GetWindowSize();

                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerContainer.razor.js");
                await jsObject.InvokeVoidAsync("registerViewportChangeCallback", DotNetObjectReference.Create(this), "OnResize", _backgroundId.ToString());

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

        [JSInvokable]
        public void OnResize(Size? windowSize, Size? elementSize)
        {
            if (windowSize == null || elementSize == null)
                return;

            if (_windowSize == null || ElementSize == null || _windowSize.Width != windowSize.Width || _windowSize.Height != windowSize.Height || ElementSize.Width != elementSize.Width || ElementSize.Height != elementSize.Height)
            {
                _windowSize.Width = Math.Round(windowSize.Width);
                _windowSize.Height = Math.Round(windowSize.Height);

                ElementSize.Width = Math.Round(elementSize.Width);
                ElementSize.Height = Math.Round(elementSize.Height);

                StateHasChanged();
            }
        }

        public async Task AddItemAsync(ITwinElement item)
        {
            _items.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), item));

            StateHasChanged();

            await SaveAsync();
        }

        public void AddItem(ITwinElement item, double left, double top, TransformType transform,
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
            _items.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), item, left, top, transform, presentation, width, height, zIndex, scale, roles, presentationTemplate, background, backgroundColor, pollingInterval));
        }

        public async Task RemoveItemAsync(VisualComposerItemData item)
        {
            _items.Remove(item);

            StateHasChanged();

            await SaveAsync();
        }

        private async Task MoveObjectUp(VisualComposerItemData item)
        {
            int index = _items.IndexOf(item);

            (_items[index - 1], _items[index]) = (_items[index], _items[index - 1]);

            await SaveAsync();
        }

        private async Task MoveObjectDown(VisualComposerItemData item)
        {
            int index = _items.IndexOf(item);

            (_items[index], _items[index + 1]) = (_items[index + 1], _items[index]);

            await SaveAsync();
        }

        public async Task CreateNewViewAsync(string name, SaveLocationType saveLocationType, bool isWatchTable)
        {
            if (string.IsNullOrEmpty(name))
                return;

            _currentViewName = name;

            CurrentView = new SerializableView
            {
                IsWatchTable = isWatchTable,
                BackgroundWidth = 1000,
                BackgroundHeight = 350,
                ImgSrc = null,
                BackgroundColor = "#EBF9EB",
                BackgroundSVGInput = "",
                Theme = "text-dark",
                Scale = 1,
                TranslateX = 0,
                TranslateY = 0,
                AllowZoomingAndPanning = true
            };

            if(saveLocationType == SaveLocationType.Server)
                _serverStorageAllViews.Add(name);
            else if(saveLocationType == SaveLocationType.Local)
                _localStorageData.Add(name, CurrentView);

            _items.Clear();

            await SaveAsync();
        }

        public async Task CreateCopyViewAsync(string name, SaveLocationType saveLocationType)
        {
            if (string.IsNullOrEmpty(name))
                return;

            var oldViewName = _currentViewName;

            _currentViewName = name;

            if (saveLocationType == SaveLocationType.Server)
                _serverStorageAllViews.Add(name);
            else if (saveLocationType == SaveLocationType.Local)
                _localStorageData.Add(name, CurrentView);

            await SaveAsync();
        }

        public async Task RemoveViewAsync(string name)
        {
            if (string.IsNullOrEmpty(name))
                return;

            if (_serverStorageAllViews.Contains(name))
            {
                _serverStorageAllViews.Remove(name);

                if (File.Exists("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + name.CorrectFilePath() + ".json"))
                    File.Delete("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + name.CorrectFilePath() + ".json");
            }
            else if (_localStorageData.ContainsKey(name))
            {
                _localStorageData.Remove(name);
                await LocalStorage<Dictionary<string, SerializableView>>.SaveAsync(_protectedLocalStorage, Id, _localStorageData);
            }

            if (_serverStorageConfiguration.Views.Contains(name) || _serverStorageConfiguration.DefaultView == name)
            {
                if (_serverStorageConfiguration.Views.Contains(name))
                    _serverStorageConfiguration.Views.Remove(name);

                if (_serverStorageConfiguration.DefaultView == name)
                    _serverStorageConfiguration.DefaultView = null;

                await Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", _serverStorageConfiguration);
            }

            if (_currentViewName == name)
            {
                if (_serverStorageConfiguration.DefaultView != null)
                    await LoadAsync(_serverStorageConfiguration.DefaultView);
                else if (_serverStorageConfiguration.Views.Any())
                    await LoadAsync(_serverStorageConfiguration.Views[0]);
                else if(_localStorageData.Any())
                    await LoadAsync(_localStorageData.First().Key);
                else
                    await LoadAsync("");
            }

            StateHasChanged();
        }

        public async Task SaveAsync()
        {
            List<SerializableItem> data = _items.Select(p => new SerializableItem(p)).ToList();
            CurrentView.Items = data;

            if (_serverStorageAllViews.Contains(_currentViewName))
            {
                if (!Directory.Exists("VisualComposerSerialize/" + Id.CorrectFilePath()))
                    Directory.CreateDirectory("VisualComposerSerialize/" + Id.CorrectFilePath());

                await _fileWriterBuffer.AddToBufferAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + _currentViewName.CorrectFilePath() + ".json", CurrentView);
            }
            else if(_localStorageData.ContainsKey(_currentViewName))
            {
                await LocalStorage<Dictionary<string, SerializableView>>.SaveAsync(_protectedLocalStorage, Id, _localStorageData);
            }
        }

        public async Task LoadMainAsync()
        {
            _serverStorageConfiguration = await Serializing<SerializableConfiguration>.DeserializeAsync(Path.Combine(SERVER_STORAGE_MAIN_DIR, Id.CorrectFilePath() + ".json"));
            if (_serverStorageConfiguration == null)
                _serverStorageConfiguration = new SerializableConfiguration(new List<string>(), null);

            _serverStorageAllViews = GetAllFiles();

            _localStorageData = await LocalStorage<Dictionary<string, SerializableView>>.LoadAsync(_protectedLocalStorage, Id);
            if (_localStorageData == null)
                _localStorageData = new Dictionary<string, SerializableView>();
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

        public async Task LoadAsync(string view)
        {
            _currentViewName = view;

            if (string.IsNullOrEmpty(view))
                return;

            SerializableView? deserializedData = null;
            if (_serverStorageAllViews.Contains(view))
                deserializedData = await Serializing<SerializableView>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + view.CorrectFilePath() + ".json");
            else if (_localStorageData.ContainsKey(view))
                deserializedData = _localStorageData[view];

            if (deserializedData != null)
            {
                CurrentView = deserializedData;

                _items = deserializedData.Items
                    .Select(item => new VisualComposerItemData(
                        EventCallback.Factory.Create(this, StateHasChanged),
                        EventCallback.Factory.Create(this, SaveAsync),
                        _childrenOfObject.FirstOrDefault(p => p.Symbol == item.Id),
                        item))
                    .Where(obj => obj.TwinElement != null)
                    .ToList();
            }

            StateHasChanged();
        }

        public async Task ChangeThemeAsync()
        {
            if (CurrentView.Theme == "text-gray-900")
                CurrentView.Theme = "text-gray-100";
            else
                CurrentView.Theme = "text-gray-900";

            await SaveAsync();
        }

        public async Task ChangeSaveLocationAsync(ChangeEventArgs e, SaveLocationType oldType, string view)
        {
            var newSaveLocation = e.Value.ToString();
            if (oldType == SaveLocationType.Server && _serverStorageAllViews.Contains(view) && newSaveLocation == "Local")
            {
                // Read
                var deserializedData = await Serializing<SerializableView>.DeserializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + view.CorrectFilePath() + ".json");

                // Remove
                _serverStorageAllViews.Remove(view);

                if (File.Exists("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + view.CorrectFilePath() + ".json"))
                    File.Delete("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + view.CorrectFilePath() + ".json");

                if(deserializedData != null)
                {
                    // Add
                    _localStorageData.Add(view, deserializedData);

                    //Save
                    await LocalStorage<Dictionary<string, SerializableView>>.SaveAsync(_protectedLocalStorage, Id, _localStorageData);
                }
            }
            else if (oldType == SaveLocationType.Local && _localStorageData.ContainsKey(view) && newSaveLocation == "Server")
            {
                // Read
                var data = _localStorageData.GetValueOrDefault(view);

                // Remove
                _localStorageData.Remove(view);
                await LocalStorage<Dictionary<string, SerializableView>>.SaveAsync(_protectedLocalStorage, Id, _localStorageData);

                if (data != null)
                {
                    // Add
                    _serverStorageAllViews.Add(view);

                    // Save
                    if (!Directory.Exists("VisualComposerSerialize/" + Id.CorrectFilePath()))
                        Directory.CreateDirectory("VisualComposerSerialize/" + Id.CorrectFilePath());

                    await _fileWriterBuffer.AddToBufferAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + view.CorrectFilePath() + ".json", data);
                }
            }

            StateHasChanged();
        }

        public async Task ClearScaleAndTranslateAsync()
        {
            CurrentView.Scale = 1;
            CurrentView.TranslateX = 0;
            CurrentView.TranslateY = 0;

            await SaveAsync();
        }

        public async Task ChangeAllowZoomingAndPanningAsync()
        {
            CurrentView.AllowZoomingAndPanning = !CurrentView.AllowZoomingAndPanning;

            await SaveAsync();
        }

        public async Task ChangeBaseViewsAsync(string view)
        {
            if (_serverStorageConfiguration.Views.Contains(view))
                _serverStorageConfiguration.Views.Remove(view);
            else
                _serverStorageConfiguration.Views.Add(view);

            await Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", _serverStorageConfiguration);
        }

        public async Task ChangeDefaultViewAsync(string view)
        {
            _serverStorageConfiguration.DefaultView = view;

            if (!_serverStorageConfiguration.Views.Contains(view))
                _serverStorageConfiguration.Views.Add(view);

            await Serializing<SerializableConfiguration>.SerializeAsync("VisualComposerSerialize/" + Id.CorrectFilePath() + ".json", _serverStorageConfiguration);
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

                var searchValueTrimmed = SearchValue.Substring(1, SearchValue.Length - 2);

                var regex = new Regex(searchValueTrimmed, RegexOptions.IgnoreCase | RegexOptions.Compiled);

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

                string newName = _currentViewName + Path.GetExtension(e.File.Name);

                if (!Directory.Exists("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath()))
                    Directory.CreateDirectory("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath());

                await using FileStream fs = new("wwwroot/Images/VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath(), FileMode.Create);
                await e.File.OpenReadStream().CopyToAsync(fs);

                CurrentView.ImgSrc = "Images/VisualComposerSerialize/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath();

                var dimensions = await GetImageDimensions(CurrentView.ImgSrc);
                CurrentView.BackgroundWidth = dimensions.Width;
                CurrentView.BackgroundHeight = dimensions.Height;

                isFileImported = true;
            }
            catch (Exception ex)
            {
                CurrentView.ImgSrc = null;
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

        internal void AddZoomableContainer(ZoomableContainer zoomableContainer)
        {
            ZoomableContainer = zoomableContainer;
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

        private void Move(PointerEventArgs eventArgs)
        {
            foreach (var item in _items)
            {
                if (item.MoveEvent != null)
                    item.MoveEvent.Invoke(this, eventArgs);
            }
        }

        private void Leave(PointerEventArgs eventArgs)
        {
            foreach (var item in _items)
            {
                if (item.LeaveEvent != null)
                    item.LeaveEvent.Invoke(this, eventArgs);
            }
        }

        public string GetBgColor(SaveLocationType location)
        {
            if (location == SaveLocationType.Server)
                return "bg-purple-50";
            else if (location == SaveLocationType.Local)
                return "bg-cyan-50";
            return "";
        }

        public void Dispose()
        {
            _fileWriterBuffer.Dispose();
        }

        public class Size
        {
            public double Width { get; set; }
            public double Height { get; set; }
        }
        public enum SaveLocationType
        {
            Server,
            Local
        }
    }
}