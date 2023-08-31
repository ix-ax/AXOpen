using System.Collections.Generic;
using AXSharp.Connector;
using AXOpen.Data;
using AXOpen.Base.Data;

namespace AXOpen.Data
{
    public partial class AxoDataEntity : ICrudDataObject
    {
        public ValueChangeTracker ChangeTracker { get; private set; }

        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            ChangeTracker = new ValueChangeTracker(this);
        }

        public List<ValueChangeItem> Changes { get; set; }

        public string Hash { get; set; }

        public object? LockedBy { get; set; } = null;
    }

}
