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

        // Added due to IBrowsableDataObject interface and compatibility with Prometheus.
        public DateTime? ModifiedAt { get { return _Modified; } set { _Modified = value.Value; } }

        // Added due to IBrowsableDataObject interface and compatibility with Prometheus.
        public DateTime? CreatedAt { get { return _Created; } set { _Created = value.Value; } }

        public List<TagObject> Tags = new();
    }
}