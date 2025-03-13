namespace AXOpen.Data
{
    public partial class DataExchangeViewModel
    {
        public class ExportSettings
        {
            public Dictionary<string, ExportData> CustomExportData { get; set; } = new();
            public eExportMode ExportMode { get; set; } = eExportMode.First;
            public uint FirstNumber { get; set; } = 50;
            public uint SecondNumber { get; set; } = 100;
            public string ExportFileType { get; set; } = "CSV";
            public char Separator { get; set; } = ';';
        }
    }
}