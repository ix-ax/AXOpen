using System.Collections.Generic;
using AXOpen.Base.Data;
using AXOpen.Data;
using AXSharp.Connector;

namespace Pocos.AXOpen.Data
{
    public partial interface IAxoDataEntity : IBrowsableDataObject
    {
        public string DataEntityId { get; set; }
        List<ValueChangeItem> Changes { get; set; }

        string Hash { get; set; }
    }
}
