using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data.Query;

namespace AXOpen.Data.Interfaces
{
    public interface IDataExchangeViewModel
    {
        ObservableCollection<IBrowsableDataObject> Records { get; set; }
        IBrowsableDataObject SelectedRecord { get; set; }

        public Task FillObservableRecordsAsync(PredicateContainer? predicates = null);

        Task Filter();

        Task CreateNew();

        Task Delete();

        Task Copy();

        Task Edit();

        Task SendToPlc();

        Task LoadFromPlc();

        IDistributedDataActions? DistributedActions { get; }

        public void InvokeStateHasChanged();
    }
}