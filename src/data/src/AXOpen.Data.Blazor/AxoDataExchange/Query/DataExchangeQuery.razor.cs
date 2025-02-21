using AXOpen.Base.Data.Query;
using Microsoft.AspNetCore.Components;
using System.Diagnostics.Metrics;

namespace AXOpen.Data.Query
{
    public partial class DataExchangeQuery : IDisposable
    {
        [Parameter]
        public DataExchangeViewModel Vm { get; set; }

        public IAxoDataExchange exchange;
        public Guid ViewGuid { get; } = new Guid();

        protected override void OnInitialized()
        {
            exchange = (IAxoDataExchange)Vm.Model;
            InitializeSymbols();
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

        public List<string> FilteredSymbols { private set; get; } = new List<string>(); // symbols for qery on selected pagge and display to te user

        private volatile object _displaySymbolLock = new object();

        private List<string> _DisplyedSymbols = new List<string>(); // symbols for qery on selected pagge and display to te user

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

        public List<QuerySymbolConfiguration> Queries { private set; get; } = new();

        protected void InitializeSymbols()
        {
            foreach (var rootType in exchange.GetPlainObjectType())
            {
                var plainPathContainer = new PlainSymbolBuilder(rootType);

                var s = plainPathContainer.GetSymbols();

                Symbols.AddRange(s);
                PlainBuilders.Add(plainPathContainer);
            }
        }

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
            this.Queries.Add(this.PlainBuilders.CreateNewConfiguration(symbol));

            return Task.FromResult(true);
        }

        public Task<bool> RemoveSymbolFromQuery(string symbol)
        {
            this.Queries.Remove(this.Queries.Where(p => p.SymbolPathWithParent == symbol).First());

            return Task.FromResult(true);
        }

        public async Task ExecuteFilter()
        {
            PredicateContainer = null;
            PredicateContainer = new PredicateContainer();

            foreach (var symbolConfig in this.Queries)
            {
                this.PredicateContainer.AddQuerySymbolToPredicates(PlainBuilders, symbolConfig);
            }

            await Vm.FillObservableRecordsAsync(PredicateContainer);

            if (Vm.StateHasChangedDelegate != null)
                Vm.StateHasChangedDelegate.Invoke();
        }

        public void Dispose()
        {
            ;
        }
    }
}