using System.Collections.Generic;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;

namespace AXOpen.Data
{
    public interface ICrudDataObject 
    {       
        OnlinerString _EntityId { get; }        
        ValueChangeTracker ChangeTracker { get; }
        List<ValueChangeItem> Changes { get; set; }
    }
}
