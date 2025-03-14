
namespace AXOpen.Data
{
    public class DataExchangeConfigurationProvider : IDataExchangeConfigurationProvider
    {
        protected Dictionary<string, DataExchangeViewConfiguration> _Configurations = new();

        public Dictionary<string, DataExchangeViewConfiguration> Configurations
        {
            get { return _Configurations; }
        }

        public DataExchangeViewConfiguration GetConfigution(DataExchangeViewModel dataExchangeViewModel)
        {
            if (dataExchangeViewModel == null)
                return new DataExchangeViewConfiguration();

            var dataManager = (dataExchangeViewModel.Model) as IAxoDataExchange;
            return GetConfigution(dataManager);
        }

        public DataExchangeViewConfiguration GetConfigution(IAxoDataExchange dataManager)
        {
            if (dataManager == null)
                return new DataExchangeViewConfiguration();

            // Retrieve the full name of the POCO type representing the data entity.
            return GetConfigution(dataManager.GetPlainTypes().FirstOrDefault().FullName);
        }

        public DataExchangeViewConfiguration GetConfigution(string fullDataEntityNameWithSuffix)
        {
            if (string.IsNullOrEmpty(fullDataEntityNameWithSuffix))
                return null;

            if (Configurations.ContainsKey(fullDataEntityNameWithSuffix))
            {
                return Configurations[fullDataEntityNameWithSuffix];
            }
            else
            {
                return null;
            }
        }

        public void AddManagerConfiguration(string fullDataEntityNameWithSuffix, DataExchangeViewConfiguration config, bool addDeafultCollumns = true)
        {
            if (string.IsNullOrEmpty(fullDataEntityNameWithSuffix) )
            {
                // Optionally, handle null values according to your application's requirements.
                return;
            }

            var typeName = fullDataEntityNameWithSuffix;

            if (Configurations.ContainsKey(typeName))
            {
                // Merge the provided configuration with the existing configuration.
                Configurations[typeName].Collumns.AddRange(config.Collumns);
                Configurations[typeName].SortingExpressions.AddRange(config.SortingExpressions);
                Configurations[typeName].EnableSorting = config.EnableSorting;
            }
            else
            {
                if (addDeafultCollumns)
                {
                    // Create a new list with default columns.
                    var newColumnList = new List<ColumnDataContent>
                    {
                        new ColumnDataContent
                        {
                            BindingValuePath = "_Created",
                            ColumnName = "Created",
                            ClickEnabled = true
                        },
                        new ColumnDataContent
                        {
                            BindingValuePath = "_Modified",
                            ColumnName = "Modified",
                            ClickEnabled = true
                        },
                        // Additional default columns can be added here.
                    };

                    newColumnList.AddRange(config.Collumns);

                    // Add the default columns to the provided configuration.
                    config.Collumns.Clear();
                    config.Collumns.AddRange(newColumnList);
                }
                // Store the new configuration.
                Configurations.Add(typeName, config);
            }
        }
    }
}