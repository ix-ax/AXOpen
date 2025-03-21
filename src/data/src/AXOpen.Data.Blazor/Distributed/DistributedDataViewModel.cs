using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXOpen.Base.Dialogs;
using AXOpen.Data.Query;
using AXSharp.Connector;
using AXSharp.Presentation;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.Extensions.Configuration;
using Serilog.Core;
using System.Collections.Frozen;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;

namespace AXOpen.Data
{
    public partial class DistributedDataViewModel : IDataExchangeQueryViewModel
    {
        protected readonly IAlertService AlertService;

        protected readonly AuthenticationStateProvider Authentication;

        protected readonly IAxoDataExchangeConfigurationService ConfigurationService;

        protected readonly string ConfiguraionSuffix = "";

        public DistributedDataViewModel(
            IEnumerable<IAxoDataExchange> dataFragments,
            IAlertService alertService,
            AuthenticationStateProvider authentication,
            IAxoDataExchangeConfigurationService configuraionService,
            string configuraionSuffix = ""
            )
        {
            DataFragments = dataFragments;
            AlertService = alertService;
            Authentication = authentication;
            ConfigurationService = configuraionService;
            ConfiguraionSuffix = configuraionSuffix;
            InitializeViewModel(DataFragments.First());
        }

        #region IDataExchangeQueryViewModel

        private List<Type> _PlainerTypes;

        public IEnumerable<Type> GetPlainTypes()
        {
            if (_PlainerTypes == null)
            {
                _PlainerTypes = new List<Type>();

                if (DataFragments == null)
                {
                    _PlainerTypes = new List<Type>();
                }
                else
                {
                    foreach (var exchange in DataFragments)
                    {
                        _PlainerTypes.Add(exchange.GetPlainTypes().First());
                    }
                }
            }
            return _PlainerTypes;
        }

        public Task FillObservableRecordsAsync(PredicateContainer? predicates = null)
        {
            List<List<string>> fragmentEntities = new();

            Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
            {
                var ids = fragment.GetEntityIds(predicates).ToList();
                lock (fragmentEntities)
                {
                    fragmentEntities.Add(ids);
                }
            });

            List<string> commonEntities = fragmentEntities.Count > 1
                ? fragmentEntities.Skip(1)
                    .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                    {
                        common.IntersectWith(next);
                        return common;
                    })
                    .ToList()
                : fragmentEntities.FirstOrDefault() ?? new List<string>();

            LastFragmentQueryCount = commonEntities.Count;

            EnableInjectLocalIds = true;
            TransmitedEntities.Clear();
            TransmitedEntities.AddRange(commonEntities);

            if (this.SelectedManagerVm != null)
            {
                SelectedManagerVm.SetInjectedEntityIds(MergeInjectedEntities());
                return this.SelectedManagerVm.FillObservableRecordsAsync(predicates);
            }
            else
            {
                return Task.CompletedTask;
            }
        }

        internal Action StateHasChangedDelegate { get; set; }

        public void InvokeStateHasChanged()
        {
            if (this.StateHasChangedDelegate != null)
            {
                this.StateHasChangedDelegate.Invoke();
            }

            if (this.SelectedManagerVm != null)
            {
                this.SelectedManagerVm.InvokeStateHasChanged();
            }
        }

        #endregion IDataExchangeQueryViewModel

        public List<string> InjectedEntities { set; get; } = new();
        public List<string> FragmentFileredEntities { set; get; } = new();

        public List<string> TransmitedEntities { set; get; } = new();

        public bool EnableInjectLocalIds { get; private set; } = false;

        public bool EnableInjectedExternalIds { get; private set; } = true;

        public AxoDataExchangeConfiguration ExchangeConfig { get; set; } = new();

        public async Task CreateNewRecord(string identifier)
        {
            ;
        }


        public async Task SelectManager(IAxoDataExchange exchange)
        {
            this.TransmitedEntities.Clear();

            // collect previous filtered ids...
            if (SelectedManagerVm != null)
            {
                this.TransmitedEntities.AddRange(SelectedManagerVm.EntityIdsIntersected);
            }

            if (exchange != null)
            {
                InitializeViewModel(exchange);

                SelectedManagerVm.SetInjectedEntityIds(MergeInjectedEntities());

                await SelectedManagerVm.FillObservableRecordsAsync();
            }
        }

        private void SelectCongiguration(IAxoDataExchange exchange)
        {
            if (ConfigurationService != null)
            {
                var c = ConfigurationService.GetConfigution(exchange.GetPlainTypes().First().FullName + ConfiguraionSuffix );

                if (c != null)
                {
                    this.ExchangeConfig = c;
                }
                else
                    this.ExchangeConfig = new AxoDataExchangeConfiguration();
            }
        }


        protected void InitializeViewModel(IAxoDataExchange exchange)
        {
            if (this.SelectedManagerVm != null)
            {
                this.SelectedManagerVm = null;
            }

            SelectedManagerVm = new DataExchangeViewModel();
            SelectedManagerVm.AuthenticationProvider = Authentication;
            SelectedManagerVm.AlertDialogService = AlertService;

            SelectedManagerVm.Model = exchange;
            SelectedManagerVm.SetInjectedEntityIds(MergeInjectedEntities());

            SelectCongiguration(exchange);
        }

        protected List<string> MergeInjectedEntities()
        {
            var ids = new List<string>();

            if (this.EnableInjectedExternalIds && this.EnableInjectLocalIds)
            {
                ids = this.InjectedEntities
                  .Intersect(this.TransmitedEntities.Distinct())
                  .ToList();
            }
            else if (!this.EnableInjectedExternalIds && this.EnableInjectLocalIds)
            {
                ids.AddRange(this.TransmitedEntities);
                ids = ids.Distinct().ToList();
            }
            else if (this.EnableInjectedExternalIds && !this.EnableInjectLocalIds)
            {
                ids.AddRange(this.InjectedEntities);
                ids = ids.Distinct().ToList();
            }

            return ids;
        }

        public async Task TogleLocalEntityIdsInjection()
        {
            EnableInjectLocalIds = !EnableInjectLocalIds;
            await RefreshInjectedIds();
        }

        public async Task TogleExternalEntityIdsInjection()
        {
            EnableInjectedExternalIds = !EnableInjectedExternalIds;
            await RefreshInjectedIds();
        }

        public async Task RefreshInjectedIds()
        {
            SelectedManagerVm.ReadAllEntityIdsForConcatQuery = EnableInjectLocalIds;

            SelectedManagerVm.SetInjectedEntityIds(this.MergeInjectedEntities());

            await SelectedManagerVm.FillObservableRecordsAsync();
            SelectedManagerVm.InvokeStateHasChanged();
        }

        public DataExchangeViewModel SelectedManagerVm { get; set; }

        public int LastFragmentQueryCount { set; get; }

        public IEnumerable<IAxoDataExchange> DataFragments { get; private set; }
        public PredicateContainer InjectedPredicateContainer { set; get; }

        public Dictionary<string, List<IBrowsableDataObject>> GetRecords(PredicateContainer predicates,
            int limit, int skip)
        {
            List<List<string>> fragmentEntities = new();

            Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
            {
                var ids = fragment.GetEntityIds(predicates).ToList();
                lock (fragmentEntities)
                {
                    fragmentEntities.Add(ids);
                }
            });

            List<string> commonEntities = fragmentEntities.Count > 1
                ? fragmentEntities.Skip(1)
                    .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                    {
                        common.IntersectWith(next);
                        return common;
                    })
                    .ToList()
                : fragmentEntities.FirstOrDefault() ?? new List<string>();

            this.LastFragmentQueryCount = commonEntities.Count;

            var toFind = commonEntities.Skip(skip).Take(limit).ToList();

            var records = GetRecords(toFind).ToList();

            return new Dictionary<string, List<IBrowsableDataObject>>();
        }

        public Dictionary<string, List<IBrowsableDataObject>> GetRecords(IEnumerable<string> identifiers)
        {
            return new Dictionary<string, List<IBrowsableDataObject>>();
        }

        public IEnumerable<string> GetEntityIds(PredicateContainer predicates)
        {
            List<List<string>> fragmentEntities = new();

            Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
            {
                var ids = fragment.GetEntityIds(predicates).ToList();
                lock (fragmentEntities)
                {
                    fragmentEntities.Add(ids);
                }
            });

            List<string> commonEntities = fragmentEntities.Count > 1
                ? fragmentEntities.Skip(1)
                    .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                    {
                        common.IntersectWith(next);
                        return common;
                    })
                    .ToList()
                : fragmentEntities.FirstOrDefault() ?? new List<string>();

            this.LastFragmentQueryCount = commonEntities.Count;

            var toFind = commonEntities;

            this.LastFragmentQueryCount = commonEntities.Count();

            return commonEntities;
        }
    }
}