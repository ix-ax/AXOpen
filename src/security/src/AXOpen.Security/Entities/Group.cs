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
        public DateTime _Created { get; set; }
        public DateTime _Modified { get; set; }

        public List<string> Changes = new List<string>();

        public Group(string name)
        {
            Name = name;
            Roles = new ObservableCollection<string>();
            _Created = DateTime.Now;
            _Modified = DateTime.Now;
        }
    }
}
