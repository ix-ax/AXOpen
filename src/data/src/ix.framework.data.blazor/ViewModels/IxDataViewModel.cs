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
        }

        private DataBrowser<T> CreateBrowsable(IRepository<T> repository)
        {
            return Ix.Base.Data.DataBrowser.Factory(repository);
        }

        public DataBrowser<T> DataBrowser { get; set; }
        public DataExchange DataExchange { get; }


        public ObservableCollection<IBrowsableDataObject> Records { get; set; }

        public int Limit { get; set; } = 10;
        public string FilterById { get; set; } = "";
        public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;
        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;


        public Task FillObservableRecordsAsync()
        {

            //let another thread to load records, we need main thread to show loading symbol in blazor page
            return Task.Run(() => {
                IsBusy = true;
                FillObservableRecords();
                IsBusy = false;
            });

        }
 
        public bool IsBusy { get; set; }
        public void FillObservableRecords()
        {
            Records.Clear();
            DataBrowser.Filter(FilterById, Limit, Page * Limit, SearchMode);
         
            foreach (var item in DataBrowser.Records)
            {
                Records.Add(item);
            }
           
        }
        public string DataEntityId { get; set; }
        public void CreateNew()
        {
            var plainer = ((dynamic)DataExchange)._data.CreateEmptyPoco() as Pocos.ix.framework.data.IDataEntity;
            if (DataEntityId != null)
            {
                plainer.DataEntityId = DataEntityId;
            }
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
            DataEntityId = null;
        }


        public async Task Filter()
        {
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
    }

    public class WrongTypeOfDataObjectException : Exception
    {
        public WrongTypeOfDataObjectException(string message) : base(message)
        {
            
        }
    }
}
