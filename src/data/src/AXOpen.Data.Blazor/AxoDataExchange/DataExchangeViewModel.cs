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
using CommunityToolkit.Mvvm.Messaging;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Linq.Expressions;
using System.Numerics;
using AXSharp.Abstractions.Dialogs.AlertDialog;
using Microsoft.AspNetCore.Components;

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
                if (_selectedRecord == value)
                {
                    return;
                }

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
                    AlertDialogService.AddAlertDialog(eDialogType.Danger, "Cannot create!", "New entry name cannot be empty. Please provide an ID", 10);
                    return;
                }

                await DataExchange.CreateNewAsync(CreateItemId);
                AlertDialogService.AddAlertDialog(eDialogType.Success, "Created!", "Item was successfully created!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog(eDialogType.Danger, "Failed to create new record!", e.Message, 10);
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
                AlertDialogService.AddAlertDialog(eDialogType.Success, "Deleted!", "Item was successfully deleted!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog(eDialogType.Danger, "Failed to delete", e.Message, 10);
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
                AlertDialogService.AddAlertDialog(eDialogType.Success, "Copied!", "Item was successfully copied!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog(eDialogType.Danger, "Failed to copy!", e.Message, 10);
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
            AlertDialogService.AddAlertDialog(eDialogType.Success, "Edited!", "Item was successfully edited!", 10);
            UpdateObservableRecords();
        }

        public async Task SendToPlc()
        {
            //-- await ((ITwinObject)DataExchange.Data).PlainToOnline(SelectedRecord);
            await DataExchange.FromRepositoryToControllerAsync(SelectedRecord);
            AlertDialogService.AddAlertDialog(eDialogType.Success, "Sended to PLC!", "Item was successfully sended to PLC!", 10);
        }

        public async Task LoadFromPlc()
        {
            try
            {
                await DataExchange.CreateDataFromControllerAsync(CreateItemId);
                AlertDialogService.AddAlertDialog(eDialogType.Success, "Loaded from PLC!", "Item was successfully loaded from PLC!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog(eDialogType.Danger, "Failed to create new record from the controller", e.Message, 10);
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

        public IEnumerable<string> Export(Expression<Func<IPlain, bool>> expression, char separator = ';')
        {
            ////var onliner = typeof(T).Name.Replace("Plain", string.Empty);
            //var onliner = typeof(IBrowsableDataObject).FullName.Replace("Pocos.", string.Empty);

            //var adapter = new AXSharp.Connector.ConnectorAdapter(typeof(DummyConnectorFactory));
            //var dummyConnector = adapter.GetConnector(new object[] { });

            ////var onlinerType = Assembly.GetAssembly(typeof(T)).GetTypes().FirstOrDefault(p => p.Name == onliner);
            //var onlinerType = Assembly.GetAssembly(typeof(IBrowsableDataObject)).GetTypes().FirstOrDefault(p => p.FullName == onliner);
            //var prototype = Activator.CreateInstance(onlinerType, new object[] { dummyConnector, "_data", "_data" }) as ITwinObject;
            //var exportables = DataExchange.Repository.Queryable.Where(expression);
            //var itemExport = new StringBuilder();
            //var export = new List<string>();

            //// Create header
            //var valueTags = prototype.RetrievePrimitives();
            //foreach (var valueTag in valueTags)
            //{
            //    itemExport.Append($"{valueTag.Symbol}{separator}");
            //}

            //export.Add(itemExport.ToString());
            //itemExport.AppendLine();

            //itemExport.Clear();
            //foreach (var valueTag in valueTags)
            //{
            //    itemExport.Append($"{valueTag.HumanReadable}{separator}");
            //}

            //export.Add(itemExport.ToString());
            //itemExport.AppendLine();


            //foreach (var document in exportables)
            //{
            //    itemExport.Clear();
            //    ((dynamic)prototype).PlainToShadow(document);
            //    var values = prototype.RetrievePrimitives();
            //    foreach (var @value in values)
            //    {
            //        var val = (string)(((dynamic)@value).Shadow.ToString());
            //        if (val.Contains(separator))
            //        {
            //            val = val.Replace(separator, '►');
            //        }

            //        itemExport.Append($"{val}{separator}");
            //    }

            //    export.Add(itemExport.ToString());

            //}

            //return export;
            return null;

        }

        public void Import(IEnumerable<string> records, ITwinObject crudDataObject = null, char separator = ';')
        {
            //var documents = records.ToArray();
            //var header = documents[0];

            //var headerItems = header.Split(separator);
            //var dictionary = new List<ImportItems>();

            //// Prepare swappable object
            //var onliner = typeof(T).FullName.Replace("Pocos.", string.Empty);

            //var adapter = new AXSharp.Connector.ConnectorAdapter(typeof(DummyConnectorFactory));
            //var dummyConnector = adapter.GetConnector(new object[] { });

            //var onlinerType = Assembly.GetAssembly(typeof(T)).GetTypes().FirstOrDefault(p => p.FullName == onliner);

            //ITwinObject prototype;

            //if (crudDataObject == null)
            //    prototype = Activator.CreateInstance(onlinerType, new object[] { dummyConnector, "_data", "_data" }) as ITwinObject;
            //else
            //    prototype = crudDataObject;

            //var valueTags = prototype.RetrievePrimitives();

            //// Get headered dictionary
            //foreach (var headerItem in headerItems)
            //{
            //    dictionary.Add(new ImportItems() { Key = headerItem });
            //}


            //// Load values
            //for (int i = 2; i < documents.Count(); i++)
            //{
            //    var documentItems = documents[i].Split(separator);
            //    for (int a = 0; a < documentItems.Count(); a++)
            //    {
            //        dictionary[a].Value = documentItems[a];
            //    }

            //    UpdateDocument(dictionary, valueTags, prototype);
            //}



        }

        public void ExportData()
        {
            try
            {
                var exports = this.Export(p => true);

                using (var sw = new StreamWriter("wwwroot/exportData.csv"))
                {
                    foreach (var item in exports)
                    {
                        sw.Write(item + "\r");
                    }
                }
                AlertDialogService.AddAlertDialog(eDialogType.Success, "Exported!", "Data was successfully exported!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog(eDialogType.Danger, "Error!", e.Message, 10);
            }
        }

        public void ImportData()
        {
            try
            {
                var imports = new List<string>();
                foreach (var item in File.ReadAllLines("importData.csv"))
                {
                    imports.Add(item);
                }

                this.Import(imports);
                this.UpdateObservableRecords();
                AlertDialogService.AddAlertDialog(eDialogType.Success, "Imported!", "Data was successfully imported!", 10);
            }
            catch (Exception e)
            {
                AlertDialogService.AddAlertDialog(eDialogType.Danger, "Error!", e.Message, 10);
            }
        }

        public ObservableCollection<IBrowsableDataObject> Records { get; set; } = new ObservableCollection<IBrowsableDataObject>();

        public int Limit { get; set; } = 10;
        public string FilterById { get; set; } = "";
        public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;
        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;
        public string CreateItemId { get; set; }
        public bool IsBusy { get; set; }
    }
}
