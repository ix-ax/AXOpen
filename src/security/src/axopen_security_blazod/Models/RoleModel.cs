using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AxOpen.Security.Models
{
    public class RoleModel 
    {
        public string ConcurrencyStamp { get; set; }
        public string Name { get; set; }
        public string NormalizedName { get; set; }
        public dynamic _recordId { get; set ; }
        public DateTime _Created { get; set ; }
        public string _EntityId { get; set; }
        public DateTime _Modified { get ; set; }
    }
}
