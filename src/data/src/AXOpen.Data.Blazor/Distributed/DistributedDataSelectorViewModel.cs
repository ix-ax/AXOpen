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
    public partial class DistributedDataSelectorViewModel
    {
        protected volatile object _observableRecordsLock = new object();
        protected volatile object _fragmentEntityIdsLock = new object();
        protected volatile object _transmitedEntityIdsLock = new object();

        protected readonly IDistributedDataExchangeService distributedExchangeService;
        protected readonly IAlertService AlertService;
        protected readonly string ExchangeGroup;

        protected readonly PredicateContainer InjectedPredicateContainer;
        protected IEnumerable<IAxoDataExchange> RepresentativeExchanges { get; set; } // one per type
        public IEnumerable<IAxoDataExchange> AllExchanges { get; set; } // all
        public IAxoDataExchange MainExchange { get; private set; } // firs from group, main pivot

        public long LastFragmentQueryCount { get; set; }

        public List<string> EntityIdsTransmited { set; get; } = new();
        public List<string> EntityIdsIntersected { set; get; } = new();
        public List<string> EntityIdsLastQueryMainExchange { set; get; } = new();

        public int FilteredCount { get; set; }
        public int FilteredPage { get; set; } = 0;
        public int FilteredPageLimit { get; set; } = 5; // default value

        public ObservableCollection<IBrowsableDataObject> Records { get; set; } = new ObservableCollection<IBrowsableDataObject>();

        private QuerySymbolConfiguration _DefaulQueryDataEntityId;

        public QuerySymbolConfiguration DefaulQueryDataEntityId
        {
            get
            {
                if (_DefaulQueryDataEntityId == null)
                {
                    var poco = MainExchange.GetPlainTypes().First();
                    _DefaulQueryDataEntityId = new QuerySymbolConfiguration($"{poco.Name}.DataEntityId", typeof(string).FullName, "StartsWith", "", "");
                }

                return _DefaulQueryDataEntityId;
            }
        }

        private List<PlainSymbolBuilder> _PlainBuilders;

        public List<PlainSymbolBuilder> PlainBuilders
        {
            get
            {
                if (_PlainBuilders == null)
                {
                    _PlainBuilders = MainExchange.GetPlainTypes().Select(p => new PlainSymbolBuilder(p)).ToList();
                }

                return _PlainBuilders;
            }
        }

        public DistributedDataSelectorViewModel(IDistributedDataExchangeService distributedExchangeService, string exchangeGroup, IAlertService alertService, PredicateContainer injectePredicateContainer)
        {
            this.distributedExchangeService = distributedExchangeService;
            this.AlertService = alertService;
            this.InjectedPredicateContainer = injectePredicateContainer;
            this.ExchangeGroup = exchangeGroup;

            InitializeViewModel();
        }

        private void InitializeViewModel()
        {
            RepresentativeExchanges = distributedExchangeService.GetExchanges(this.ExchangeGroup, true);
            AllExchanges = distributedExchangeService.GetExchanges(this.ExchangeGroup, false);
            MainExchange = RepresentativeExchanges.First();

        }

        public PredicateContainer BuidDefaultPredicates()
        {
            try
            {
                PredicateContainer pc = new PredicateContainer();
                if (InjectedPredicateContainer != null) pc.AddPredicatesFrom(InjectedPredicateContainer);

                pc.AddQuerySymbolToPredicates(PlainBuilders, DefaulQueryDataEntityId);

                return pc;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public Task FillObservableRecordsAsync()
        {
            return Task.Run(() =>
            {
                PredicateContainer? predicates = BuidDefaultPredicates();

                List<List<string>> fragmentEntities = new();

                List<string> commonEntities = new();

                if (predicates != null)
                {
                    Parallel.ForEach(RepresentativeExchanges.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
                    {
                        var ids = fragment.GetEntityIds(predicates).ToList();

                        lock (_fragmentEntityIdsLock)
                        {
                            fragmentEntities.Add(ids);
                        }
                    });

                    commonEntities.AddRange(fragmentEntities.Count > 1
                         ? fragmentEntities.Skip(1)
                             .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                             {
                                 common.IntersectWith(next);
                                 return common;
                             })
                             .ToList()
                         : fragmentEntities.FirstOrDefault() ?? new List<string>()
                         );

                    LastFragmentQueryCount = commonEntities.Count;
                }

                lock (_transmitedEntityIdsLock)
                {
                    EntityIdsTransmited.Clear();
                    if (commonEntities.Count > 0)
                    {
                        EntityIdsTransmited.AddRange(commonEntities);
                    }
                }

                if (predicates == null)
                    predicates = new PredicateContainer();

                var res = this.Filter(predicates, FilteredPageLimit, FilteredPage * FilteredPageLimit);

            });
        }

        public virtual IEnumerable<IBrowsableDataObject> Filter(PredicateContainer predicates, int limit = 10, int skip = 0)
        {
            IEnumerable<IBrowsableDataObject> filtered = null;

            lock (_transmitedEntityIdsLock)
            {
                if (EntityIdsTransmited != null && EntityIdsTransmited.Count > 0)
                {
                    this.EntityIdsLastQueryMainExchange.Clear();
                    this.EntityIdsIntersected.Clear();

                    EntityIdsLastQueryMainExchange.AddRange(MainExchange.GetEntityIds(predicates).ToList());
                    EntityIdsIntersected.AddRange(EntityIdsTransmited.Intersect(EntityIdsLastQueryMainExchange).ToList());

                    this.FilteredCount = EntityIdsIntersected.Count;

                    var toFind = EntityIdsIntersected.Skip(skip).Take(limit).ToList();

                    filtered = MainExchange.GetRecords(toFind).ToList();
                }
                else
                {
                    this.EntityIdsLastQueryMainExchange.Clear();
                    this.EntityIdsIntersected.Clear();

                    FilteredCount = (int)this.MainExchange.Repository.FilteredCount(predicates);

                    filtered = this.MainExchange.GetRecords(predicates, limit, skip);
                }
            }

            lock (_observableRecordsLock)
            {
                Records.Clear();

                foreach (var item in filtered)
                {
                    this.Records.Add(item);
                }
            }

            return Records;
        }

        public async Task SendToPlc(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Update data error", "Please enter valid identifier!", 20);
                return;
            }

            List<string> sentToPlc = new List<string>();
            List<string> notExistInDb = new List<string>();

            foreach (var exchangeGroup in distributedExchangeService.GetExchanges(this.ExchangeGroup, false).GroupBy(p => p.GetPlainTypes().First().FullName))
            {
                if (!exchangeGroup.First().Repository.Exists(identifier))
                {
                    foreach (var exchange in exchangeGroup)
                    {
                        notExistInDb.Add(exchange.DataExchangeTwinObject.Symbol);
                    }
                    continue; // record not exist, continue
                }

                foreach (var exchange in exchangeGroup)
                {
                    await exchange.RemoteRead(identifier);
                    sentToPlc.Add(exchange.DataExchangeTwinObject.Symbol);
                }

            }

            if (sentToPlc.Count > 0)
            {
                string updatedRecords = string.Join(", ", sentToPlc);
                AlertService?.AddAlertDialog(eAlertType.Info, "Send record", $"Data with ID: \"{identifier}\"  was send for: {updatedRecords}!", 7);
            }

            if (notExistInDb.Count > 0)
            {
                string notEqualEntityIds = string.Join(", ", notExistInDb);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Send error", $"Rrecord has not exist in a Database for: {notEqualEntityIds}!", 14);
            }
        }

        public async Task ReadAllCurrentEntityIds()
        {
            foreach (var ExsOnConnector in AllExchanges.GroupBy(p => p.DataExchangeTwinObject.GetConnector()))
            {
                List<ITwinPrimitive> toRead = new();
                Connector connector = ExsOnConnector.First().DataExchangeTwinObject.GetConnector();

                if (connector is DummyConnector) // can block ui thredd if is not work
                    return;

                foreach (var exchange in ExsOnConnector)
                {
                    toRead.Add((exchange.DataExchangeTwinObject as IAxoDataEntity).DataEntityId);
                }

                await connector.ReadBatchAsync(toRead);
            }
        }

        public bool AllExchangesHasTheSameId()
        {
            if (MainExchange.DataExchangeTwinObject is not IAxoDataEntity mainEntity)
                return false;

            var mainId = mainEntity.DataEntityId.Cyclic;

            return !string.IsNullOrEmpty(mainId) &&
                   AllExchanges.All(ex =>
                       (ex.DataExchangeTwinObject as IAxoDataEntity)?.DataEntityId.Cyclic == mainId);
        }

    }
}