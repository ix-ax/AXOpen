namespace AXOpen.Data
{
    public interface IDataSettingsBase
    {
        string SettingsName { set; get; }

        DateTime Updated { get; set; }
    }
}