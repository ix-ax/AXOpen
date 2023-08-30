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

namespace AXOpen.Data
{
    public class DataExchangeViewModel : RenderableViewModelBase
    {
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

        public DataExchangeViewModel()
        {

        }

        public AuthenticationStateProvider Asp { get; set; }

        public bool IsFileExported { get; set; } = false;
        public List<ValueChangeItem> Changes { get; set; } = new List<ValueChangeItem>();

        public IAlertDialogService AlertDialogService { get; set; }

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
                    DataExchange.FromRepositoryToShadowsAsync(value).Wait();
                    DataExchange.ChangeTrackerSetChanges(value);
                    IsHashCorrect = DataExchange.IsHashCorrect(_selectedRecord, Asp.GetAuthenticationStateAsync().Result.User.Identity);
                    Changes = DataExchange.ChangeTrackerGetChanges().OrderBy(p => p.DateTime.Ticks).ToList();
                }
            }
        }

        internal void Locked()
        {
            if (IsLockedByMeOrNull())
            {
                DataExchange.SetLockedBy(this);
                DataExchange.ChangeTrackerStartObservingChanges(Asp.GetAuthenticationStateAsync().Result);
            }
        }

        internal void UnLocked()
        {
            if (IsLockedByMeOrNull())
            {
                DataExchange.ChangeTrackerStopObservingChanges();
                DataExchange.SetLockedBy(null);
            }
        }

        internal bool IsLockedByMeOrNull()
        {
            if(DataExchange.GetLockedBy() == null || DataExchange.GetLockedBy() == this)
                return true;
            return false;
        }

        public Task FillObservableRecordsAsync()
        {
            //let another thread to load records, we need main thread to show loading symbol in blazor page
            return Task.Run(async () =>
            {
                IsBusy = true;
                UpdateObservableRecords();
                IsBusy = false;
            });
        }

        public IEnumerable<IBrowsableDataObject> Filter(string identifier, int limit = 10, int skip = 0, eSearchMode searchMode = eSearchMode.Exact)
        {
            Records.Clear();

            foreach (var item in this.DataExchange.GetRecords(identifier, limit: limit, skip: skip, searchMode))
            {
                this.Records.Add(item);
            }

            FilteredCount = CountFiltered(FilterById, SearchMode);

            return Records;
        }

        public long CountFiltered(string id, eSearchMode searchMode = eSearchMode.Exact)
        {
            return this.DataExchange.Repository.FilteredCount(id, searchMode);
        }

        public void UpdateObservableRecords()
        {
            Filter(FilterById, Limit, Page * Limit, SearchMode).ToList();
        }

        public async Task Filter()
        {
            Page = 0;
            await FillObservableRecordsAsync();
        }

        public async Task RefreshFilter()
        {
            Limit = 10;
            FilterById = "";
            SearchMode = eSearchMode.Exact;
            Page = 0;
            await FillObservableRecordsAsync();
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
                    AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Cannot create!", "New entry name cannot be empty. Please provide an ID", 10);
                    return;
                }

                await DataExchange.CreateNewAsync(CreateItemId);
                AxoApplication.Current.Logger.Information($"Create {CreateItemId} in {DataExchange} by user action.", Asp.GetAuthenticationStateAsync().Result.User.Identity);
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Created!", "Item was successfully created!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Failed to create new record!", e.Message, 10);
            }
            finally
            {
                await FillObservableRecordsAsync();
                CreateItemId = null;
            }
        }

        public void Delete()
        {
            try
            {
                DataExchange.Delete(SelectedRecord.DataEntityId);
                AxoApplication.Current.Logger.Information($"Delete {SelectedRecord.DataEntityId} in {DataExchange} by user action.", Asp.GetAuthenticationStateAsync().Result.User.Identity);
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Deleted!", "Item was successfully deleted!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Failed to delete", e.Message, 10);
            }
            finally
            {
                UpdateObservableRecords();
            }

            StateHasChangedDelegate.Invoke();

        }

        public async Task Copy()
        {
            try
            {
                await DataExchange.CreateCopyCurrentShadowsAsync(CreateItemId);
                AxoApplication.Current.Logger.Information($"Copy {CreateItemId} in {DataExchange} by user action.", Asp.GetAuthenticationStateAsync().Result.User.Identity);
                AlertDialogService.AddAlertDialog(eAlertDialogType.Success, "Copied!", "Item was successfully copied!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Failed to copy!", e.Message, 10);
            }
            finally
            {
                UpdateObservableRecords();
                CreateItemId = null;
            }
        }



        public async Task Edit()
        {
            await DataExchange.UpdateFromShadowsAsync();
            AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Edited!", "Item was successfully edited!", 10);
            UpdateObservableRecords();
        }

        public async Task SendToPlc()
        {
            await DataExchange.FromRepositoryToControllerAsync(SelectedRecord);
            AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Sended to PLC!", "Item was successfully sended to PLC!", 10);
        }

        public async Task LoadFromPlc()
        {
            try
            {
                await DataExchange.CreateDataFromControllerAsync(CreateItemId);
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Loaded from PLC!", "Item was successfully loaded from PLC!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Failed to create new record from the controller", e.Message, 10);
            }
            finally
            {
                await FillObservableRecordsAsync();
                CreateItemId = null;
            }


        }

        public Task ExportDataAsync(string path)
        {
            IsFileExported = false;

            return Task.Run(() =>
            {
                try
                {
                    DataExchange.ExportData(path, ExportSet.CustomExportData, ExportSet.ExportMode, ExportSet.FirstNumber, ExportSet.SecondNumber, ExportSet.ExportFileType, ExportSet.Separator);

                    IsFileExported = true;

                    AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Exported!", "Data was successfully exported!", 10);
                }
                catch (Exception e)
                {
                    AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Error!", e.Message, 10);
                }
            });
        }

        public Task ImportDataAsync(string path)
        {
            return Task.Run(() =>
            {
                try
                {
                    DataExchange.ImportData(path, Asp.GetAuthenticationStateAsync().Result, exportFileType: ExportSet.ExportFileType, separator: ExportSet.Separator);

                    this.UpdateObservableRecords();

                    AlertDialogService?.AddAlertDialog(eAlertDialogType.Success, "Imported!", "Data was successfully imported!", 10);
                }
                catch (Exception e)
                {
                    AlertDialogService?.AddAlertDialog(eAlertDialogType.Danger, "Error!", e.Message, 10);
                }
            });
        }

        public ObservableCollection<IBrowsableDataObject> Records { get; set; } = new ObservableCollection<IBrowsableDataObject>();
        public int Limit { get; set; } = 10;
        public string FilterById { get; set; } = "";
        public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;
        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;
        public string CreateItemId { get; set; }
        public bool IsBusy { get; set; }

        public ExportSettings ExportSet { get; set; } = new();

        public class ExportSettings
        {
            public Dictionary<string, ExportData> CustomExportData { get; set; } = new();
            public eExportMode ExportMode { get; set; } = eExportMode.First;
            public int FirstNumber { get; set; } = 50;
            public int SecondNumber { get; set; } = 100;
            public string ExportFileType { get; set; } = "CSV";
            public char Separator { get; set; } = ';';
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
            StateHasChangedDelegate.Invoke();
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
    }
}
