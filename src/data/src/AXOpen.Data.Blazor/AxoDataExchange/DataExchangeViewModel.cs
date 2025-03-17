using AXOpen.Data.Interfaces;
using AXOpen.Data;
using AXSharp.Presentation;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXSharp.Connector.ValueTypes.Online;
using AXSharp.Connector;
using System.Linq.Expressions;
using System.Numerics;
using Microsoft.AspNetCore.Components;
using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Newtonsoft.Json.Linq;
using System.ComponentModel;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using AXOpen.Data.Query;
using AXOpen.Base.Data.Query;

namespace AXOpen.Data
{
    public partial class DataExchangeViewModel : RenderableViewModelBase, IDataExchangeViewModel, IDataExchangeQueryViewModel
    {
        protected volatile object _viewRefreshMutex = new object();
        protected volatile object _lockInjectEntities = new object();

        public DataExchangeViewModel()
        {
        }

        public IAxoDataExchange DataExchange
        {
            get;
            private set;
        }

        public override object Model
        {
            get => this.DataExchange;
            set => this.DataExchange = (IAxoDataExchange)value;
        }

        private ITwinObject _refUIData;

        public ITwinObject RefUIData
        {
            get
            {
                if (_refUIData == null)
                {
                    _refUIData = DataExchange.CloneDataObject();
                }

                return _refUIData;
            }
        }

        public ObservableCollection<IBrowsableDataObject> Records { get; set; } = new ObservableCollection<IBrowsableDataObject>();
        public bool IsBusy { get; set; }

        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;
        public int Limit { get; set; } = 10;
        public string CreateItemId { get; set; }

        public ExportSettings ExportSet { get; set; } = new();

        private AuthenticationStateProvider _authenticationProvider;

        public AuthenticationStateProvider AuthenticationProvider
        {
            get
            {
                if (_authenticationProvider == null)
                    throw new Exception("AuthenticationProvider must be implemented in " + this.ToString());
                return _authenticationProvider;
            }
            set
            {
                _authenticationProvider = value;
            }
        }

        public eOperationStatus exportStatus { get; set; } = eOperationStatus.Ready;
        public eOperationStatus importStatus { get; set; } = eOperationStatus.Ready;

        public List<ValueChangeItem> Changes { get; set; } = new List<ValueChangeItem>();

        private IAlertService _alertDialogService;

        public IAlertService AlertDialogService
        {
            get
            {
                if (_alertDialogService == null)
                    throw new Exception("AlertDialogService must be implemented in " + this.ToString());
                return _alertDialogService;
            }
            set
            {
                _alertDialogService = value;
            }
        }

        private IBrowsableDataObject _selectedRecord;

        public bool IsHashCorrect { get; set; } = true;

        public IBrowsableDataObject SelectedRecord
        {
            get
            {
                return _selectedRecord;
            }

            set
            {
                _selectedRecord = value;
                if (value != null)
                {
                    DataExchange.FromRepositoryToShadowsAsync(value, RefUIData).Wait();
                    DataExchange.ChangeTrackerSetChanges(RefUIData);
                    IsHashCorrect = DataExchange.IsHashCorrect(AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity, RefUIData);
                    Changes = DataExchange.ChangeTrackerGetChanges().OrderBy(p => p.DateTime.Ticks).ToList();
                }
            }
        }

        private QuerySymbolConfiguration _DefaulQueryDataEntityId;

        public QuerySymbolConfiguration DefaulQueryDataEntityId
        {
            get
            {
                if (_DefaulQueryDataEntityId == null)
                {
                    var poco = DataExchange.GetPlainTypes().First();
                    _DefaulQueryDataEntityId = new QuerySymbolConfiguration($"{poco.Name}.DataEntityId", typeof(string).FullName, "StartsWith", "", "");
                }

                return _DefaulQueryDataEntityId;
            }
        }

        private SortSettings _DefaulSorting;

        public SortSettings DefaulSorting
        {
            get
            {
                if (_DefaulSorting == null)
                {
                    _DefaulSorting = new SortSettings();
                }

                return _DefaulSorting;
            }
        }

        private List<PlainSymbolBuilder> _PlainBuilders;

        public List<PlainSymbolBuilder> PlainBuilders
        {
            get
            {
                if (_PlainBuilders == null)
                {
                    _PlainBuilders = DataExchange.GetPlainTypes().Select(p => new PlainSymbolBuilder(p)).ToList();
                }

                return _PlainBuilders;
            }
        }

        public PredicateContainer LastFilter { set; get; }

        // injected from view or other service
        public PredicateContainer InjectedPredicateContainer { get; set; }

        private List<string> EntityIdsInjected = new();
        internal List<string> EntityIdsLastQuery = new();
        internal List<string> EntityIdsIntersected = new();
        public bool ReadAllEntityIdsForConcatQuery { set; get; }

        internal void Locked()
        {
            if (IsLockedByMeOrNull())
            {
                DataExchange.SetLockedBy(this);
                DataExchange.ChangeTrackerStartObservingChanges(AuthenticationProvider.GetAuthenticationStateAsync().Result, this.RefUIData);
            }
        }

        internal void UnLocked()
        {
            if (IsLockedByMeOrNull())
            {
                DataExchange.ChangeTrackerStopObservingChanges(this.RefUIData);
                DataExchange.SetLockedBy(null);
            }
        }

        internal bool IsLockedByMeOrNull()
        {
            if (DataExchange.GetLockedBy() == null || DataExchange.GetLockedBy() == this)
                return true;
            return false;
        }

        public virtual async Task Filter()
        {
            Page = 0;

            await FillObservableRecordsAsync(BuidDefaultPredicates());
        }

        public virtual Task FillObservableRecordsAsync(PredicateContainer? predicates = null)
        {
            return Task.Run(() =>
            {
                IsBusy = true;

                UpdateObservableRecords(predicates);

                IsBusy = false;
            });
        }

        public virtual void UpdateObservableRecords(PredicateContainer? predicates = null)
        {
            if (predicates == null)
            {
                if (LastFilter == null)
                {
                    LastFilter = new PredicateContainer();
                }

                predicates = LastFilter;
            }

            LastFilter = predicates;

            Filter(predicates, Limit, Page * Limit);
        }

        public virtual IEnumerable<IBrowsableDataObject> Filter(PredicateContainer predicates, int limit = 10, int skip = 0)
        {
            IEnumerable<IBrowsableDataObject> filtered = null;

            if (EntityIdsInjected != null && EntityIdsInjected.Count > 0)
            {
                this.EntityIdsLastQuery.Clear();
                this.EntityIdsIntersected.Clear();

                EntityIdsLastQuery.AddRange(DataExchange.GetEntityIds(predicates).ToList());
                EntityIdsIntersected.AddRange(EntityIdsInjected.Intersect(EntityIdsLastQuery).ToList());

                this.FilteredCount = EntityIdsIntersected.Count;

                var toFind = EntityIdsIntersected.Skip(skip).Take(limit).ToList();

                filtered = DataExchange.GetRecords(toFind).ToList();
            }
            else
            {
                this.EntityIdsLastQuery.Clear();
                this.EntityIdsIntersected.Clear();

                if (this.ReadAllEntityIdsForConcatQuery)
                {
                    var ids = DataExchange.GetEntityIds(predicates).ToList();
                    EntityIdsLastQuery.AddRange(ids);
                    EntityIdsIntersected.AddRange(ids);
                }

                FilteredCount = this.DataExchange.Repository.FilteredCount(predicates);

                filtered = this.DataExchange.GetRecords(predicates, limit, skip);
            }

            lock (_viewRefreshMutex)
            {
                Records.Clear();

                foreach (var item in filtered)
                {
                    this.Records.Add(item);
                }
            }

            return Records;
        }

        public PredicateContainer BuidDefaultPredicates()
        {
            try
            {
                PredicateContainer pc = new PredicateContainer();
                if (InjectedPredicateContainer != null) pc.AddPredicatesFrom(InjectedPredicateContainer);

                pc.AddQuerySymbolToPredicates(PlainBuilders, DefaulQueryDataEntityId);

                var poco = DataExchange.GetPlainTypes().First();

                pc.AddSortMember(DefaulSorting, poco);

                return pc;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public IBrowsableDataObject FindById(string id)
        {
            Records.Clear();

            foreach (var record in DataExchange.GetRecords(id))
            {
                Records.Add(record);
            }

            if (Records.Count > 0)
            {
                var found = Records.FirstOrDefault(p => p.DataEntityId == id);
                if (found == null)
                    throw new UnableToLocateRecordId($"Unable to locate record id '{id}'", null);
                else
                    return found;
            }

            if (id != "*")
                throw new UnableToLocateRecordId($"Unable to locate record id '{id}'", null);

            return null;
        }

        public async Task CreateNew()
        {
            try
            {
                if (string.IsNullOrEmpty(CreateItemId))
                {
                    AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Cannot create!", "New entry name cannot be empty. Please provide an ID", 10);
                    return;
                }

                await DataExchange.CreateNewAsync(CreateItemId, RefUIData);
                AxoApplication.Current.Logger.Information($"Created {CreateItemId} in {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                AlertDialogService?.AddAlertDialog(eAlertType.Success, "Created!", "Item was successfully created!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Failed to create new record!", e.Message, 10);
            }
            finally
            {
                await FillObservableRecordsAsync(BuidDefaultPredicates());
                CreateItemId = null;

                InvokeStateHasChanged();
            }
        }

        public async Task Delete()
        {
            try
            {
                await DataExchange.Delete(SelectedRecord.DataEntityId);
                AxoApplication.Current.Logger.Information($"Deleted {SelectedRecord.DataEntityId} from {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                AlertDialogService?.AddAlertDialog(eAlertType.Success, "Deleted!", "Item was successfully deleted!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Failed to delete", e.Message, 10);
            }
            finally
            {
                UpdateObservableRecords(BuidDefaultPredicates());
            }

            InvokeStateHasChanged();
        }

        public async Task Copy()
        {
            try
            {
                await DataExchange.CreateCopyCurrentShadowsAsync(CreateItemId, RefUIData);
                AxoApplication.Current.Logger.Information($"Copied {CreateItemId} into {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                AlertDialogService.AddAlertDialog(eAlertType.Success, "Copied!", "Item was successfully copied!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Failed to copy!", e.Message, 10);
            }
            finally
            {
                UpdateObservableRecords(BuidDefaultPredicates());
                CreateItemId = null;

                InvokeStateHasChanged();
            }
        }

        public async Task Edit()
        {
            await DataExchange.UpdateFromShadowsAsync(RefUIData);
            AlertDialogService?.AddAlertDialog(eAlertType.Success, "Edited!", "Item was successfully edited!", 10);
            UpdateObservableRecords(BuidDefaultPredicates());
        }

        public async Task SendToPlc()
        {
            await DataExchange.FromRepositoryToControllerAsync(SelectedRecord, RefUIData);
            AxoApplication.Current.Logger.Information($"Sended to Plc {SelectedRecord.DataEntityId} in {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
            AlertDialogService?.AddAlertDialog(eAlertType.Success, "Sended to PLC!", "Item was successfully sended to PLC!", 10);
        }

        public async Task LoadFromPlc()
        {
            try
            {
                await DataExchange.CreateDataFromControllerAsync(CreateItemId, RefUIData);
                AlertDialogService?.AddAlertDialog(eAlertType.Success, "Loaded from PLC!", "Item was successfully loaded from PLC!", 10);
                AxoApplication.Current.Logger.Information($"Loaded from Plc {CreateItemId} into {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Failed to create new record from the controller", e.Message, 10);
            }
            finally
            {
                await FillObservableRecordsAsync();
                CreateItemId = null;
            }
        }

        public Task ExportDataAsync(string path)
        {
            exportStatus = eOperationStatus.Busy;

            return Task.Run(() =>
            {
                try
                {
                    DataExchange.ExportData(path, ExportSet.CustomExportData, ExportSet.ExportMode, ExportSet.FirstNumber, ExportSet.SecondNumber, ExportSet.ExportFileType, ExportSet.Separator);

                    exportStatus = eOperationStatus.Done;

                    AlertDialogService?.AddAlertDialog(eAlertType.Success, "Exported!", "Data was successfully exported!", 10);

                    AxoApplication.Current.Logger.Information($"Exported data from {DataExchange} to path {path} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                }
                catch (Exception e)
                {
                    AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Error!", e.Message, 10);
                    exportStatus = eOperationStatus.Failed;
                }
            });
        }

        public Task ImportDataAsync(string path)
        {
            return Task.Run(() =>
            {
                try
                {
                    DataExchange.ImportData(path, AuthenticationProvider.GetAuthenticationStateAsync().Result, exportFileType: ExportSet.ExportFileType, separator: ExportSet.Separator);
                    this.UpdateObservableRecords();

                    AlertDialogService?.AddAlertDialog(eAlertType.Success, "Imported!", "Data was successfully imported!", 10);
                    AxoApplication.Current.Logger.Information($"Imported data into {DataExchange} from path {path} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);

                    importStatus = eOperationStatus.Done;
                }
                catch (Exception e)
                {
                    AlertDialogService?.AddAlertDialog(eAlertType.Danger, "Error!", e.Message, 10);
                }
            });
        }

        public IEnumerable<ITwinElement> GetValueTags(Type type)
        {
            var prototype = Activator.CreateInstance(type, new object[] { ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(new object[] { }), "_data", "_data" }) as ITwinObject;
            return prototype.GetKids();
        }

        public void ChangeCustomExportDataValue(ChangeEventArgs __e, string fragmentKey)
        {
            if (!ExportSet.CustomExportData.ContainsKey(fragmentKey))
            {
                ExportSet.CustomExportData.Add(fragmentKey, new ExportData((bool)__e.Value, new Dictionary<string, bool>()));
            }
            else
            {
                ExportSet.CustomExportData[fragmentKey].Exported = (bool)__e.Value;
            }
        }

        public void ChangeCustomExportDataValue(ChangeEventArgs __e, string fragmentKey, string key)
        {
            if (!ExportSet.CustomExportData.ContainsKey(fragmentKey))
            {
                ExportSet.CustomExportData.Add(fragmentKey, new ExportData(true, new Dictionary<string, bool>()));
                ExportSet.CustomExportData[fragmentKey].Data.Add(key, (bool)__e.Value);
            }
            else
            {
                if (!ExportSet.CustomExportData[fragmentKey].Data.ContainsKey(key))
                {
                    ExportSet.CustomExportData[fragmentKey].Data.Add(key, (bool)__e.Value);
                }
                else
                {
                    ExportSet.CustomExportData[fragmentKey].Data[key] = (bool)__e.Value;
                }
            }

            InvokeStateHasChanged();
        }

        public Action StateHasChangedDelegate { get; set; }

        public bool GetCustomExportDataValue(string fragmentKey)
        {
            var result = new Dictionary<string, object>();
            if (ExportSet.CustomExportData.ContainsKey(fragmentKey))
                return ExportSet.CustomExportData[fragmentKey].Exported;
            return true;
        }

        public bool GetCustomExportDataValue(string fragmentKey, string key)
        {
            if (ExportSet.CustomExportData.ContainsKey(fragmentKey))
            {
                if (ExportSet.CustomExportData[fragmentKey].Data.ContainsKey(key))
                    return ExportSet.CustomExportData[fragmentKey].Data[key];
            }
            return true;
        }

        public Dictionary<string, object> InDictionary(bool check)
        {
            var r = new Dictionary<string, object>();
            if (check)
                r.Add("checked", "checked");
            return r;
        }

        public bool GetFragmentsExportedValue()
        {
            foreach (var item in ExportSet.CustomExportData)
            {
                if (!item.Value.Exported)
                    return false;

                foreach (var innerItem in item.Value.Data)
                {
                    if (!innerItem.Value)
                        return false;
                }
            }
            return true;
        }

        #region IDataExchangeQueryViewModel implementation

        public IEnumerable<Type> GetPlainTypes()
        {
            return DataExchange.GetPlainTypes();
        }

        public void InvokeStateHasChanged()
        {
            if (this.StateHasChangedDelegate != null)
            {
                this.StateHasChangedDelegate.Invoke();
            }
        }

        #endregion IDataExchangeQueryViewModel implementation

        public void SetInjectedEntityIds(List<string> ids)
        {
            lock (_lockInjectEntities)
            {
                this.EntityIdsInjected.Clear();

                this.EntityIdsInjected.AddRange(ids);
            }
        }
    }
}