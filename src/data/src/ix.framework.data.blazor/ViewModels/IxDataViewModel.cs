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

namespace ix.framework.core.ViewModels
{
    public class IxDataViewModel : ObservableObject
    {
        public static IxDataViewModel<T> Create<T>(IRepository<T> repository, DataExchange dataExchange) where T : IBrowsableDataObject, new()
        {
            return new IxDataViewModel<T>(repository, dataExchange);
            
        }
    }

    public partial class IxDataViewModel<T> : ObservableObject, IDataViewModel where T : IBrowsableDataObject, new() 
    {

        public IxDataViewModel(IRepository<T> repository, DataExchange dataExchange) : base()
        {
    
            this.DataExchange = dataExchange;
            DataBrowser = CreateBrowsable(repository);
            Records = new ObservableCollection<IBrowsableDataObject>();
            FillObservableRecords();
        }

        private DataBrowser<T> CreateBrowsable(IRepository<T> repository)
        {
            return Ix.Base.Data.DataBrowser.Factory(repository);
        }

        public DataBrowser<T> DataBrowser { get; set; }
        public DataExchange DataExchange { get; }


        public ObservableCollection<IBrowsableDataObject> Records { get; set; }

        //ObservableCollection<IBrowsableDataObject> IDataViewModel.Records => throw new NotImplementedException();
        public int Limit { get; set; } = 10;
        public string FilterById { get; set; } = "";
        public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;
        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;
        public string SelectedItemId { get; set; }
        [Inject]
        private ToastService toastService { get; set; }


        //public Task FillObservableRecordsAsync()
        //{

        //    IsBusy = true;
        //    //let another thread to load records, we need main thread to show loading symbol in blazor page
        //    var records = Task.Run(() => FillObservableRecords());

        //    IsBusy = false;
        //    return records;

        //}
        [ObservableProperty]
        public bool isBusy;
        public void FillObservableRecords()
        {
            Records.Clear();
            DataBrowser.Filter(FilterById, Limit, Page * Limit, SearchMode);
         
            foreach (var item in DataBrowser.Records)
            {
                Records.Add(item);
            }

           
        }

        public void CreateNew(string? DataEntityId = null)
        {
            var plainer = ((dynamic)DataExchange)._data.CreateEmptyPoco() as Pocos.ix.framework.data.IDataEntity;

            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");

            if(DataEntityId != null)
                plainer.DataEntityId = DataEntityId;

            try
            {
                DataBrowser.AddRecord((dynamic)plainer);
            }
            catch (DuplicateIdException)
            {

            }

            var plain = DataBrowser.FindById(plainer.DataEntityId);
            ((dynamic)DataExchange)._data.PlainToShadowAsync(plain).Wait();
            FillObservableRecords();
            toastService.AddToast("info", "Create", "Successfuly created item!", 10);
        }

        public void Delete(string DataEntityId)
        {
            var plainer = ((dynamic)DataExchange)._data.CreateEmptyPoco() as Pocos.ix.framework.data.IDataEntity;

            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");

            plainer.DataEntityId = DataEntityId;

            DataBrowser.Delete((dynamic)plainer);
            FillObservableRecords();
        }

        public void Copy()
        {
            var plainer = ((dynamic)DataExchange)._data.CreateEmptyPoco() as Pocos.ix.framework.data.IDataEntity;

            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");

            //plainer.CopyShadowToPlain(((dynamic)DataExchange)._data);

            try
            {
                DataBrowser.AddRecord((dynamic)plainer);
            }
            catch (DuplicateIdException)
            {

            }
            var plain = DataBrowser.FindById(plainer.DataEntityId);
            ((dynamic)DataExchange)._data.PlainToShadowAsync(plain);
            FillObservableRecords();
        }

        public void Edit()
        {
            var a = ((dynamic)DataExchange)._data.CreatePlainerType();
            a.CopyShadowToPlain(((dynamic)DataExchange)._data);
            DataBrowser.UpdateRecord(a);
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
    }

    public class WrongTypeOfDataObjectException : Exception
    {
        public WrongTypeOfDataObjectException(string message) : base(message)
        {
            
        }
    }
}
