namespace AXOpen.Data
{
    using AXOpen.Data.Blazor;

    public class AxoDataExchangeConfiguration
    {
        public List<ColumnDataContent> Collumns { set; get; } = new();

        public bool EnableSorting { get; set; }

        public List<string> SortingExpressions { set; get; } = new();
    }
}