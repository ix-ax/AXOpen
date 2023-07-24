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
using AXOpen.Core;
using AXSharp.Connector.ValueTypes.Online;
using AXSharp.Connector;
using CommunityToolkit.Mvvm.Messaging;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Linq.Expressions;
using System.Numerics;
using AXSharp.Abstractions.Dialogs.AlertDialog;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Newtonsoft.Json.Linq;
using System.ComponentModel;

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

        public bool IsFileExported { get; set; } = false;
        public List<ValueChangeItem> Changes { get; set; }

        public IAlertDialogService AlertDialogService { get; set; }

        private IBrowsableDataObject _selectedRecord;

        public IBrowsableDataObject SelectedRecord
        {
            get
            {
                return _selectedRecord;
            }

            set
            {
                // CrudData.ChangeTracker.StopObservingChanges();
                _selectedRecord = value;
                if (value != null)
                {
                    DataExchange.FromRepositoryToShadowsAsync(value);
                    //--((ITwinObject)DataExchange.Data).PlainToShadow(value).Wait();
                    //CrudData.Changes = ((Pocos.AXOpen.Data.IAxoDataEntity)_selectedRecord).Changes;
                    //Changes = CrudData.Changes;
                }

                // CrudData.ChangeTracker.StartObservingChanges();

            }
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
                    AlertDialogService.AddAlertDialog("Danger", "Cannot create!", "New entry name cannot be empty. Please provide an ID", 10);
                    return;
                }

                await DataExchange.CreateNewAsync(CreateItemId);
                AlertDialogService.AddAlertDialog("Success", "Created!", "Item was successfully created!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog("Danger", "Failed to create new record!", e.Message, 10);
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
                AlertDialogService.AddAlertDialog("Success", "Deleted!", "Item was successfully deleted!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog("Danger", "Failed to delete", e.Message, 10);
            }
            finally
            {
                UpdateObservableRecords();
            }


            //-- var plainer = ((ITwinObject)DataExchange.Data).CreatePoco() as Pocos.AXOpen.Data.AxoDataEntity;

            //if (plainer == null)
            //    throw new WrongTypeOfDataObjectException(
            //        $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.AXOpen.Data.IAxoDataEntity)}");
            //plainer.DataEntityId = SelectedRecord.DataEntityId;

            //DataExchange.Repository.Delete(((IBrowsableDataObject)plainer).DataEntityId);
            //SelectedRecord = null;
            //WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Deleted!", "Item was successfully deleted!", 10)));

        }

        public async Task Copy()
        {
            try
            {
                await DataExchange.CreateCopyCurrentShadowsAsync(CreateItemId);
                AlertDialogService.AddAlertDialog("Success", "Copied!", "Item was successfully copied!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog("Danger", "Failed to copy!", e.Message, 10);
            }
            finally
            {
                UpdateObservableRecords();
                CreateItemId = null;
            }
        }

        public IEnumerable<DataItemValidation> UpdateRecord(Pocos.AXOpen.Data.AxoDataEntity data)
        {
            //var validations = DataExchange.Repository.OnRecordUpdateValidation(data);
            //if (!validations.Any(p => p.Failed))
            {
                DataExchange.Repository.Update(((IBrowsableDataObject)data).DataEntityId, data);
            }
            //return validations;
            return null;
        }

        public async Task Edit()
        {
            //--var plainer = await ((ITwinObject)DataExchange.Data).ShadowToPlain<dynamic>();
            ////CrudData.ChangeTracker.SaveObservedChanges(plainer);
            //UpdateRecord(plainer);
            //SelectedRecord = plainer;

            await DataExchange.UpdateFromShadowsAsync();
            AlertDialogService.AddAlertDialog("Success", "Edited!", "Item was successfully edited!", 10);
            UpdateObservableRecords();
        }

        public async Task SendToPlc()
        {
            //-- await ((ITwinObject)DataExchange.Data).PlainToOnline(SelectedRecord);
            await DataExchange.FromRepositoryToControllerAsync(SelectedRecord);
            AlertDialogService.AddAlertDialog("Success", "Sended to PLC!", "Item was successfully sended to PLC!", 10);
        }

        public async Task LoadFromPlc()
        {
            try
            {
                await DataExchange.CreateDataFromControllerAsync(CreateItemId);
                AlertDialogService.AddAlertDialog("Success", "Loaded from PLC!", "Item was successfully loaded from PLC!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog("Danger", "Failed to create new record from the controller", e.Message, 10);
            }
            finally
            {
                await FillObservableRecordsAsync();
                CreateItemId = null;
            }

            //---var plainer = await ((ITwinObject)DataExchange.Data).OnlineToPlain<dynamic>();

            //if (CreateItemId != null)
            //    plainer.DataEntityId = CreateItemId;

            //try
            //{
            //    DataExchange.Repository.Create(plainer.DataEntityId, plainer);
            //    WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Loaded from PLC!", "Item was successfully loaded from PLC!", 10)));
            //}
            //catch (DuplicateIdException)
            //{
            //    WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Duplicate ID!", "Item with the same ID already exists!", 10)));
            //}
            //var plain = FindById(plainer.DataEntityId);
            //await ((ITwinObject)DataExchange.Data).PlainToShadow(plain);
            //FillObservableRecords();
            //CreateItemId = null;
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

                    AlertDialogService.AddAlertDialog("Success", "Exported!", "Data was successfully exported!", 10);
                }
                catch (Exception e)
                {
                    AlertDialogService.AddAlertDialog("Danger", "Error!", e.Message, 10);
                }
            });
        }

        public Task ImportDataAsync(string path)
        {
            return Task.Run(() =>
            {
                try
                {
                    DataExchange.ImportData(path, separator: ExportSet.Separator);

                    this.UpdateObservableRecords();

                    AlertDialogService.AddAlertDialog("Success", "Imported!", "Data was successfully imported!", 10);
                }
                catch (Exception e)
                {
                    AlertDialogService.AddAlertDialog("Danger", "Error!", e.Message, 10);
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
            public eFileType ExportFileType { get; set; } = eFileType.csv;
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
