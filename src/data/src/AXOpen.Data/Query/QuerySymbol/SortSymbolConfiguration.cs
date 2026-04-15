using System.Text.Json.Serialization;

namespace AXOpen.Data.Query
{
    // class that will handle sort configuration, it will be transromt to SortSettings
    public class SortSymbolConfiguration : SymbolConfiguration
    {
        [JsonConstructor]
        public SortSymbolConfiguration(string parentFullTypeName, string symbolPathWithParent, string symbolTypeFullName, bool isAscending) : base(parentFullTypeName, symbolPathWithParent, symbolTypeFullName)
        {
            this.IsAscending = isAscending;
        }

        public bool IsAscending { get; set; }
    }
}
