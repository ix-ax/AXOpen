using AXOpen.Base.Data;

namespace AXOpen.Data
{
    public class PersistentRecord : IBrowsableDataObject
    {
        private string _DataEntityId = "";
        public string DataEntityId { get => _DataEntityId; set => _DataEntityId = value; }
        public dynamic RecordId { set; get; }

        public DateTime _Created { set; get; }
        public DateTime _Modified { set; get; }

        public List<TagObject> Tags = new();
    }
}