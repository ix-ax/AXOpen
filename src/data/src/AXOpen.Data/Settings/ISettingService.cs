namespace AXOpen.Data
{
    public interface ISettingService<T> where T : IDataSettingsBase
    {
        T Data { get; set; }

        void Load();

        void Save();
    }
}