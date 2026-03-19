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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using Operon.Components.Toast;
using Properties = AXOpen.Data.Blazor.Properties;

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
        public int Page { get; set; } = 1;
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

        private IToastService _toastService;

        public IToastService ToastService
        {
            get
            {
                if (_toastService == null)
                    throw new Exception("ToastService must be implemented in " + this.ToString());
                return _toastService;
            }
            set
            {
                _toastService = value;
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
                    _DefaulQueryDataEntityId = new QuerySymbolConfiguration(DataExchange.GetPlainTypes().First().FullName, "_EntityId", typeof(string).FullName, "StartsWith", "", "");
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

        public PredicateContainer LastPredicates { set; get; }

        // injected from view or other service
        public PredicateContainer ExternalPredicates { get; private set; }

        internal bool AreEntityIdsInjected { get; private set; }

        /// <summary>
        /// ids, injected from distributed manager
        /// </summary>
        public List<string> ExternalEntityIds { get; private set; } = new();

        /// <summary>
        /// ids, that will be used when is concatenating between Exchanges
        /// </summary>
        public List<string> EntityIdsIntersected { get; private set; } = new();

        public IDistributedDataActions? DistributedActions { internal set; get; }

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
            Page = 1; // reset page => filtered count is unknown

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
                if (LastPredicates == null)
                {
                    LastPredicates = new PredicateContainer();
                }

                predicates = LastPredicates;
            }

            LastPredicates = predicates;

            if (ExternalEntityIds != null && ExternalEntityIds.Count > 0 && (Page - 1) * Limit >= ExternalEntityIds.Count) // is over limit => set last page
            {
                Page = (ExternalEntityIds.Count - 1) / Limit;
            }

            Filter(predicates, Limit, (Page - 1) * Limit);
        }

        public List<string> GetLastEntityIds()
        {
            var ids = new List<string>();

            if (LastPredicates == null)
            {
                LastPredicates = new PredicateContainer();
            }

            if (ExternalEntityIds != null && ExternalEntityIds.Count > 0 && (Page - 1) * Limit >= ExternalEntityIds.Count) // is over limit => set last page
            {
                Page = (ExternalEntityIds.Count - 1) / Limit;
            }

            if (AreEntityIdsInjected)
            {
                EntityIdsIntersected.Clear();
                EntityIdsIntersected.AddRange(DataExchange.GetEntityIds(LastPredicates, ExternalEntityIds).ToList()); // intersect external ids and predicates
                ids = EntityIdsIntersected;
            }
            else
            {
                ids = DataExchange.GetEntityIds(LastPredicates).ToList();
            }

            return ids;
        }


        public virtual IEnumerable<IBrowsableDataObject> Filter(PredicateContainer predicates, int limit = 10, int skip = 0)
        {
            IEnumerable<IBrowsableDataObject> filtered = null;

            lock (_lockInjectEntities)
            {
                if (!AreEntityIdsInjected) // normal filtering without any injected ids
                {
                    FilteredCount = this.DataExchange.Repository.FilteredCount(predicates);
                    filtered = this.DataExchange.GetRecords(predicates, limit, skip);
                }
                else
                {
                    EntityIdsIntersected.Clear();
                    EntityIdsIntersected.AddRange(DataExchange.GetEntityIds(predicates, ExternalEntityIds).ToList()); // intersect external ids and predicates
                    this.FilteredCount = EntityIdsIntersected.Count();
                    var toFind = EntityIdsIntersected.Skip(skip).Take(limit).ToList();
                    filtered = DataExchange.GetRecords(toFind, predicates).ToList();
                }
            }

            // update local concat if is activated
            if (DistributedActions != null && DistributedActions.EnableLocalConcatEntityIds)
            {
                DistributedActions.SetLocalExchangeConcatIds(EntityIdsIntersected);
            }

            // update observable collection in locked way
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
                if (ExternalPredicates != null) pc.AddPredicatesFrom(ExternalPredicates);

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
                var found = Records.FirstOrDefault(p => p._EntityId == id);
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
                    ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Cannot_create, Properties.AxOpenDataResources.New_entry_name_cannot_be_empty, 10);
                    return;
                }

                await DataExchange.CreateNewAsync(CreateItemId, RefUIData);
                AxoApplication.Current.Logger.Information($"Created {CreateItemId} in {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Created, Properties.AxOpenDataResources.Item_was_successfully_created, 10);
            }
            catch (Exception e)
            {
                ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Failed_to_create_new_record, e.Message, 10);
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
                await DataExchange.Delete(SelectedRecord._EntityId);
                AxoApplication.Current.Logger.Information($"Deleted {SelectedRecord._EntityId} from {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Deleted, Properties.AxOpenDataResources.Item_was_successfully_deleted, 10);
            }
            catch (Exception e)
            {
                ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Failed_to_delete, e.Message, 10);
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
                ToastService.AddToast(eToastType.Success, Properties.AxOpenDataResources.Copied, Properties.AxOpenDataResources.Item_was_successfully_copied, 10);
            }
            catch (Exception e)
            {
                ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Failed_to_copy, e.Message, 10);
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
            ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Edited, Properties.AxOpenDataResources.Item_was_successfully_edited, 10);
            UpdateObservableRecords(BuidDefaultPredicates());
        }

        public async Task SendToPlc()
        {
            await DataExchange.FromRepositoryToControllerAsync(SelectedRecord, RefUIData);
            AxoApplication.Current.Logger.Information($"Sent to Plc {SelectedRecord._EntityId} in {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
            ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Sent_to_PLC, Properties.AxOpenDataResources.Item_was_successfully_sent_to_PLC, 10);
        }

        public async Task LoadFromPlc()
        {
            try
            {
                await DataExchange.CreateDataFromControllerAsync(CreateItemId, RefUIData);
                ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Loaded_from_PLC, Properties.AxOpenDataResources.Item_was_successfully_loaded_from_PLC, 10);
                AxoApplication.Current.Logger.Information($"Loaded from Plc {CreateItemId} into {DataExchange} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
            }
            catch (Exception e)
            {
                ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Failed_to_create_new_record_from_the_controller, e.Message, 10);
            }
            finally
            {
                await FillObservableRecordsAsync();
                CreateItemId = null;
            }
        }

        //public async Task UpdateFromPlc()
        //{
        //    try
        //    {
        //        var identifier = SelectedRecord._EntityId;

        //        var refdata = DataExchange.CloneDataObject();

        //        var _EntityId = (refdata as IAxoDataEntity)._EntityId;

        //        List<ITwinPrimitive> batchRedElements = new();

        //        batchRedElements.Add(_EntityId);

        //        await refdata.GetConnector().ReadBatchAsync(batchRedElements);

        //        if (_EntityId.Cyclic != identifier)
        //        {
        //            AlertDialogService?.AddToast(eToastType.Warning, "Update error", $"Online record has different ID that requested to update: {_EntityId.Cyclic}/{identifier}!", 14);
        //            return;
        //        }

        //        await DataExchange.RemoteUpdate(identifier);
        //        AlertDialogService?.AddToast(eToastType.Success, "Update from PLC!", "Item was successfully updated from PLC!", 10);
        //        AxoApplication.Current.Logger.Information($"Updated from Plc {identifier} into {DataExchange.PresentableInstanceName} by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
        //    }
        //    catch (Exception e)
        //    {
        //        AlertDialogService?.AddToast(eToastType.Danger, "Failed to update a record from the controller", e.Message, 10);
        //    }
        //    finally
        //    {
        //        await FillObservableRecordsAsync();
        //        CreateItemId = null;
        //    }
        //}

        public Task ExportDataAsync(string path)
        {
            exportStatus = eOperationStatus.Busy;

            return Task.Run(() =>
            {
                try
                {
                    DataExchange.ExportData(path, ExportSet.CustomExportData, ExportSet.ExportMode, ExportSet.FirstNumber, ExportSet.SecondNumber, ExportSet.ExportFileType, ExportSet.Separator);

                    exportStatus = eOperationStatus.Done;

                    ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Exported, Properties.AxOpenDataResources.Data_was_successfully_exported, 10);

                    AxoApplication.Current.Logger.Information($"Data form '{DataExchange}' where exported to location '{path}' by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);
                }
                catch (Exception e)
                {
                    ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Error, e.Message, 10);
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

                    ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Imported, Properties.AxOpenDataResources.Data_were_successfully_imported, 10);
                    AxoApplication.Current.Logger.Information($"Data imported into '{DataExchange}' from location '{path}' by user action.", AuthenticationProvider.GetAuthenticationStateAsync().Result.User.Identity);

                    importStatus = eOperationStatus.Done;
                }
                catch (Exception e)
                {
                    ToastService?.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Error, e.Message, 10);
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

        public void SetExternalEntityIds(List<string> value) // null-will be initialized,[0..xx] valid range-display
        {
            lock (_lockInjectEntities)
            {
                this.AreEntityIdsInjected = true;
                this.ExternalEntityIds.Clear();
                this.EntityIdsIntersected.Clear();

                if (value != null && value.Count > 0)
                {
                    this.ExternalEntityIds.Clear();
                    this.EntityIdsIntersected.Clear();
                    this.ExternalEntityIds.AddRange(value);
                    this.EntityIdsIntersected.AddRange(value);
                }
            }
        }
        public void ResetExternalEntityIds() // implicitly tells to disable external ids
        {
            lock (_lockInjectEntities)
            {
                this.ExternalEntityIds.Clear();
                this.EntityIdsIntersected.Clear();
                this.AreEntityIdsInjected = false;
            }
        }

        public void SetExternalPredicates(PredicateContainer? value) // null-reset, !null - set for concatenation
        {
            if (value != ExternalPredicates)
            {
                ExternalPredicates = value;
            }
        }

        public async Task TogleDistributedExchangeConcat()
        {
            if (DistributedActions.EnableLocalConcatEntityIds)
            {
                DistributedActions.ResetLocalExchangeConcatIds();
                await this.FillObservableRecordsAsync(); // refresh records with last ids
            }
            else
            {
                // send last ids to distributed manager
                var ids = this.DataExchange.GetEntityIds(LastPredicates).ToList();
                this.ExternalEntityIds.Clear();
                this.EntityIdsIntersected.Clear();
                this.ExternalEntityIds.AddRange(ids);
                this.EntityIdsIntersected.AddRange(ids);
                DistributedActions.SetLocalExchangeConcatIds(ExternalEntityIds);
            }
        }


        #endregion IDataExchangeQueryViewModel implementation
    }

    public enum InjectedStatus
    {
        None,
        Initialization,
        Concatenating,
    }

}
