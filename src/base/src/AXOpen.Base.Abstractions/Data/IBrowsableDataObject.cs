using System;

namespace AXOpen.Base.Data
{
    public interface IBrowsableDataObject
    {
        dynamic RecordId { get; set; }
      
        string _EntityId { get; set; }        
    }
}