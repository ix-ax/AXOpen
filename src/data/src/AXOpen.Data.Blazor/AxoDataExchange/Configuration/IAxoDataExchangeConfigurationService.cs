namespace AXOpen.Data
{
   
    public interface IAxoDataExchangeConfigurationService
    {
        void AddManagerConfiguration(string fullDataEntityNameWithSuffix, AxoDataExchangeConfiguration config);

        AxoDataExchangeConfiguration GetConfigution(IAxoDataExchange dataManager);

        AxoDataExchangeConfiguration GetConfigution(string fullDataEntityTypeName);

        AxoDataExchangeConfiguration GetConfigution(DataExchangeViewModel dataExchangeViewModel);
    }
}