using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector.ValueTypes;


namespace AXOpen.Data
{
    public partial interface IAxoDataEntity
    {
        OnlinerString DataEntityId { get; }
        object LockedBy { get; set; }
    }
}

