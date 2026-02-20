
using System.Reflection;
using AXSharp.Connector.Localizations;

namespace axopen_data_tests_l1
{
    public sealed class PlcTranslator : Translator
    {
        private static readonly PlcTranslator instance = new PlcTranslator();

        public static PlcTranslator Instance
        {
            get
            {
                return instance;
            }
        }

        private PlcTranslator() 
        {
            var assembly = Assembly.GetAssembly(typeof(axopen_data_tests_l1.PlcTranslator));
            var resource = assembly.GetType("axopen_data_tests_l1.Resources.PlcStringResources");
            this.SetLocalizationResource(resource, assembly);
        }
    }
}