namespace AXOpen.Data
{
   
    public interface IAxoDataExchangeConfigurationService
    {
        void AddManagerConfiguration(string fullDataEntityNameWithSuffix, AxoDataExchangeConfiguration config);
        void SetDefaultConfiguration( AxoDataExchangeConfiguration config);

        AxoDataExchangeConfiguration GetConfigution(IAxoDataExchange dataManager, bool defautIfNotExist = true);
        AxoDataExchangeConfiguration GetConfigution(IAxoDataExchange exchange, string configSuffix, bool defautIfNotExist = true);

        AxoDataExchangeConfiguration GetConfigution(string fullDataEntityTypeName, bool defautIfNotExist = true);

        AxoDataExchangeConfiguration GetConfigution(DataExchangeViewModel dataExchangeViewModel, bool defautIfNotExist = true);
    }
}