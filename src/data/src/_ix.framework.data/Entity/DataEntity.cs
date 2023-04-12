using System.Collections.Generic;
using AXSharp.Connector;
using ix.framework.data;
using Ix.Base.Data;

namespace ix.framework.data
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
