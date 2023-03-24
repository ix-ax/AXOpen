using ix.framework.core.blazor.Toaster;
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
        IBrowsableDataObject SelectedRecord { get; set; }
        Task FillObservableRecordsAsync();
        Task Filter();
        Task RefreshFilter();
        int Limit { get; set; }
        string FilterById { get; set; }
        eSearchMode SearchMode { get; set; }
        long FilteredCount { get; set; }
        int Page { get; set; }
        string CreateItemId { get; set; }

        bool IsBusy { get; set; }

        Task CreateNew();
        void Delete();
        Task Copy();
        Task Edit();
        Task SendToPlc();
        Task LoadFromPlc();

        event PropertyChangedEventHandler? PropertyChanged;
    }
}
