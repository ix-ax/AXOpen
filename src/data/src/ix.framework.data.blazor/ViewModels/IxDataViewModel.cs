﻿using CommunityToolkit.Mvvm.ComponentModel;
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

        public void CreateNew()
        {
            var plainer = ((dynamic)DataExchange)._data.CreateEmptyPoco() as Pocos.ix.framework.data.IDataEntity;

            if (plainer == null)
                throw new WrongTypeOfDataObjectException(
                    $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.ix.framework.data.IDataEntity)}");
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
        }
    }

    public class WrongTypeOfDataObjectException : Exception
    {
        public WrongTypeOfDataObjectException(string message) : base(message)
        {
            
        }
    }
}
