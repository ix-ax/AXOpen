namespace AXOpen.Data
{
    using System;

    public static class AxoDataExchangeConfigurationServiceExtension
    {
        public static AxoDataExchangeConfigurationService AddConfiguration<T>(
            this AxoDataExchangeConfigurationService exchangeConfig,
            string suffix,
            Action<AxoDataExchangeColumnConfigurator<T>> configAction)
        {

            var config = new AxoDataExchangeConfiguration();
            var columnConfigurator = new AxoDataExchangeColumnConfigurator<T>(config);
            configAction(columnConfigurator);
            exchangeConfig.AddManagerConfiguration($"{typeof(T).FullName}{suffix}", config);  // Add suffix here
            return exchangeConfig;
        }
    }
}
