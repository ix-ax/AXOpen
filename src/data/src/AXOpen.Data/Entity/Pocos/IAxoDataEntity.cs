using System.Collections.Generic;
using AXOpen.Data;
using AXSharp.Connector;

namespace Pocos.AXOpen.Data
{
    public partial interface IAxoDataEntity
    {
        public string DataEntityId { get; set; }
        List<ValueChangeItem> Changes { get; set; }
    }
}
