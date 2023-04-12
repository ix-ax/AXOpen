using System.Collections.Generic;
using AXSharp.Connector;
using AXOpen.Data;
using Ix.Base.Data;

namespace AXOpen.Data
{
    public partial class DataEntity : ICrudDataObject
    {
        public ValueChangeTracker ChangeTracker { get; private set; }

        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            ChangeTracker = new ValueChangeTracker(this);
        }

        public List<ValueChangeItem> Changes { get; set; }              
    }

}
