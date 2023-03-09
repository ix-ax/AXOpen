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
            //FillObservableRecords();
        }

        private DataBrowser<T> CreateBrowsable(IRepository<T> repository)
        {
            return Ix.Base.Data.DataBrowser.Factory(repository);
        }

        public DataBrowser<T> DataBrowser { get; set; }
        public DataExchange DataExchange { get; }

    }
}
