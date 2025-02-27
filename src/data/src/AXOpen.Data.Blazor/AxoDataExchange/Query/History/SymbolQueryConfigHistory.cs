using System.Security.Cryptography;
using System.Text;

namespace AXOpen.Data.Query
{
    public class SymbolQueryConfigHistory
    {
        public string Name { get; set; }
        public DateTime Modified { get; set; }

        public List<QuerySymbolConfiguration> Queries { get; set; } = new();
        public List<SortSymbolConfiguration> Sorting { get; set; } = new();

        public void AddQueries(List<QuerySymbolConfiguration> newConfiguraion)
        {
            this.Modified = DateTime.Now;
            Queries = new List<QuerySymbolConfiguration>(newConfiguraion);
        }

        public void AddSorting(List<SortSymbolConfiguration> newConfiguraion)
        {
            this.Modified = DateTime.Now;
            Sorting = new List<SortSymbolConfiguration>(newConfiguraion);
        }

        public static string GetSymbolsGuidHash(List<QuerySymbolConfiguration> newConfiguraion)
        {
            using var sha256 = SHA1.Create();
            var data = string.Concat(newConfiguraion.Select(c => c.TrackSymbolId));
            return Convert.ToHexString(sha256.ComputeHash(Encoding.UTF8.GetBytes(data))).ToLower();
        }
    }
}