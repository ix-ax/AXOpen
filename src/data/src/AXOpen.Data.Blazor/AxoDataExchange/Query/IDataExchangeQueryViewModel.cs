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
    public interface IDataExchangeQueryViewModel
    {
        IEnumerable<Type> GetPlainTypes();

        PredicateContainer ExternalPredicates { get;  } // expose for merging queries
        // List<string> ExternalEntityIds { get;  }

        void SetExternalPredicates(PredicateContainer externalPredicates);
        void SetExternalEntityIds(List<string> entityIds); //  null-will be initialized, [0..xx] valid range-display
        void ResetExternalEntityIds();// implicitly tells to disable external ids
        Task FillObservableRecordsAsync(PredicateContainer? predicates = null);
        public void InvokeStateHasChanged();
    }
}
