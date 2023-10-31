namespace AXOpen.Data
{
    public class AxoDataExchangeSettings : JsonFileSettingService<AxoDataExchangeSettingsData>
    {
        public AxoDataExchangeSettings(string DocumentName) : base(DocumentName)
        {
            Data.SettingsName = DocumentName;
        }

        public void SaveLoadedIdentifierToPlc(string identifier)
        {
            if (Data.EnableSavingIdentifiers)
            {
                Data.LastLoadedIdentifierToPlcController = identifier;
                this.Save();
            }
        }
        public void SaveUpdatedIdentifierFromPlc(string identifier)
        {
            if (Data.EnableSavingIdentifiers)
            {
                Data.LastUpdatedIdentifierFromPlcController = identifier;
                this.Save();
            }
        }
    }
}