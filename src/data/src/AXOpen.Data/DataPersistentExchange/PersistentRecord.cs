using AXOpen.Base.Data;
using System.Collections.Generic;

namespace AXOpen.Data
{
    public class PersistentRecord : IBrowsableDataObject
    {
        private string _DataEntityId = "";
        public string DataEntityId { get => _DataEntityId; set => _DataEntityId = value; }
        public dynamic RecordId { set; get; }

        public List<TagObject> Tags = new();
    }
}