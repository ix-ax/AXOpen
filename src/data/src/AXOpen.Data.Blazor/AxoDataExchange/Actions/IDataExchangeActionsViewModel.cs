using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector;
using AXOpen.Base.Data.Query;

namespace AXOpen.Data
{
    public interface IDataExchangeActionsViewModel
    {
        IEnumerable<Type> GetPlainTypes();
        PredicateContainer InjectedPredicateContainer { get; set; }
        Task FillObservableRecordsAsync(PredicateContainer? predicates = null);
        public void InvokeStateHasChanged();
    }
}
