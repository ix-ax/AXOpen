using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using ix.framework.core.Interfaces;
using Ix.Base.Data;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ix.framework.data;
using System.Collections.ObjectModel;
using System.Runtime.CompilerServices;
using ix.framework.core.blazor.Toaster;
using Microsoft.AspNetCore.Components;
using CommunityToolkit.Mvvm.Messaging;
using Ix.Connector;
using System.Threading.Channels;

namespace ix.framework.core.ViewModels
{
    public class IxDataViewModel : ObservableObject
    {
        public static IxDataViewModel<T,O> Create<T,O>(IRepository<T> repository, DataExchange dataExchange) where T : IBrowsableDataObject, new() 
            where O : class
        {
            return new IxDataViewModel<T,O>(repository, dataExchange);
            
        }
    }

    public partial class IxDataViewModel<T,O> : ObservableObject, IDataViewModel where T : IBrowsableDataObject, new() where O : class
    {

        public IxDataViewModel(IRepository<T> repository, DataExchange dataExchange) : base()
        { 
    
            this.DataExchange = dataExchange;
            DataBrowser = CreateBrowsable(repository);
            Records = new ObservableCollection<IBrowsableDataObject>();
            _data = DataExchange.GetData<O>();
            
        }

        private O _data { get; }

        public ITwinObject Data { get => (ITwinObject)_data; }

        private DataBrowser<T> CreateBrowsable(IRepository<T> repository)
        {
            return Ix.Base.Data.DataBrowser.Factory(repository);
        }

        public DataBrowser<T> DataBrowser { get; set; }
        public DataExchange DataExchange { get; }


        List<ValueChangeItem> changes;
        public List<ValueChangeItem> Changes
        {
            get
            {
                return changes;
            }
            set
            {
                changes = value;
            }
        }

        IBrowsableDataObject selectedRecord;
        public IBrowsableDataObject SelectedRecord
        {
            get
            {
                return selectedRecord;
            }

            set
            {
                if (selectedRecord == value)
                {
                    return;
                }

                ((ICrudDataObject)Data).ChangeTracker.StopObservingChanges();
                selectedRecord = value;
                if (value != null)
                {
                    Data.PlainToShadow(value);
                    ((ICrudDataObject)Data).Changes = ((Pocos.ix.framework.data.IDataEntity)selectedRecord).Changes;
                    Changes = ((ICrudDataObject)Data).Changes;
                }

                ((ICrudDataObject)Data).ChangeTracker.StartObservingChanges();

            }
        }


        public Task FillObservableRecordsAsync()
        {

            //let another thread to load records, we need main thread to show loading symbol in blazor page
            return Task.Run(async () => {
                IsBusy = true;
                FillObservableRecords();
                IsBusy = false;
            });

        }
        
        public void FillObservableRecords()
        {
            Records.Clear();
            DataBrowser.Filter(FilterById, Limit, Page * Limit, SearchMode);
         
            foreach (var item in DataBrowser.Records)
            {
                Records.Add(item);
            }
            FilteredCount = DataBrowser.FilteredCount(FilterById, SearchMode);
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

        public void CreateNew()
        {
            var plainer = Data.CreatePoco() as Pocos.ix.framework.data.IDataEntity;
            
            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");

            if (CreateItemId != null)
                plainer.DataEntityId = CreateItemId;

            try
            {
                DataBrowser.AddRecord((T)plainer);
                WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Created!", "Item was successfully created!", 30)));
            }
            catch (DuplicateIdException)
            {
                WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Duplicate ID!", "Item with the same ID already exists!", 30)));
            }

            var plain = DataBrowser.FindById(plainer.DataEntityId);
            Data.PlainToShadow(plain);
            FillObservableRecords();
            CreateItemId = null;
        }

        public void Delete()
        {
            var data = _data as DataEntity;
            var plainer = data.CreatePoco() as Pocos.ix.framework.data.IDataEntity;
            
            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");

            plainer.DataEntityId = SelectedRecord.DataEntityId;

            DataBrowser.Delete((T)plainer);
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Deleted!", "Item was successfully deleted!", 30)));
            FillObservableRecords();
        }

        

        public void Copy()
        {

            var plainer = Data.ShadowToPlain<T>();
            plainer.DataEntityId =  $"Copy of {SelectedRecord.DataEntityId}"; ;


            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");

            try
            {
               DataBrowser.AddRecord((T)plainer);
            }
            catch (DuplicateIdException)
            {

            }
            var foundPlain = DataBrowser.FindById(plainer.DataEntityId);
            Data.PlainToShadow(foundPlain);
            FillObservableRecords();
        }

        public void Edit()
        {
            var plainer = Data.ShadowToPlain<T>();
            //Selecte
            ((ICrudDataObject)Data).ChangeTracker.SaveObservedChanges(plainer);
            DataBrowser.UpdateRecord(plainer);
            FillObservableRecords();
        }

        public void SendToPlc()
        {
            //((dynamic)DataExchange)._data.FlushPlainToOnline((dynamic)this.SelectedRecord);
            ////}, $"{((dynamic)DataExchange)._data._EntityId}", () => MessageBox.Show($"{strings.LoadToController} '{((dynamic)this.SelectedRecord)._EntityId}'?", "Data", MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes);
            //LogCommand("SendToPlc");
        }

        public void FromPlc()
        {
            //var plainer = ((dynamic)DataExchange)._data.CreatePlainerType();
            //((dynamic)DataExchange)._data.FlushOnlineToPlain(plainer);
            //plainer._EntityId = $"{DataHelpers.CreateUid().ToString()}";
            //DataBrowser.AddRecord(plainer);
            //var plain = DataBrowser.FindById(plainer._EntityId);
            //((dynamic)DataExchange)._data.CopyPlainToShadow(plain);
            //FillObservableRecords();
            //SelectedRecord = plain;
            //this.Mode = ViewMode.Edit;
            //ViewModeEdit();
            //LogCommand("LoadFromPlc");
        }

        public ObservableCollection<IBrowsableDataObject> Records { get; set; }

        public int Limit { get; set; } = 10;
        public string FilterById { get; set; } = "";
        public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;
        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;
        public string CreateItemId { get; set; }

        public bool IsBusy { get; set; }
    }

    public class WrongTypeOfDataObjectException : Exception
    {
        public WrongTypeOfDataObjectException(string message) : base(message)
        {
            
        }
    }
}
