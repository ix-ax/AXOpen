using AXOpen.Base.Data;
using System;
using System.Collections.Generic;

namespace Security
{
    public class RoleModel : IBrowsableDataObject
    {
        public string ConcurrencyStamp { get; set; }
        public string Name { get; set; }
        public string NormalizedName { get; set; }
        public dynamic RecordId { get; set ; }
        public DateTime _Created { get; set ; }
        public string DataEntityId { get; set; }
        public DateTime _Modified { get ; set; }
    }
}
