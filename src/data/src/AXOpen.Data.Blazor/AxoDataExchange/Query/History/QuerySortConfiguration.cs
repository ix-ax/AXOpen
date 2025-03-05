using System.Security.Cryptography;
using System.Text;

namespace AXOpen.Data.Query
{
    public class QuerySortConfiguration
    {
        public string Name { get; set; }
        public DateTime Modified { get; set; }

        public List<QuerySymbolConfiguration> Queries { get; set; } = new();
        public List<SortSymbolConfiguration> Sorting { get; set; } = new();
    }
}