using System;

namespace AXOpen.Base.Data
{
    public interface IBrowsableDataObject
    {
        dynamic RecordId { get; set; }
      
        string DataEntityId { get; set; }        
    }
}