using AXOpen.Base.Data;
using System.Collections.ObjectModel;

namespace AxOpen.Security
{
    public class Group : IBrowsableDataObject
    {
        public dynamic RecordId { get; set; }
        public string _EntityId { get; set; }
        public string Name { get; set; }
        public ObservableCollection<string> Roles { get; set; }
        public string RolesHash { get; set; }
        public DateTime Created { get; set; }
        public DateTime Modified { get; set; }

        // Added due to IBrowsableDataObject interface and compatibility with Prometheus.
        public DateTime? ModifiedAt { get { return Modified; } set { Modified = value.Value; } }

        // Added due to IBrowsableDataObject interface and compatibility with Prometheus.
        public DateTime? CreatedAt { get { return Created; } set { Created = value.Value; } }


        public List<string> Changes = new List<string>();

        public Group(string name)
        {
            Name = name;
            Roles = new ObservableCollection<string>();
            Created = DateTime.Now;
            Modified = DateTime.Now;
        }
    }
}
