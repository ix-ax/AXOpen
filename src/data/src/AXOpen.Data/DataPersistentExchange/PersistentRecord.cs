using AXOpen.Base.Data;
using Microsoft.AspNetCore.Http.HttpResults;

namespace AXOpen.Data
{
    public class PersistentRecord : IBrowsableDataObject
    {
        private string __EntityId = "";
        public string _EntityId { get => __EntityId; set => __EntityId = value; }
        public dynamic RecordId { set; get; }

        public DateTime _Created { set; get; }
        public DateTime _Modified { set; get; }

        public List<TagObject> Tags = new();
    }
}