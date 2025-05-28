using Microsoft.AspNetCore.Cors;

namespace AXOpen.Data
{
    public class AxoDataExchangeConfigurationService : IAxoDataExchangeConfigurationService
    {
        protected Dictionary<string, AxoDataExchangeConfiguration> _Configurations = new();

        protected AxoDataExchangeConfiguration _DefaultConfiguration = new();

        public Dictionary<string, AxoDataExchangeConfiguration> Configurations
        {
            get { return _Configurations; }
        }
        
        public AxoDataExchangeConfiguration DefaultConfiguration
        {
            get { return _DefaultConfiguration; }
        }

        public AxoDataExchangeConfiguration GetConfigution(DataExchangeViewModel dataExchangeViewModel, bool defautIfNotExist = true)
        {
            if (dataExchangeViewModel == null)
                return new AxoDataExchangeConfiguration();

            var exchange = (dataExchangeViewModel.Model) as IAxoDataExchange;
            return GetConfigution(exchange, defautIfNotExist);
        }

        public AxoDataExchangeConfiguration GetConfigution(IAxoDataExchange exchange, bool defautIfNotExist = true)
        {
            if (exchange == null)
                return new AxoDataExchangeConfiguration();

            // Retrieve the full name of the POCO type representing the data entity.
            return GetConfigution(exchange.GetPlainTypes().First().FullName, defautIfNotExist);
        }

        public AxoDataExchangeConfiguration GetConfigution(IAxoDataExchange exchange, string configSuffix ,  bool defautIfNotExist = true)
        {
            if (exchange == null || string.IsNullOrEmpty(configSuffix))
                return new AxoDataExchangeConfiguration();

            // Retrieve the full name of the POCO type representing the data entity.
            return GetConfigution(exchange.GetPlainTypes().First().FullName + configSuffix, defautIfNotExist);
        }

        public AxoDataExchangeConfiguration GetConfigution(string fullPlainDataTypeNameWithSuffix, bool defautIfNotExist = true)
        {
            if (string.IsNullOrEmpty(fullPlainDataTypeNameWithSuffix))
                return null;

            if (Configurations.ContainsKey(fullPlainDataTypeNameWithSuffix))
            {
                return Configurations[fullPlainDataTypeNameWithSuffix];
            }
            else
            {
                if (defautIfNotExist)
                {
                    return _DefaultConfiguration;
                }
                return null;
            }
        }

        public void AddManagerConfiguration(string fullPlainDataTypeNameWithSuffix, AxoDataExchangeConfiguration config)
        {
            if (string.IsNullOrEmpty(fullPlainDataTypeNameWithSuffix) )
            {
                // Optionally, handle null values according to your application's requirements.
                return;
            }

            var typeName = fullPlainDataTypeNameWithSuffix;

            if (Configurations.ContainsKey(typeName))
            {
                // Merge the provided configuration with the existing configuration.
                Configurations[typeName].Collumns.AddRange(config.Collumns);
                Configurations[typeName].SortingExpressions.AddRange(config.SortingExpressions);
                Configurations[typeName].EnableSorting = config.EnableSorting;
            }
            else
            {
                // Store the new configuration.
                Configurations.Add(typeName, config);
            }
        }

        public void SetDefaultConfiguration(AxoDataExchangeConfiguration config)
        {
           this._DefaultConfiguration = config;
        }
    }
}