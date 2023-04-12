using System.Collections.Generic;
using AXOpen.Base.Data;
using AXOpen.Data;

namespace Pocos.AXOpen.Data
{
    public partial class AxoDataEntity : IBrowsableDataObject, IAxoDataEntity
    {
        public dynamic RecordId { get; set; }

        List<ValueChangeItem> changes = new List<ValueChangeItem>();
        public List<ValueChangeItem> Changes
        {
            get
            {
                return changes;
            }
            set
            {
                changes = value;
            }
        }
    }

}
