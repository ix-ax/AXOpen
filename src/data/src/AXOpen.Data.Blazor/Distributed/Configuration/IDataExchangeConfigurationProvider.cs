namespace AXOpen.Data
{
   
    public interface IDataExchangeConfigurationProvider
    {
        void AddManagerConfiguration(string fullDataEntityNameWithSuffix, DataExchangeViewConfiguration config, bool addDeafultCollumns = true);

        DataExchangeViewConfiguration GetConfigution(IAxoDataExchange dataManager);

        DataExchangeViewConfiguration GetConfigution(string fullDataEntityTypeName);

        DataExchangeViewConfiguration GetConfigution(DataExchangeViewModel dataExchangeViewModel);
    }
}