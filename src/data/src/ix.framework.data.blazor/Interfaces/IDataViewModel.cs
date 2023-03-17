using ix.framework.core.ViewModels;
using ix.framework.data;
using Ix.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.core.Interfaces
{
    public interface IDataViewModel
    {
        DataExchange DataExchange { get; }

        ObservableCollection<IBrowsableDataObject> Records { get; set; }

        Task FillObservableRecordsAsync();
        Task Filter();
        Task RefreshFilter();
        string DataEntityId { get; set; }
        int Limit { get; set; }
        string FilterById { get; set; }
        eSearchMode SearchMode { get; set; }
        long FilteredCount { get; set; }
        int Page { get; set; }

        bool IsBusy { get; set; }

        void CreateNew();

        event PropertyChangedEventHandler? PropertyChanged;
    }
}
