using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXOpen.Base.Dialogs;
using AXOpen.Data.Interfaces;
using Microsoft.AspNetCore.Components.Authorization;
using Operon.Components.Toast;
using Properties = AXOpen.Data.Blazor.Properties;

namespace AXOpen.Data
{
    public partial class DistributedDataViewModel : IDataExchangeQueryViewModel, IDataExchangeGlobalActions
    {
        protected readonly AuthenticationStateProvider Authentication;

        protected readonly IToastService ToastService;
        protected readonly IDistributedDataExchangeService DistributedExchangeService;
        protected readonly IAxoDataExchangeConfigurationService ConfigurationService;

        protected readonly string GroupName = "";
        protected readonly bool DisplayOnePerDataType;
        protected readonly string ConfiguraionSuffix = "";

        public DistributedDataViewModel(
            IToastService toastService,
            AuthenticationStateProvider authentication,
            IDistributedDataExchangeService distributedExchangeService,
            IAxoDataExchangeConfigurationService configuraionService,
            string groupName,
            bool displayOnePerDataType,
            string configuraionSuffix,
             List<string>? injectedEntities,
             PredicateContainer? injectedPredicateContainer

            )
        {
            ToastService = toastService;
            Authentication = authentication;
            ConfigurationService = configuraionService;
            DistributedExchangeService = distributedExchangeService;
            GroupName = groupName;
            DisplayOnePerDataType = displayOnePerDataType;
            ConfiguraionSuffix = configuraionSuffix;

            if (injectedEntities != null) InjectedEntities = injectedEntities;

            InjectedPredicateContainer = injectedPredicateContainer;

            Exchanges = DistributedExchangeService.GetExchanges(this.GroupName, this.DisplayOnePerDataType);

            AllExchanges = DistributedExchangeService.GetExchanges(this.GroupName, false);

            DisplayedExchanges = displayOnePerDataType ? Exchanges : AllExchanges; // select for display

            if (InjectedPredicateContainer != null)
            {
                var idsFromPredicates = Exchanges.GetEntityIds(this.InjectedPredicateContainer);
                if (idsFromPredicates != null && idsFromPredicates.Count > 0)
                {
                    if (InjectedEntities == null)
                    {
                        injectedEntities = idsFromPredicates;
                    }
                    else
                    {
                        InjectedEntities.AddRange(idsFromPredicates);
                        InjectedEntities = InjectedEntities.Distinct().ToList();
                    }
                }
            }

            InitializeSelectedViewModel(Exchanges.First());
        }

        #region IDataExchangeQueryViewModel

        private List<Type> _PlainerTypes;

        public IEnumerable<Type> GetPlainTypes()
        {
            if (_PlainerTypes == null)
            {
                _PlainerTypes = new List<Type>();

                if (Exchanges == null)
                {
                    _PlainerTypes = new List<Type>();
                }
                else
                {
                    foreach (var exchange in Exchanges)
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

            if (InjectedPredicateContainer != null && this.EnableInjectedExternalIds) // merge predicates
                predicates.AddPredicatesFrom(InjectedPredicateContainer);

            List<string> commonEntities = Exchanges.GetEntityIds(predicates);
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

        public PredicateContainer InjectedPredicateContainer { set; get; }
        public List<string> InjectedEntities { set; get; } = new();

        public List<string> TransmitedEntities { set; get; } = new();

        public bool EnableInjectLocalIds { get; private set; } = false;

        public bool EnableInjectedExternalIds { get; private set; } = true;

        public AxoDataExchangeConfiguration ExchangeConfig { get; set; } = new();

        public DataExchangeViewModel SelectedManagerVm { get; set; }

        public int LastFragmentQueryCount { set; get; }

        public IEnumerable<IAxoDataExchange> DisplayedExchanges { get; private set; } // used for view

        /// <summary>
        /// Only one per data type
        /// </summary>
        public IEnumerable<IAxoDataExchange> Exchanges { get; private set; } // used for data managent

        /// <summary>
        /// All instances in a data manager group
        /// </summary>
        public IEnumerable<IAxoDataExchange> AllExchanges { get; private set; } // used for load to plc

        #region IDataExchangeGlogalActions

        public async Task Create(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Create_error, Properties.AxOpenDataResources.Please_enter_valid_source_identifier, 20);
                return;
            }

            List<string> created = new List<string>();
            List<string> alreadyExistInDb = new List<string>();

            foreach (var exchange in Exchanges)
            {
                if (!exchange.Repository.Exists(identifier))
                {
                    await exchange.CreateNewAsync(identifier, exchange.CloneDataObject());
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

                // Alert
                ToastService?.AddToast(
                    eToastType.Info,
                    Properties.AxOpenDataResources.Create_new_record,
                    $"Record \"{identifier}\" was created in repositories: {createdRecords}.",
                    7
                );

                // Log
                AxoApplication.Current.Logger.Information(
                    $"Created new record \"{identifier}\" in repositories: {createdRecords} by user action.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }

            if (alreadyExistInDb.Count > 0)
            {
                string notCreatedRecords = string.Join(", ", alreadyExistInDb);

                // Alert
                ToastService?.AddToast(
                    eToastType.Warning,
                    Properties.AxOpenDataResources.Create_record_error,
                    $"Record \"{identifier}\" already exists in repositories: {notCreatedRecords}.",
                    14
                );

                // Log
                AxoApplication.Current.Logger.Warning(
                    $"Creating record \"{identifier}\" by user action failed – already exists in repositories: {notCreatedRecords}.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }
        }

        public async Task CreateNewFromPlc(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Create_data_error, Properties.AxOpenDataResources.Please_enter_valid_identifier, 20);
                return;
            }

            List<string> Created = new List<string>();
            List<string> NotCreated = new List<string>();

            foreach (var exchange in Exchanges)
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

                // Alert
                ToastService?.AddToast(
                    eToastType.Info,
                    Properties.AxOpenDataResources.Create_record_from_PLC,
                    $"Record \"{identifier}\" was created in repositories: {createdRecords}.",
                    7
                );

                // Log
                AxoApplication.Current.Logger.Information(
                    $"Created record from PLC \"{identifier}\" in Axo: {createdRecords} by user action.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }

            if (NotCreated.Count > 0)
            {
                string notCreatedRecords = string.Join(", ", NotCreated);

                // Alert
                ToastService?.AddToast(
                    eToastType.Warning,
                    Properties.AxOpenDataResources.Create_record_error,
                    $"Record \"{identifier}\" already exists in repositories: {notCreatedRecords}.",
                    14
                );

                // Log
                AxoApplication.Current.Logger.Warning(
                    $"Creating record \"{identifier}\" by user action failed – already exists in repositories: {notCreatedRecords}.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }
        }

        //public async Task UpdateFromPlc(string identifier)
        //{
        //    if (string.IsNullOrEmpty(identifier))
        //    {
        //        AlertService?.AddToast(eToastType.Warning, "Update data error", "Please enter valid identifier!", 20);
        //        return;
        //    }

        //    List<string> updated = new List<string>();
        //    List<string> created = new List<string>();
        //    List<string> notSameIdInPlc = new List<string>();

        //    foreach (var exchange in DisplayedDataFragments.DistinctBy(p => p.ManagerDataTypeName))
        //    {
        //        //TODO optimalize -> clone only EntityId
        //        var refdata = exchange.CloneDataObject();

        //        var _EntityId = (refdata as IAxoDataEntity)._EntityId;

        //        List<ITwinPrimitive> batchRedElements = new();

        //        batchRedElements.Add(_EntityId);

        //        await refdata.GetConnector().ReadBatchAsync(batchRedElements);

        //        if (_EntityId.Cyclic != identifier)
        //        {
        //            notSameIdInPlc.Add(exchange.ManagerDataTypeName);
        //            continue;
        //        }

        //        if (exchange.Repository.Exists(identifier))
        //        {
        //            await exchange.RemoteUpdate(identifier);
        //            updated.Add(exchange.ManagerDataTypeName);
        //        }
        //        else
        //        {
        //            await exchange.RemoteCreate(identifier);
        //            created.Add(exchange.ManagerDataTypeName);
        //        }
        //    }

        //    if (updated.Count > 0)
        //    {
        //        string updatedInRepositories = string.Join(", ", updated);

        //        // Alert
        //        AlertService?.AddToast(
        //            eToastType.Info,
        //            "Update record",
        //            $"Record \"{identifier}\" was updated in repositories: {updatedInRepositories}.",
        //            7
        //        );

        //        // Log
        //        AxoApplication.Current.Logger.Information(
        //            $"Updated record \"{identifier}\" in repositories: {updatedInRepositories} by user action.",
        //            Authentication.GetAuthenticationStateAsync().Result.User.Identity
        //        );
        //    }

        //    if (created.Count > 0)
        //    {
        //        string createdInRepositories = string.Join(", ", created);

        //        // Alert
        //        AlertService?.AddToast(
        //            eToastType.Info,
        //            "Create record",
        //            $"Record \"{identifier}\" was created in repositories: {createdInRepositories}.",
        //            7
        //        );

        //        // Log
        //        AxoApplication.Current.Logger.Information(
        //            $"Created record \"{identifier}\" in repositories: {createdInRepositories} by user action.",
        //            Authentication.GetAuthenticationStateAsync().Result.User.Identity
        //        );
        //    }

        //    if (notSameIdInPlc.Count > 0)
        //    {
        //        string notEqualEntityIds = string.Join(", ", notSameIdInPlc);

        //        // Alert
        //        AlertService?.AddToast(
        //            eToastType.Warning,
        //            "Update error",
        //            $"Online records have a different ID than requested for update: {notEqualEntityIds}.",
        //            14
        //        );

        //        // Log
        //        AxoApplication.Current.Logger.Warning(
        //            $"Updating record \"{identifier}\" by user action failed – mismatched IDs in: {notEqualEntityIds}.",
        //            Authentication.GetAuthenticationStateAsync().Result.User.Identity
        //        );
        //    }

        //}

        public async Task SendToPlc(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Update_data_error, Properties.AxOpenDataResources.Please_enter_valid_identifier, 20);
                return;
            }

            List<string> sentToPlc = new List<string>();
            List<string> notExistInDb = new List<string>();

            foreach (var exchangeGroup in AllExchanges.GroupBy(p => p.GetPlainTypes().First().FullName))
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
                string sentExchanges = string.Join(", ", sentToPlc);

                // Alert message
                ToastService?.AddToast(
                    eToastType.Info,
                    Properties.AxOpenDataResources.Send_record,
                    $"Record \"{identifier}\" was sent to exchanges: {sentExchanges} by user action.",
                    7
                );

                // Log message
                AxoApplication.Current.Logger.Information(
                    $"Record \"{identifier}\" sent to exchanges: {sentExchanges} by user action.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }

            if (notExistInDb.Count > 0)
            {
                string notExistInRepos = string.Join(", ", notExistInDb);

                // Alert message
                ToastService?.AddToast(
                    eToastType.Warning,
                    Properties.AxOpenDataResources.Send_error,
                    $"Record \"{identifier}\" does not exist in the database for: {notExistInRepos}.",
                    14
                );

                // Log message
                AxoApplication.Current.Logger.Warning(
                    $"Sending record \"{identifier}\" failed – record does not exist in the database for: {notExistInRepos} by user action.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }
        }

        public async Task Copy(string identifier, string newIdentifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Copy_error, Properties.AxOpenDataResources.Please_enter_valid_source_identifier, 20);
                return;
            }

            if (string.IsNullOrEmpty(newIdentifier))
            {
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Copy_record_error, Properties.AxOpenDataResources.Data_cannot_be_deleted_please_enter_valid_new_identifier, 20);
                return;
            }

            List<string> copied = new List<string>();
            List<string> notExist = new List<string>();
            List<string> alreadyExist = new List<string>();

            foreach (var exchange in Exchanges)
            {
                if (exchange.Repository.Exists(identifier))
                {
                    if (!exchange.Repository.Exists(newIdentifier))
                    {
                        var newPlain = exchange.Repository.Read(identifier);
                        (newPlain as dynamic)._EntityId = newIdentifier;
                        exchange.Repository.Create(newIdentifier, newPlain);
                        copied.Add(exchange.ManagerDataTypeName);
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
                ToastService?.AddToast(eToastType.Info, Properties.AxOpenDataResources.Copied_record, $"Data with ID: \"{identifier}\" was created for: {createdRecords}!", 7);
                AxoApplication.Current.Logger.Information($"Copying record \"{identifier}\" with new ID \"{newIdentifier}\" into repositories {createdRecords} by user action was successful.", Authentication.GetAuthenticationStateAsync().Result.User.Identity);
            }

            if (alreadyExist.Count > 0)
            {
                string alreadyExistRecords = string.Join(", ", alreadyExist);
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Copied_error, $"Record already exist for: {alreadyExistRecords}!", 14);
                AxoApplication.Current.Logger.Warning($"Copying record \"{identifier}\" into repositories {alreadyExistRecords} by user action failed – record already exist.", Authentication.GetAuthenticationStateAsync().Result.User.Identity);
            }

            if (notExist.Count > 0)
            {
                string notExistRecords = string.Join(", ", notExist);
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Copied_error, $"Source Record not exist for: {notExistRecords}!", 14);
                AxoApplication.Current.Logger.Warning($"Copying record \"{identifier}\" into repositories {notExistRecords} by user action failed – record does not exist.", Authentication.GetAuthenticationStateAsync().Result.User.Identity);
            }
        }

        public async Task Delete(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
            {
                ToastService?.AddToast(eToastType.Warning, Properties.AxOpenDataResources.Delete_error, Properties.AxOpenDataResources.Please_enter_valid_source_identifier, 20);
                return;
            }

            List<string> notExist = new List<string>();
            List<string> deleted = new List<string>();

            foreach (var exchange in Exchanges)
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
                string deletedInRepos = string.Join(", ", deleted);

                // Alert message
                ToastService?.AddToast(
                    eToastType.Info,
                    Properties.AxOpenDataResources.Delete_record,
                    $"Record \"{identifier}\" was deleted from repositories: {deletedInRepos}.",
                    7
                );

                // Log message
                AxoApplication.Current.Logger.Information(
                    $"Deleted record \"{identifier}\" from repositories: {deletedInRepos} by user action was successful.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }
            if (notExist.Count > 0)
            {
                string notExistInRepos = string.Join(", ", notExist);

                // Alert message
                ToastService?.AddToast(
                    eToastType.Warning,
                    Properties.AxOpenDataResources.Delete_error,
                    $"Source record does not exist in repositories: {notExistInRepos}.",
                    14
                );

                // Log message
                AxoApplication.Current.Logger.Warning(
                    $"Deleting record \"{identifier}\" by user action failed – record does not exist in repositories: {notExistInRepos}.",
                    Authentication.GetAuthenticationStateAsync().Result.User.Identity
                );
            }
        }

        #endregion IDataExchangeGlogalActions

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
                InitializeSelectedViewModel(exchange);

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

        protected void InitializeSelectedViewModel(IAxoDataExchange exchange)
        {
            if (this.SelectedManagerVm != null)
            {
                this.SelectedManagerVm = null;
            }

            SelectedManagerVm = new DataExchangeViewModel();
            SelectedManagerVm.AuthenticationProvider = Authentication;
            SelectedManagerVm.ToastService = ToastService;

            SelectedManagerVm.Model = exchange;
            SelectedManagerVm.SetInjectedEntityIds(MergeInjectedEntities());

            SelectedManagerVm.GlobalActions = this; // set global actions

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
                if (this.InjectedEntities != null)
                {
                    ids.AddRange(this.InjectedEntities);
                    ids = ids.Distinct().ToList();
                }
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

        public Dictionary<string, List<IBrowsableDataObject>> GetRecords(PredicateContainer predicates,
            int limit, int skip)
        {
            List<string> commonEntities = Exchanges.GetEntityIds(predicates);

            this.LastFragmentQueryCount = commonEntities.Count;

            var toFind = commonEntities.Skip(skip).Take(limit).ToList();

            return GetRecords(toFind);
        }

        public IEnumerable<string> GetEntityIds(PredicateContainer predicates)
        {
            List<string> commonEntities = Exchanges.GetEntityIds(predicates);

            this.LastFragmentQueryCount = commonEntities.Count;

            return commonEntities;
        }

        public Dictionary<string, List<IBrowsableDataObject>> GetRecords(IEnumerable<string> identifiers)
        {
            var result = new Dictionary<string, List<IBrowsableDataObject>>();

            foreach (var fragment in Exchanges)
            {
                var matching = fragment.GetRecords(identifiers); // Assuming fragment supports this
                if (matching.Any())
                {
                    result[fragment.ManagerDataTypeName] = matching.ToList();
                }
            }

            return result;
        }
    }
}