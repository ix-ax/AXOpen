namespace AXOpen.Data
{

    public class DataExchangeViewConfiguration
    {
        public List<ColumnDataContent> Collumns { set; get; } = new();

        public bool EnableSorting { get; set; }

        public List<string> SortingExpressions { set; get; } = new();
    }
}