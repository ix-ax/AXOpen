using AngleSharp.Text;
using AXOpen.Base.Data.Query;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using System.Diagnostics.Metrics;
using System.Linq.Expressions;
using System.Text.Json;

namespace AXOpen.Data.Query
{
    public partial class DataExchangeQuery : IDisposable
    {
        [Parameter]
        public DataExchangeViewModel Vm { get; set; }

        [Inject]
        private ProtectedLocalStorage ProtectedLocalStorage { set; get; }

        public IAxoDataExchange exchange;
        public Guid ViewGuid { get; } = new Guid();

        public bool SymbolsWasInitialize { get; set; }

        protected override void OnInitialized()
        {
            exchange = (IAxoDataExchange)Vm.Model;
            SymbolsWasInitialize = false;
        }

        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            await InitializeSymbols();

            await LoadData();
        }

        protected Task InitializeSymbols()
        {
            Task initTask = Task.Run(() =>
            {
                bool addExternalPredicates = Vm.InjectedPredicateContainer != null && (Vm.InjectedPredicateContainer.PredicatesCount() > 0 || Vm.InjectedPredicateContainer.SortingCount() > 0);

                foreach (var rootType in exchange.GetPlainObjectType())
                {
                    var plainPathContainer = new PlainSymbolBuilder(rootType);

                    var s = plainPathContainer.GetSymbols();

                    Symbols.AddRange(s);

                    PlainBuilders.Add(plainPathContainer);


                    if (addExternalPredicates)
                    {
                        var extQueries = Vm.InjectedPredicateContainer.GetPredicates(rootType);

                        if (extQueries != null)
                        {
                            foreach (var query in extQueries)
                            {

                                this.InjectedQueries.Add($"{rootType.Name}: {query.ToString()}");
                            }
                        }

                        var extSorting = Vm.InjectedPredicateContainer.GetSorting(rootType);
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
        public int SymbolsQueryPage { set; get; }// displaing only selected page
        public int SymbolsQueryPageLimit { set; get; } = 5;// displaing only selected page

        private int MaxPage =>
       (int)(SymbolsQueryCount % SymbolsQueryPageLimit == 0 ? SymbolsQueryCount / SymbolsQueryPageLimit - 1 : SymbolsQueryCount / SymbolsQueryPageLimit);

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
                    _StorageKey = string.Join("-", Vm.DataExchange.GetPlainObjectType().Select(t => t.FullName));
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

        public List<QuerySymbolConfiguration> Queries { private set; get; } = new();
        public List<SortSymbolConfiguration> Sorting { private set; get; } = new();

        private async Task SetLimitAsync(int limit)
        {
            var oldLimit = SymbolsQueryPageLimit;
            SymbolsQueryPageLimit = limit;

            SymbolsQueryPage = SymbolsQueryPage * oldLimit / SymbolsQueryPageLimit;

            await FillObservableSymbols();
        }

        private async Task SetPageAsync(int page)
        {
            SymbolsQueryPage = page;
            await FillObservableSymbols();
        }

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

        private int Modulo(int x, int m)
        {
            if (m == 0) return 0; // avoid exception caused by % 0
            var r = x % m;
            return r < 0 ? r + m : r;
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
            this.Queries.Add(this.PlainBuilders.CreateNewQuerySymbol(symbol));
            return Task.FromResult(true);
        }

        public Task<bool> AddAllDisplayedToQuery()
        {
            foreach (var s in GetDisplaySymbols())
            {
                this.Queries.Add(this.PlainBuilders.CreateNewQuerySymbol(s));
            }
            return Task.FromResult(true);
        }

        public Task<bool> RemoveSymbolFromQuery(Guid trakSymbolId)
        {
            this.Queries.Remove(this.Queries.Where(p => p.TrackSymbolId == trakSymbolId).First());

            return Task.FromResult(true);
        }

        public Task<bool> RemoveSymbolFromSorting(Guid trakSymbolId)
        {
            this.Sorting.Remove(this.Sorting.Where(p => p.TrackSymbolId == trakSymbolId).First());

            return Task.FromResult(true);
        }

        public Task<bool> MoveQuerySymbolUp(Guid trackSymbolId)
        {
            var index = this.Queries.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index > 0) // Ensure it is not already at the top
            {
                var temp = this.Queries[index];
                this.Queries[index] = this.Queries[index - 1];
                this.Queries[index - 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> MoveQuerySymbolDown(Guid trackSymbolId)
        {
            var index = this.Queries.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index >= 0 && index < this.Queries.Count - 1) // Ensure it is not already at the bottom
            {
                var temp = this.Queries[index];
                this.Queries[index] = this.Queries[index + 1];
                this.Queries[index + 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> MoveSortingSymbolUp(Guid trackSymbolId)
        {
            var index = this.Sorting.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index > 0) // Ensure it is not already at the top
            {
                var temp = this.Sorting[index];
                this.Sorting[index] = this.Sorting[index - 1];
                this.Sorting[index - 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> MoveSortingSymbolDown(Guid trackSymbolId)
        {
            var index = this.Sorting.FindIndex(p => p.TrackSymbolId == trackSymbolId);
            if (index >= 0 && index < this.Sorting.Count - 1) // Ensure it is not already at the bottom
            {
                var temp = this.Sorting[index];
                this.Sorting[index] = this.Sorting[index + 1];
                this.Sorting[index + 1] = temp;
                return Task.FromResult(true);
            }
            return Task.FromResult(false); // No movement possible
        }

        public Task<bool> AddSymbolToSorting(string symbol)
        {
            this.Sorting.Add(this.PlainBuilders.CreateNewSortSymbol(symbol));
            return Task.FromResult(true);
        }

        public async Task ExecuteFilter()
        {
            PredicateContainer = null;
            PredicateContainer = new PredicateContainer();

            if (Vm.InjectedPredicateContainer != null)
            {
                PredicateContainer.AddPredicatesFrom(Vm.InjectedPredicateContainer);
            }

            foreach (var symbolConfig in this.Queries)
            {
                this.PredicateContainer.AddQuerySymbolToPredicates(PlainBuilders, symbolConfig);
            }

            foreach (var symbolSorting in this.Sorting)
            {
                this.PredicateContainer.AddSortSymbolToPredicates(PlainBuilders, symbolSorting);
            }

            await Vm.FillObservableRecordsAsync(PredicateContainer);

            if (Vm.StateHasChangedDelegate != null)
                Vm.StateHasChangedDelegate.Invoke();

            await SaveData();
        }

        public Task<bool> ClearFilter()
        {
            this.SymbolsQueryFilter = "";
            FilteredSymbols.Clear();

            return Task.FromResult(true);
        }

        private async Task SaveData()
        {
            try
            {
                var history = new SymbolQueryConfigHistory() { Queries = Queries, Sorting = Sorting, Modified = DateTime.Now, Name = DateTime.Now.ToString() };
                await ProtectedLocalStorage.SetAsync(this.StorageKey, history);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private async Task LoadData()
        {
            try
            {
                var existingConfig = await ProtectedLocalStorage.GetAsync<SymbolQueryConfigHistory>(this.StorageKey);

                if (existingConfig.Success)
                {
                    this.Queries.Clear();
                    this.Queries.AddRange(existingConfig.Value.Queries);

                    this.Sorting.Clear();
                    this.Sorting.AddRange(existingConfig.Value.Sorting);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void Dispose()
        {
            ;
        }
    }
}