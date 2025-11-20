using AngleSharp.Dom;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using Operon.Components;
using System.Text.RegularExpressions;

namespace AXOpen.VisualComposer.Components
{
    public partial class VisualComposerContainer
    {
        [Parameter]
        public ITwinObject[] Objects { get; set; }

        [Parameter, EditorRequired]
        public string? Id { get; set; }

        [Inject]
        protected IJSRuntime js { get; set; }

        [Inject]
        private ProtectedLocalStorage _protectedLocalStorage { set; get; }

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

        public Size ElementSize { get; set; } = new Size();
        private Size _windowSize { get; set; } = new Size();

        private VisualComposerItemData _options { get; set; } = new();
        private bool _useOption { get; set; } = false;
        private bool _optionsMove { get; set; } = false;
        private int _optionsMoveDirection { get; set; } = 1; // 0 = none, 1 = bottom/col, 2 = right/row
        private double _optionsMoveBottom { get; set; } = 10;
        private double _optionsMoveRight { get; set; } = 15;
        private bool _customPresentation { get; set; } = false;

        // Watch table filtering and sorting
        private string? _watchTableFilter { get; set; } = null;
        private bool? _watchTableSortAscending { get; set; } = null;

        public bool IsDesign 
        {
            get { return _inDesignMode; }
        }

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
                _childrenOfObject = Enumerable.Empty<ITwinElement>();
                foreach (ITwinObject obj in Objects)
                {
                    _childrenOfObject = _childrenOfObject.Concat(RetrieveKids(obj));
                }

                await LoadMainAsync();

                ElementSize = await GetElementSize(_backgroundId.ToString());
                _windowSize = await GetWindowSize();

                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/Components/VisualComposerContainer.razor.js");
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

        internal async Task AddItemAsync(ITwinElement item)
        {
            if (_useOption)
            {
                _items.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), item, _options.Left, _options.Top, _options.Transform, _options.Presentation, _options.Width, _options.Height, _options.ZIndex, _options.Scale, _options.Roles, _options.PresentationTemplate, _options.Background, _options.BackgroundColor, _options.PollingInterval));

                if (_optionsMove)
                {
                    if(_optionsMoveDirection == 0) // none
                    {
                        _options.Left += _optionsMoveRight;
                        _options.Top += _optionsMoveBottom;
                    }
                    else if (_optionsMoveDirection == 1) // bottom/col
                    {
                        _options.Top += _optionsMoveBottom;
                        if (_options.Top >= 100)
                        {
                            _options.Left += _optionsMoveRight;
                            _options.Top = _options.Top % 100;
                        }
                    }
                    else if (_optionsMoveDirection == 2) // right/row
                    {
                        _options.Left += _optionsMoveRight;
                        if (_options.Left >= 100)
                        {
                            _options.Top += _optionsMoveBottom;
                            _options.Left = _options.Left % 100;
                        }
                    }
                }
            }
            else
            {
                _items.Add(new VisualComposerItemData(EventCallback.Factory.Create(this, StateHasChanged), EventCallback.Factory.Create(this, SaveAsync), item));
            }

            StateHasChanged();

            await SaveAsync();
        }

        internal async Task RemoveItemAsync(VisualComposerItemData item)
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

        private async Task CreateNewViewAsync(string name, SaveLocationType saveLocationType, bool isWatchTable)
        {
            if (string.IsNullOrEmpty(name))
                return;

            _currentViewName = name;

            CurrentView = new SerializableView();
            CurrentView.IsWatchTable = isWatchTable;

            if (saveLocationType == SaveLocationType.Server)
                _serverStorageAllViews.Add(name);
            else if(saveLocationType == SaveLocationType.Local)
                _localStorageData.Add(name, CurrentView);

            _items.Clear();

            await SaveAsync();
        }

        private async Task CreateCopyViewAsync(string name, SaveLocationType saveLocationType)
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

        private async Task RemoveViewAsync(string name)
        {
            if (string.IsNullOrEmpty(name))
                return;

            if (_serverStorageAllViews.Contains(name))
            {
                _serverStorageAllViews.Remove(name);

                if (File.Exists(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), name.CorrectFilePath() + ".json")))
                    File.Delete(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), name.CorrectFilePath() + ".json"));
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

                await Serializing<SerializableConfiguration>.SerializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath() + ".json"), _serverStorageConfiguration);
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

        internal async Task SaveAsync()
        {
            List<SerializableItem> data = _items.Select(p => new SerializableItem(p)).ToList();
            CurrentView.Items = data;

            if (_serverStorageAllViews.Contains(_currentViewName))
            {
                if (!Directory.Exists(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath())))
                    Directory.CreateDirectory(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath()));

                await Serializing<SerializableView>.SerializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), _currentViewName.CorrectFilePath() + ".json"), CurrentView);
            }
            else if(_localStorageData.ContainsKey(_currentViewName))
            {
                await LocalStorage<Dictionary<string, SerializableView>>.SaveAsync(_protectedLocalStorage, Id, _localStorageData);
            }
        }

        private async Task LoadMainAsync()
        {
            _serverStorageConfiguration = await Serializing<SerializableConfiguration>.DeserializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath() + ".json"));
            if (_serverStorageConfiguration == null)
                _serverStorageConfiguration = new SerializableConfiguration(new List<string>(), null);

            _serverStorageAllViews = GetAllFiles();

            _localStorageData = await LocalStorage<Dictionary<string, SerializableView>>.LoadAsync(_protectedLocalStorage, Id);
            if (_localStorageData == null)
                _localStorageData = new Dictionary<string, SerializableView>();

            if(_serverStorageConfiguration != null && _serverStorageConfiguration.DefaultView != null)
            {
                if (_serverStorageAllViews.Contains(_serverStorageConfiguration.DefaultView) || _localStorageData.ContainsKey(_serverStorageConfiguration.DefaultView))
                    await LoadAsync(_serverStorageConfiguration.DefaultView);
            }
        }

        private List<string> GetAllFiles()
        {
            List<string> files = new();

            if (!Directory.Exists(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath())))
                return files;

            try
            {
                Directory.GetFiles(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath()), "*.json").ToList().ForEach(p => files.Add(Path.GetFileNameWithoutExtension(p)));
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }

            return files;
        }

        private async Task LoadAsync(string view)
        {
            _currentViewName = view;

            if (string.IsNullOrEmpty(view))
                return;

            SerializableView? deserializedData = null;
            if (_serverStorageAllViews.Contains(view))
                deserializedData = await Serializing<SerializableView>.DeserializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), view.CorrectFilePath() + ".json"));
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

        private async Task ChangeThemeAsync()
        {
            if (CurrentView.Theme == "text-gray-900")
                CurrentView.Theme = "text-gray-100";
            else
                CurrentView.Theme = "text-gray-900";

            await SaveAsync();
        }

        private async Task ChangeSaveLocationAsync(ChangeEventArgs e, SaveLocationType oldType, string view)
        {
            var newSaveLocation = e.Value.ToString();
            if (oldType == SaveLocationType.Server && _serverStorageAllViews.Contains(view) && newSaveLocation == "Local")
            {
                // Read
                var deserializedData = await Serializing<SerializableView>.DeserializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), view.CorrectFilePath() + ".json"));

                // Remove
                _serverStorageAllViews.Remove(view);

                if (File.Exists(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), view.CorrectFilePath() + ".json")))
                    File.Delete(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), view.CorrectFilePath() + ".json"));

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
                    if (!Directory.Exists(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath())))
                        Directory.CreateDirectory(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath()));

                    await Serializing<SerializableView>.SerializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath(), view.CorrectFilePath() + ".json"), data);
                }
            }

            StateHasChanged();
        }

        private async Task ClearScaleAndTranslateAsync()
        {
            CurrentView.Scale = 1;
            CurrentView.TranslateX = 0;
            CurrentView.TranslateY = 0;

            await SaveAsync();
        }

        private async Task ChangeAllowZoomingAndPanningAsync()
        {
            CurrentView.AllowZoomingAndPanning = !CurrentView.AllowZoomingAndPanning;

            await SaveAsync();
        }

        private async Task ChangeBaseViewsAsync(string view)
        {
            if (_serverStorageConfiguration.Views.Contains(view))
                _serverStorageConfiguration.Views.Remove(view);
            else
                _serverStorageConfiguration.Views.Add(view);

            await Serializing<SerializableConfiguration>.SerializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath() + ".json"), _serverStorageConfiguration);
        }

        private async Task ChangeDefaultViewAsync(string view)
        {
            _serverStorageConfiguration.DefaultView = view;

            if (!_serverStorageConfiguration.Views.Contains(view))
                _serverStorageConfiguration.Views.Add(view);

            await Serializing<SerializableConfiguration>.SerializeAsync(Path.Combine(Settings.VisualComposerSerializeFolderPath, Id.CorrectFilePath() + ".json"), _serverStorageConfiguration);
        }

        private string? _searchValue { get; set; } = null;
        private List<ITwinElement>? _searchResult { get; set; } = null;
        private void Search()
        {
            if (_searchValue is null || _searchValue == "")
            {
                _searchResult = null;
                return;
            }

            if (_searchResult == null)
                _searchResult = new();
            else
                _searchResult.Clear();

            if (_searchValue[0] == '"' && _searchValue[_searchValue.Length - 1] == '"')
            {

                var searchValueTrimmed = _searchValue.Substring(1, _searchValue.Length - 2);

                var regex = new Regex(searchValueTrimmed, RegexOptions.IgnoreCase | RegexOptions.Compiled);

                foreach (ITwinObject obj in Objects)
                {
                    var flatChildren = obj.GetChildren().Flatten(p => p.GetChildren());
                    var primitives = obj.RetrievePrimitives();

                    var matchingChildren = flatChildren.Where(p => regex.IsMatch(p.Symbol));

                    var matchingPrimitives = primitives.Where(p => regex.IsMatch(p.Symbol));

                    _searchResult.AddRange(matchingChildren);
                    _searchResult.AddRange(matchingPrimitives);
                }
            }
            else
            {
                var searchTerms = _searchValue
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

                    _searchResult.AddRange(matchingChildren);
                    _searchResult.AddRange(matchingPrimitives);
                }
            }

            //foreach (ITwinObject obj in Objects)
            //{
            //    SearchResult.AddRange(obj.GetChildren().Flatten(p => p.GetChildren()).ToList().FindAll(p => p.Symbol.Contains(SearchValue, StringComparison.OrdinalIgnoreCase)));
            //    SearchResult.AddRange(obj.RetrievePrimitives().ToList().FindAll(p => p.Symbol.Contains(SearchValue, StringComparison.OrdinalIgnoreCase)));
            //}
        }

        private bool? _controllerObjectsSortAscending { get; set; } = null;

        private void ToggleControllerObjectsSort()
        {
            if (_controllerObjectsSortAscending == null)
                _controllerObjectsSortAscending = true;
            else if (_controllerObjectsSortAscending == true)
                _controllerObjectsSortAscending = false;
            else if (_controllerObjectsSortAscending == false)
                _controllerObjectsSortAscending = null;

            // Apply sorting
            if (_controllerObjectsSortAscending != null)
            {
                _searchResult = _controllerObjectsSortAscending == true ? _searchResult.OrderBy(item => item.Symbol ?? string.Empty).ToList() : _searchResult.OrderByDescending(item => item.Symbol ?? string.Empty).ToList();
            }
        }

        private bool _isFileImported { get; set; } = false;
        private bool _isFileImporting { get; set; } = false;

        private async Task UploadFile(InputFileChangeEventArgs e)
        {
            _isFileImported = false;
            _isFileImporting = true;

            try
            {
                if (!Directory.Exists(Settings.VisualComposerImagesSerializeFolderPath))
                    Directory.CreateDirectory(Settings.VisualComposerImagesSerializeFolderPath);

                string newName = _currentViewName + Path.GetExtension(e.File.Name);

                if (!Directory.Exists(Settings.VisualComposerImagesSerializeFolderPath + "/" + Id.CorrectFilePath()))
                    Directory.CreateDirectory(Settings.VisualComposerImagesSerializeFolderPath + "/" + Id.CorrectFilePath());

                await using FileStream fs = new(Settings.VisualComposerImagesSerializeFolderPath + "/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath(), FileMode.Create);
                await e.File.OpenReadStream().CopyToAsync(fs);

                CurrentView.ImgSrc = Settings.VisualComposerImagesSerializeName + "/" + Id.CorrectFilePath() + "/" + newName.CorrectFilePath();

                var dimensions = await GetImageDimensions(CurrentView.ImgSrc);
                CurrentView.BackgroundWidth = dimensions.Width;
                CurrentView.BackgroundHeight = dimensions.Height;

                _isFileImported = true;
            }
            catch (Exception ex)
            {
                CurrentView.ImgSrc = null;
            }

            _isFileImporting = false;

            await SaveAsync();
        }

        private async Task<Size> GetImageDimensions(string filePath)
        {
            try
            {
                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/Components/VisualComposerContainer.razor.js");
                return await jsObject.InvokeAsync<Size>("getImageDimensions", filePath);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return new Size { Width = 0, Height = 0 };
            }
        }

        private async Task<Size> GetElementSize(string id)
        {
            try
            {
                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/Components/VisualComposerContainer.razor.js");
                return await jsObject.InvokeAsync<Size>("getElementSize", id);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return new Size { Width = 0, Height = 0 };
            }
        }

        private async Task<Size> GetWindowSize()
        {
            try
            {
                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/Components/VisualComposerContainer.razor.js");
                return await jsObject.InvokeAsync<Size>("getWindowSize");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return new Size { Width = 0, Height = 0 };
            }
        }

        internal void AddZoomableContainer(ZoomableContainer zoomableContainer)
        {
            ZoomableContainer = zoomableContainer;
        }

        public Modal DetailsModalWindow { get; set; }

        public RenderFragment ModalHeaderContent { get; set; }

        public RenderFragment ModalBodyContent { get; set; }
        
        private RenderFragment RenderableContentControlFragment => builder =>
        {
            builder.OpenComponent<RenderableContentControl>(0);
            builder.AddAttribute(1, "Context", DetailsContext);
            builder.AddAttribute(2, "Presentation", DetailsPresentationType);
            builder.CloseComponent();
        };

        private ITwinElement DetailsContext { get; set; }
        private string DetailsPresentationType { get; set; }

        /// <summary>
        /// Sets the DetailsContext and opens the DetailsModalWindow
        /// </summary>
        /// <param name="element"></param>
        /// <param name="presentationType"></param>
        /// <returns></returns>
        public async Task OpenDetails(ITwinElement element, string presentationType = "Status-Display")
        {
            await Task.Run(() => {                
                DetailsContext = element;
                DetailsPresentationType = presentationType;
                DetailsModalWindow.Toggle();                
            });

            this.StateHasChanged();
        }

        public async Task OpenDetails(RenderFragment headerContent, RenderFragment bodyContent)
        {
            await Task.Run(() => {
                ModalHeaderContent = headerContent;
                ModalBodyContent = bodyContent;
                DetailsModalWindow.Toggle();
            });

            this.StateHasChanged();
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

        private string GetBgColor(SaveLocationType location)
        {
            if (location == SaveLocationType.Server)
                return "bg-purple-50";
            else if (location == SaveLocationType.Local)
                return "bg-cyan-50";
            return "";
        }

        private void ToggleSort()
        {
            if (_watchTableSortAscending == null)
                _watchTableSortAscending = true;
            else if (_watchTableSortAscending == true)
                _watchTableSortAscending = false;
            else if(_watchTableSortAscending == false)
                _watchTableSortAscending = null;
        }

        private IEnumerable<VisualComposerItemData> GetFilteredAndSortedItems()
        {
            var filtered = _items.AsEnumerable();

            // Apply filter
            if (!string.IsNullOrEmpty(_watchTableFilter))
            {
                filtered = filtered.Where(item => item.TwinElement?.Symbol?.Contains(_watchTableFilter, StringComparison.OrdinalIgnoreCase) == true);
            }

            // Apply sorting
            if (_watchTableSortAscending != null)
            {
                filtered = _watchTableSortAscending == true ? filtered.OrderBy(item => item.TwinElement?.Symbol ?? string.Empty) : filtered.OrderByDescending(item => item.TwinElement?.Symbol ?? string.Empty);
            }

            return filtered;
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