using System.Collections.Generic;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;

namespace ix.framework.data
{
    public interface ICrudDataObject 
    {       
        OnlinerString DataEntityId { get; }        
        ValueChangeTracker ChangeTracker { get; }
        List<ValueChangeItem> Changes { get; set; }
    }
}
