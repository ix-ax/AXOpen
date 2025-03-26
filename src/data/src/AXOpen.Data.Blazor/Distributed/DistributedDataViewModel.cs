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

            if (predicates == null)
            {
                if (this.SelectedManagerVm != null)
                {
                    return SelectedManagerVm.FillObservableRecordsAsync();
                }
            }

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

        public async Task CreateNew(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Create error", "Please enter valid source identifier!", 20);
                return;
            }

            List<string> created = new List<string>();
            List<string> alreadyExistInDb = new List<string>();

            foreach (var exchange in DataFragments.DistinctBy(p => p.ManagerDataTypeName))
            {
                if (!exchange.Repository.Exists(identifier))
                {
                    var plain = Activator.CreateInstance(exchange.GetPlainTypes().First());

                    exchange.Repository.Create(identifier, plain);
                    created.Add(exchange.ManagerDataTypeName);
                }
                else
                {
                    alreadyExistInDb.Add(exchange.ManagerDataTypeName);
                }
            }

            if (created.Count > 0)
            {
                string createdRecords = string.Join(", ", created);
                AlertService?.AddAlertDialog(eAlertType.Info, "Create record", $"Data with ID: \"{identifier}\"  was created for: {createdRecords}!", 7);
            }

            if (alreadyExistInDb.Count > 0)
            {
                string notCreatedRecords = string.Join(", ", alreadyExistInDb);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Create record error", $"Record already exist for: {notCreatedRecords}!", 14);
            }
        }

        public async Task CreateNewFromPlc(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Create data error", "Please enter valid identifier!", 20);
                return;
            }

            List<string> Created = new List<string>();
            List<string> NotCreated = new List<string>();

            foreach (var exchange in DataFragments.DistinctBy(p => p.ManagerDataTypeName))
            {
                if (!exchange.Repository.Exists(identifier))
                {
                    await exchange.CreateDataFromControllerAsync(identifier, exchange.DataExchangeTwinObject);
                    Created.Add(exchange.ManagerDataTypeName);
                }
                else
                {
                    NotCreated.Add(exchange.ManagerDataTypeName);
                }
            }

            if (Created.Count > 0)
            {
                string createdRecords = string.Join(", ", Created);
                AlertService?.AddAlertDialog(eAlertType.Info, "Create record", $"Data with ID: \"{identifier}\"  was created for: {createdRecords}!", 7);
            }

            if (NotCreated.Count > 0)
            {
                string notCreatedRecords = string.Join(", ", NotCreated);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Create record error", $"Record already exist for: {notCreatedRecords}!", 14);
            }
        }

        public async Task UpdateFromPlc(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Update data error", "Please enter valid identifier!", 20);
                return;
            }

            List<string> updated = new List<string>();
            List<string> created = new List<string>();
            List<string> notSameIdInPlc = new List<string>();

            foreach (var exchange in DataFragments.DistinctBy(p => p.ManagerDataTypeName))
            {
                //TODO optimalize -> clone only EntityId
                var refdata = exchange.CloneDataObject();

                var DataEntityId = (refdata as IAxoDataEntity).DataEntityId;

                List<ITwinPrimitive> batchRedElements = new();

                batchRedElements.Add(DataEntityId);

                await refdata.GetConnector().ReadBatchAsync(batchRedElements);

                if (DataEntityId.Cyclic != identifier)
                {
                    notSameIdInPlc.Add(exchange.ManagerDataTypeName);
                    continue;
                }

                if (exchange.Repository.Exists(identifier))
                {
                    await exchange.RemoteUpdate(identifier);
                    updated.Add(exchange.ManagerDataTypeName);
                }
                else
                {
                    await exchange.RemoteCreate(identifier);
                    created.Add(exchange.ManagerDataTypeName);
                }

            }

            if (updated.Count > 0)
            {
                string updatedRecords = string.Join(", ", updated);
                AlertService?.AddAlertDialog(eAlertType.Info, "Update record", $"Data with ID: \"{identifier}\"  was created for: {updatedRecords}!", 7);
            }

            if (created.Count > 0)
            {
                string createdRecords = string.Join(", ", created);
                AlertService?.AddAlertDialog(eAlertType.Info, "Crete record", $"Data with ID: \"{identifier}\"  was created for: {createdRecords}!", 7);
            }

            if (notSameIdInPlc.Count > 0)
            {
                string notEqualEntityIds = string.Join(", ", notSameIdInPlc);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Update error", $"Online record has different ID that requested to update: {notEqualEntityIds}!", 14);
            }
        }

        public async Task CopyRecord(string identifier, string newIdentifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Copy error", "Please enter valid source identifier!", 20);
                return;
            }

            if (string.IsNullOrEmpty(newIdentifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Copy record error", "Data cannot be deleted. Please enter valid new identifier!", 20);
                return;
            }

            List<string> copied = new List<string>();
            List<string> notExist = new List<string>();
            List<string> alreadyExist = new List<string>();

            foreach (var exchange in DataFragments.DistinctBy(p => p.ManagerDataTypeName))
            {
                if (exchange.Repository.Exists(identifier))
                {
                    if (!exchange.Repository.Exists(newIdentifier))
                    {
                        var newPlain = exchange.Repository.Read(identifier);
                        (newPlain as dynamic).DataEntityId = newIdentifier;
                        exchange.Repository.Create(newIdentifier, newPlain);
                    }
                    else
                    {
                        alreadyExist.Add(exchange.ManagerDataTypeName);
                    }
                }
                else
                {
                    notExist.Add(exchange.ManagerDataTypeName);
                }
            }

            if (copied.Count > 0)
            {
                string createdRecords = string.Join(", ", copied);
                AlertService?.AddAlertDialog(eAlertType.Info, "Copied record", $"Data with ID: \"{identifier}\"  was created for: {createdRecords}!", 7);
            }

            if (alreadyExist.Count > 0)
            {
                string alreadyExistRecords = string.Join(", ", alreadyExist);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Copied error", $"Record already exist for: {alreadyExistRecords}!", 14);
            }

            if (notExist.Count > 0)
            {
                string notExistRecords = string.Join(", ", notExist);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Copied error", $"Source Record not exist for: {notExistRecords}!", 14);
            }
        }

        public async Task DeleteRecord(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                AlertService?.AddAlertDialog(eAlertType.Warning, "Delete error", "Please enter valid source identifier!", 20);
                return;
            }

            List<string> notExist = new List<string>();
            List<string> deleted = new List<string>();

            foreach (var exchange in DataFragments.DistinctBy(p => p.ManagerDataTypeName))
            {
                if (exchange.Repository.Exists(identifier))
                {
                    exchange.Repository.Delete(identifier);
                    deleted.Add(exchange.ManagerDataTypeName);
                }
                else
                {
                    notExist.Add(exchange.ManagerDataTypeName);
                }
            }

            if (deleted.Count > 0)
            {
                string createdRecords = string.Join(", ", deleted);
                AlertService?.AddAlertDialog(eAlertType.Info, "Delete record", $"Data with ID: \"{identifier}\"  was deleted for: {createdRecords}!", 7);
            }
            if (notExist.Count > 0)
            {
                string notCreatedRecords = string.Join(", ", notExist);
                AlertService?.AddAlertDialog(eAlertType.Warning, "Delete error", $"Source Record not exist for: {notCreatedRecords}!", 14);
            }
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

                await SelectedManagerVm.FillObservableRecordsAsync();
            }
        }

        private void SelectCongiguration(IAxoDataExchange exchange)
        {
            if (ConfigurationService != null)
            {
                var c = ConfigurationService.GetConfigution(exchange.GetPlainTypes().First().FullName + ConfiguraionSuffix);

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
                if (InjectedEntities.Count > 0)
                {
                    ids = this.InjectedEntities
                      .Intersect(this.TransmitedEntities.Distinct())
                      .ToList();
                }
                else
                {
                    ids.AddRange(this.TransmitedEntities);
                    ids = ids.Distinct().ToList();
                }
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

        public IEnumerable<string> GetFromFirstExchageExistingIds()
        {
            List<string> Entities = DataFragments.First().GetEntityIds(new PredicateContainer()).ToList();
            return Entities;
        }
    }
}