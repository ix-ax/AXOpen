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

namespace ix.framework.core.ViewModels
{
    public class IxDataViewModel
    {
        public static IxDataViewModel<T> Create<T>(IRepository<T> repository, DataExchange dataExchange) where T : IBrowsableDataObject, new()
        {
            return new IxDataViewModel<T>(repository, dataExchange);
        }
    }

    public class IxDataViewModel<T> : IDataViewModel where T : IBrowsableDataObject, new()
    {

        public IxDataViewModel(IRepository<T> repository, DataExchange dataExchange) : base()
        {
            this.DataExchange = dataExchange;
            DataBrowser = CreateBrowsable(repository);
            FillObservableRecords();
        }

        private DataBrowser<T> CreateBrowsable(IRepository<T> repository)
        {
            return Ix.Base.Data.DataBrowser.Factory(repository);
        }

        public DataBrowser<T> DataBrowser { get; set; }
        public DataExchange DataExchange { get; }

        readonly List<IBrowsableDataObject> observableRecords = new();
        public List<IBrowsableDataObject> ObservableRecords
        {
            get
            {
                return observableRecords;
            }
        }

        internal void FillObservableRecords()
        {
            ObservableRecords.Clear();

            foreach (var item in DataBrowser.Records)
            {
                ObservableRecords.Add(item);
            }
        }

        public void CreateNew()
        {
            var plainer = ((dynamic)DataExchange)._data.CreatePlainerType();
            plainer._EntityId = "10";
            try
            {
                DataBrowser.AddRecord(plainer);
            }
            catch (DuplicateIdException)
            {

            }

            var plain = DataBrowser.FindById(plainer._EntityId);
            ((dynamic)DataExchange)._data.CopyPlainToShadow(plain);
            FillObservableRecords();
        }
    }
}
