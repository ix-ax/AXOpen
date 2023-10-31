namespace AXOpen.Data
{
    public class AxoDataExchangeSettingsData : IDataSettingsBase
    {
        public AxoDataExchangeSettingsData() : base()
        {
        }

        /// <summary>
        /// Document name
        /// </summary>
        public string SettingsName { set; get; }

        /// <summary>
        /// Time when document was updated
        /// </summary>
        public DateTime Updated { set; get; }

        public string LastLoadedIdentifierToPlcController { set; get; } = "";
        public string LastUpdatedIdentifierFromPlcController { set; get; } = "";
        public bool EnableSavingIdentifiers { set; get; }
    }
}