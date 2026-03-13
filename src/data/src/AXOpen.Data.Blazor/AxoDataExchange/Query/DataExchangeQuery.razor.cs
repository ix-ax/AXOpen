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
        private ProtectedLocalStorage ProtectedLocalStorage { get; set; }

        private bool RemovePrefixOfPresentableSymbolPath { get; set; }

        private string RemovedCommonSymbolPrefix { get; set; } = "";

        public List<PlainSymbolBuilder> PlainBuilders { get; private set; } = new List<PlainSymbolBuilder>();
        public List<Symbol> Symbols { get; private set; } = new();
        public QuerySortConfiguration CurrentQuery { get; set; } = new();
        public QuerySortHistory History { get; set; } = new();

        private string _SymbolsQueryFilter = "";

        public string SymbolsQueryFilter // string that contains the symbol
        {
            set
            {
                if (_SymbolsQueryFilter != value)
                {
                    _SymbolsQueryFilter = value;
                    PaginationSelected = 1;

                    _ = UpdateSymbolListAsync();
                }
            }

            get
            {
                return _SymbolsQueryFilter;
            }
        }

        protected int PaginationSelected { set; get; } = 1; // selected page
        protected int PaginationPageSize { set; get; } = 5;
        protected int PaginationCount { set; get; } // count of symbols last query


        public List<Symbol> FilteredSymbols { get; private set; } = new();

        private volatile object _DisplayedSymbolsLock = new object();

        private List<Symbol> _DisplayedSymbols = new();

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

        public PredicateContainer PredicateContainer { get; private set; } = new PredicateContainer();

        public List<string> InjectedQueries { get; private set; } = new();
        public List<string> InjectedSorting { get; private set; } = new();

       
        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            await InitializeSymbolsAsync();

            await LoadHistoryAsync();
        }

        protected Task InitializeSymbolsAsync()
        {
            Task initTask = Task.Run(() =>
            {
                bool addExternalPredicates = Exchange.InjectedPredicateContainer != null && (Exchange.InjectedPredicateContainer.PredicatesCount() > 0
                || Exchange.InjectedPredicateContainer.SortingCount() > 0);

                PlainBuilders = Exchange.GetPlainTypes().Select(t => new PlainSymbolBuilder(t)).ToList();

                RemovePrefixOfPresentableSymbolPath = (PlainBuilders.Count == 1);

                if (!RemovePrefixOfPresentableSymbolPath)
                    RemovedCommonSymbolPrefix = PlainBuilders.GetCommonPrefix();

                foreach (var builder in PlainBuilders)
                {
                    var rootType = builder.RootType;

                    foreach (var symbol in builder.GetSymbols())
                    {
                        SetPresentableSymbolPath(symbol);
                        Symbols.AddRange(symbol);
                    }

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
            });
            return initTask;
        }

        public async Task UpdateSymbolListAsync()
        {
            await FilterSymbolsAsync();
            this.StateHasChanged();
        }

        private async Task PageSizeAndSelectedChangedAsync(int pageSize, int selected)
        {
            PaginationPageSize = pageSize;
            PaginationSelected = selected;
            FillObservableSymbols();
        }

        public List<Symbol> GetDisplaySymbols()
        {
            var symbolList = new List<Symbol>();

            lock (_DisplayedSymbolsLock)
            {
                symbolList.AddRange(_DisplayedSymbols);
            }

            return symbolList;
        }
        private async Task FilterSymbolsAsync()
        {
            await InvokeAsync(() =>
            {
                var query = Symbols.Where(s => string.IsNullOrEmpty(SymbolsQueryFilter) || s.PresentablePath.Contains(SymbolsQueryFilter, StringComparison.OrdinalIgnoreCase)).ToList();
                PaginationCount = query.Count;
                FilteredSymbols = query;
            });

            FillObservableSymbols();
        }

        private void FillObservableSymbols()
        {
            lock (_DisplayedSymbolsLock)
            {
                _DisplayedSymbols.Clear();

                _DisplayedSymbols.AddRange(
                    FilteredSymbols.Skip((PaginationSelected - 1)
                    * PaginationPageSize).Take(PaginationPageSize));
            }
        }

        public Task<bool> AddSymbolToQuery(Symbol symbol)
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

        public Task<bool> RemoveSymbolFromQuery(Guid trackSymbolId)
        {
            CurrentQuery.Queries.Remove(CurrentQuery.Queries.Where(p => p.TrackSymbolId == trackSymbolId).First());

            return Task.FromResult(true);
        }

        public Task<bool> RemoveSymbolFromSorting(Guid trackSymbolId)
        {
            CurrentQuery.Sorting.Remove(CurrentQuery.Sorting.Where(p => p.TrackSymbolId == trackSymbolId).First());

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

        public Task<bool> AddSymbolToSorting(Symbol symbol)
        {
            CurrentQuery.Sorting.Add(this.PlainBuilders.CreateNewSortSymbol(symbol));
            return Task.FromResult(true);
        }

        public async Task ExecuteFilterAsync()
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

            await SaveHistoryAsync();
        }

        public Task<bool> ClearFilter()
        {
            this.SymbolsQueryFilter = "";
            FilteredSymbols.Clear();

            return Task.FromResult(true);
        }

        private async Task SaveHistoryAsync()
        {
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

        private async Task RemoveHistoryItemAsync()
        {
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
                        await LoadHistoryAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private void SelectHistoryItem(string name)
        {
            var newItem = History.Items.Where(t => t.Name == name).First();

            if (newItem != null)
            {
                this.CurrentQuery = newItem;
            }
        }

        private async Task LoadHistoryAsync()
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

                if (lastselected != null && lastselected.Any())
                {
                    CurrentQuery = lastselected.FirstOrDefault();
                }
                else
                {
                    if (History.Items.Any())
                        CurrentQuery = History.Items.Last();
                }
            }

            if (CurrentQuery == null) CurrentQuery = new();

            foreach (var item in CurrentQuery.Queries)
            {
                SetPresentableSymbolPath(item);
            }
            foreach (var item in CurrentQuery.Sorting)
            {
                SetPresentableSymbolPath(item);
            }
        }

        internal void SetPresentableSymbolPath(Symbol symbol)
        {
            if (RemovePrefixOfPresentableSymbolPath)
                symbol.PresentablePath = symbol.SymbolPath;
            else
                symbol.PresentablePath = symbol.PresentablePath.Substring(RemovedCommonSymbolPrefix.Length).TrimStart(['.', '_']);
        }

        public void Dispose()
        {
            ;
        }
    }
}
