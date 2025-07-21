using AngleSharp.Text;
using AXOpen.Base.Data.Query;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.IO.Enumeration;
using System.Linq.Expressions;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Text.Json;

namespace AXOpen.Data.Query
{
    public partial class DataExchangeQuery : IDisposable
    {
        [Parameter]
        public IDataExchangeQueryViewModel Exchange { get; set; }

        [Inject]
        private ProtectedLocalStorage ProtectedLocalStorage { set; get; }

        public Guid ViewGuid { get; } = new Guid();

        public bool SymbolsWasInitialize { get; set; }

        public QuerySortHistory History { get; set; } = new();
        public QuerySortConfiguration CurrentQuery { get; set; } = new();

        protected override void OnInitialized()
        {
            SymbolsWasInitialize = false;
        }

        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            await InitializeSymbols();

            await LoadQueryHistoryData();
        }

        protected Task InitializeSymbols()
        {
            Task initTask = Task.Run(() =>
            {
                bool addExternalPredicates = Exchange.InjectedPredicateContainer != null && (Exchange.InjectedPredicateContainer.PredicatesCount() > 0
                || Exchange.InjectedPredicateContainer.SortingCount() > 0);

                foreach (var rootType in Exchange.GetPlainTypes())
                {
                    var plainPathContainer = new PlainSymbolBuilder(rootType);

                    var s = plainPathContainer.GetSymbols();

                    Symbols.AddRange(s);

                    PlainBuilders.Add(plainPathContainer);

                    if (addExternalPredicates)
                    {
                        var extQueries = Exchange.InjectedPredicateContainer.GetPredicates(rootType);

                        if (extQueries != null)
                        {
                            foreach (var query in extQueries)
                            {
                                this.InjectedQueries.Add($"{rootType.Name}: {query.ToString()}");
                            }
                        }

                        var extSorting = Exchange.InjectedPredicateContainer.GetSorting(rootType);
                        if (extSorting != null)
                        {
                            foreach (var sort in extSorting)
                            {
                                this.InjectedSorting.Add($"{rootType.Name}: {sort.ToString()}");
                            }
                        }
                    }
                }
                SymbolsWasInitialize = true;
            });
            return initTask;
        }

        public List<PlainSymbolBuilder> PlainBuilders { private set; get; } = new List<PlainSymbolBuilder>();
        public List<string> Symbols { private set; get; } = new List<string>();// whole available symbols

        private string _SymbolsQueryFilter = "";

        public string SymbolsQueryFilter // string that contains the symbol
        {
            set
            {
                if (_SymbolsQueryFilter != value)
                {
                    _SymbolsQueryFilter = value;
                    UpdateSymbolList();
                }
            }

            get
            {
                return _SymbolsQueryFilter;
            }
        }

        public async Task UpdateSymbolList()
        {
            await FilterSymbolsAsync();
            this.StateHasChanged();
        }

        public int SymbolsQueryCount { set; get; } // all symbols from query

        private int _symbolsQueryPage = 1;
        public int SymbolsQueryPage // displaing only selected page
        {
            set
            {
                _symbolsQueryPage = value;
                FilterSymbolsAsync();
            }
            get
            {
                return _symbolsQueryPage;
            }
        }

        private int _symbolsQueryPageLimit = 5;
        public int SymbolsQueryPageLimit // displaing only selected page
        {
            set
            {
                _symbolsQueryPageLimit = value;
                FilterSymbolsAsync();
            }
            get
            {
                return _symbolsQueryPageLimit;
            }
        }

        private async Task PageSizeAndSelectedChangedAsync(int pageSize, int selected)
        {
            SymbolsQueryPageLimit = pageSize;
            SymbolsQueryPage = selected;
            await FillObservableSymbols();
        }

        public List<string> FilteredSymbols { private set; get; } = new List<string>(); // symbols for qery on selected pagge and display to the user

        private volatile object _displaySymbolLock = new object();

        private List<string> _DisplyedSymbols = new List<string>(); // symbols for qery on selected pagge and display to te user

        private string _StorageKey;

        public string StorageKey
        {
            get
            {
                if (string.IsNullOrEmpty(_StorageKey))
                {
                    _StorageKey = string.Empty;

                    var joinName = string.Join("-", Exchange.GetPlainTypes().Select(t => t.FullName));

                    using (SHA1 sha1 = SHA1.Create()) // Use SHA-1 instead of SHA-256
                    {
                        byte[] bytes = Encoding.UTF8.GetBytes(joinName);
                        byte[] hashBytes = sha1.ComputeHash(bytes);

                        return BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
                    }
                }

                return _StorageKey;
            }
        }

        public List<string> GetDisplaySymbols()
        {
            var symbolList = new List<string>();

            lock (_displaySymbolLock)
            {
                symbolList.AddRange(_DisplyedSymbols);
            }

            return symbolList;
        }

        public PredicateContainer PredicateContainer { private set; get; } = new PredicateContainer();

        public List<string> InjectedQueries { private set; get; } = new();
        public List<string> InjectedSorting { private set; get; } = new();
        
        private Task FillObservableSymbols()
        {
            return Task.Run(() =>
            {
                _DisplyedSymbols.Clear();

                _DisplyedSymbols.AddRange(
                    FilteredSymbols.Skip(SymbolsQueryPage * SymbolsQueryPageLimit).Take(SymbolsQueryPageLimit)
                    );
            });
        }

        private async Task FilterSymbolsAsync()
        {
            await InvokeAsync(() =>
            {
                var query = Symbols.Where(s => string.IsNullOrEmpty(SymbolsQueryFilter) || s.Contains(SymbolsQueryFilter, StringComparison.OrdinalIgnoreCase)).ToList();
                SymbolsQueryCount = query.Count;
                FilteredSymbols = query;
            });

            await FillObservableSymbols();
        }

        public Task<bool> AddSymbolToQuery(string symbol)
        {
            var querySymbol = this.PlainBuilders.CreateNewQuerySymbol(symbol);

            if (querySymbol != null)
            {
                CurrentQuery.Queries.Add(querySymbol);
                return Task.FromResult(true);
            }

            return Task.FromResult(false);

        }

        public Task<bool> AddAllDisplayedToQuery()
        {
            foreach (var s in GetDisplaySymbols())
            {
                CurrentQuery.Queries.Add(this.PlainBuilders.CreateNewQuerySymbol(s));
            }
            return Task.FromResult(true);
        }

        public Task<bool> RemoveSymbolFromQuery(Guid trakSymbolId)
        {
            CurrentQuery.Queries.Remove(CurrentQuery.Queries.Where(p => p.TrackSymbolId == trakSymbolId).First());

            return Task.FromResult(true);
        }

        public Task<bool> RemoveSymbolFromSorting(Guid trakSymbolId)
        {
            CurrentQuery.Sorting.Remove(CurrentQuery.Sorting.Where(p => p.TrackSymbolId == trakSymbolId).First());

            return Task.FromResult(true);
        }

        public Task<bool> MoveQuerySymbolUp(Guid trackSymbolId)
        {
            var index = CurrentQuery.Queries.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index > 0) // Ensure it is not already at the top
            {
                var temp = CurrentQuery.Queries[index];
                CurrentQuery.Queries[index] = CurrentQuery.Queries[index - 1];
                CurrentQuery.Queries[index - 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> MoveQuerySymbolDown(Guid trackSymbolId)
        {
            var index = CurrentQuery.Queries.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index >= 0 && index < CurrentQuery.Queries.Count - 1) // Ensure it is not already at the bottom
            {
                var temp = CurrentQuery.Queries[index];
                CurrentQuery.Queries[index] = CurrentQuery.Queries[index + 1];
                CurrentQuery.Queries[index + 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> MoveSortingSymbolUp(Guid trackSymbolId)
        {
            var index = CurrentQuery.Sorting.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index > 0) // Ensure it is not already at the top
            {
                var temp = CurrentQuery.Sorting[index];
                CurrentQuery.Sorting[index] = CurrentQuery.Sorting[index - 1];
                CurrentQuery.Sorting[index - 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> MoveSortingSymbolDown(Guid trackSymbolId)
        {
            var index = CurrentQuery.Sorting.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index >= 0 && index < CurrentQuery.Sorting.Count - 1) // Ensure it is not already at the bottom
            {
                var temp = CurrentQuery.Sorting[index];
                CurrentQuery.Sorting[index] = CurrentQuery.Sorting[index + 1];
                CurrentQuery.Sorting[index + 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> AddSymbolToSorting(string symbol)
        {
            CurrentQuery.Sorting.Add(this.PlainBuilders.CreateNewSortSymbol(symbol));
            return Task.FromResult(true);
        }

        public async Task ExecuteFilter()
        {
            PredicateContainer = null;
            PredicateContainer = new PredicateContainer();

            if (Exchange.InjectedPredicateContainer != null)
            {
                PredicateContainer.AddPredicatesFrom(Exchange.InjectedPredicateContainer);
            }

            foreach (var symbolConfig in CurrentQuery.Queries)
            {
                this.PredicateContainer.AddQuerySymbolToPredicates(PlainBuilders, symbolConfig);
            }

            foreach (var symbolSorting in CurrentQuery.Sorting)
            {
                this.PredicateContainer.AddSortSymbolToPredicates(PlainBuilders, symbolSorting);
            }

            await Exchange.FillObservableRecordsAsync(PredicateContainer);

            Exchange.InvokeStateHasChanged();

            await UpdateQueryHistoryToStorage();
        }

        public Task<bool> ClearFilter()
        {
            this.SymbolsQueryFilter = "";
            FilteredSymbols.Clear();

            return Task.FromResult(true);
        }

        private async Task UpdateQueryHistoryToStorage()
        {
            var updatename = "";

            try
            {
                var existingConfig = await ProtectedLocalStorage.GetAsync<QuerySortHistory>(this.StorageKey);

                if (existingConfig.Success)
                {
                    History = existingConfig.Value;

                    var element = History.Items.Where(t => t.Name == CurrentQuery.Name).FirstOrDefault();

                    if (element != null)
                    {
                        History.Items.Remove(element);
                    }
                }

                CurrentQuery.Modified = DateTime.Now;

                if (string.IsNullOrEmpty(CurrentQuery.Name))
                    CurrentQuery.Name = CurrentQuery.Modified.ToString();

                History.Items.Add(CurrentQuery);
                History.LastSelectedItemName = CurrentQuery.Name;

                await ProtectedLocalStorage.SetAsync(this.StorageKey, History);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private async Task RemoveItemFromHistory()
        {
            var updatename = "";

            try
            {
                var existingConfig = await ProtectedLocalStorage.GetAsync<QuerySortHistory>(this.StorageKey);

                if (existingConfig.Success)
                {
                    History = existingConfig.Value;

                    var element = History.Items.Where(t => t.Name == CurrentQuery.Name).FirstOrDefault();

                    if (element != null)
                    {
                        History.Items.Remove(element);

                        await ProtectedLocalStorage.SetAsync(this.StorageKey, History);
                        await LoadQueryHistoryData();
                    }
                }

            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private void SelectlElementFromHistory(string name)
        {
            var newItem = History.Items.Where(t => t.Name == name).First();

            if (newItem != null)
            {
                this.CurrentQuery = newItem;
            }
        }

        private async Task LoadQueryHistoryData()
        {
            try
            {
                var existingConfig = await ProtectedLocalStorage.GetAsync<QuerySortHistory>(this.StorageKey);

                if (existingConfig.Success)
                {
                    this.History = existingConfig.Value;
                }
            }
            catch (Exception ex) // can be exception with deserialization -> configuration was changed
            {
                try
                {
                    await ProtectedLocalStorage.DeleteAsync(this.StorageKey);
                }
                catch (Exception exi)
                {
                    // swallow
                }
            }
            if (this.History == null) History = new QuerySortHistory();

            if (!string.IsNullOrEmpty(History.LastSelectedItemName))
            {
                var lastselected = History.Items.Where(h => h.Name == History.LastSelectedItemName);

                if (lastselected != null)
                {
                    CurrentQuery = lastselected.FirstOrDefault();
                }
            }

            if (CurrentQuery == null) CurrentQuery = new();

        }

        public void Dispose()
        {
            ;
        }
    }
}