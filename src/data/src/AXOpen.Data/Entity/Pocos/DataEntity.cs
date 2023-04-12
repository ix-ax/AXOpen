using System.Collections.Generic;
using Ix.Base.Data;
using AXOpen.Data;

namespace Pocos.AXOpen.Data
{
    public partial class DataEntity : IBrowsableDataObject, IDataEntity
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
