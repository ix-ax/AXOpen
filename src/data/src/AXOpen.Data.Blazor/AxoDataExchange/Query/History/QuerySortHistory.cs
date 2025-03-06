using System.Security.Cryptography;
using System.Text;

namespace AXOpen.Data.Query
{
    public class QuerySortHistory
    {
        public string LastSelectedItemName { get; set; } = "";

        public List<QuerySortConfiguration> Items { get; set; } = new();
    }
}