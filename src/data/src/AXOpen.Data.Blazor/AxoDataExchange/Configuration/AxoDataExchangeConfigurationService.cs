namespace AXOpen.Data
{
    public class AxoDataExchangeConfigurationService : IAxoDataExchangeConfigurationService
    {
        protected Dictionary<string, AxoDataExchangeConfiguration> _Configurations = new();

        public Dictionary<string, AxoDataExchangeConfiguration> Configurations
        {
            get { return _Configurations; }
        }

        public AxoDataExchangeConfiguration GetConfigution(DataExchangeViewModel dataExchangeViewModel)
        {
            if (dataExchangeViewModel == null)
                return new AxoDataExchangeConfiguration();

            var exchange = (dataExchangeViewModel.Model) as IAxoDataExchange;
            return GetConfigution(exchange);
        }

        public AxoDataExchangeConfiguration GetConfigution(IAxoDataExchange exchange)
        {
            if (exchange == null)
                return new AxoDataExchangeConfiguration();

            // Retrieve the full name of the POCO type representing the data entity.
            return GetConfigution(exchange.GetPlainTypes().First().FullName);
        }

        public AxoDataExchangeConfiguration GetConfigution(string fullPlainDataTypeNameWithSuffix)
        {
            if (string.IsNullOrEmpty(fullPlainDataTypeNameWithSuffix))
                return null;

            if (Configurations.ContainsKey(fullPlainDataTypeNameWithSuffix))
            {
                return Configurations[fullPlainDataTypeNameWithSuffix];
            }
            else
            {
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
    }
}