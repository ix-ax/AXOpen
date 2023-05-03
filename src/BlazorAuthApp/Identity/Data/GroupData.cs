using Ix.Base.Data;
using System.Collections.ObjectModel;

namespace BlazorAuthApp.Identity.Data
{
    public class GroupData : IBrowsableDataObject
    {
        private string _name;
        public ObservableCollection<string> Roles { get; set; }
        public string SecurityStamp { get; set; }
        public dynamic RecordId { get; set; }
        public DateTime _Created { get; set; }
        public string DataEntityId { get; set; }
        public DateTime _Modified { get; set; }

        public GroupData(string name)
        {
            Name = name;
            Roles = new ObservableCollection<string>();
        }

        public string Name
        {
            get => _name; set
            {
                _name = value;
            }
        }

        private List<string> _changes = new List<string>();
        public List<string> Changes
        {
            get { return this._changes; }
            set { this._changes = value; }
        }
    }
}
