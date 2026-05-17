using System.Text.Json.Serialization;

namespace AXOpen.Data.Query
{
    public class QuerySymbolConfiguration : SymbolConfiguration
    {
        [JsonConstructor]
        public QuerySymbolConfiguration(string rootTypeName, string symbolPath, string symbolTypeName, string operation, object minOrValue, object max)
            : base(rootTypeName, symbolPath, symbolTypeName)
        {
            this.Operation = operation;
            this.MinOrValue = minOrValue;
            this.Max = max;
        }

        private object _MinOrValue;

        [JsonConverter(typeof(QuerySymbolJsonValueConverter))]
        public object MinOrValue
        {
            get
            {
                return this.CheckType(_MinOrValue);
            }
            set
            {
                var newVal = this.CheckType(value);

                if (newVal != null)
                {
                    _MinOrValue = newVal;
                }
            }
        }

        private object _Max;

        [JsonConverter(typeof(QuerySymbolJsonValueConverter))]
        public object Max
        {
            get
            {
                return this.CheckType(_Max);
            }
            set
            {
                var newVal = this.CheckType(value);

                if (newVal != null)
                {
                    _Max = newVal;
                }
            }
        }

        private string _Operation;

        public string Operation
        {
            get { return _Operation; }
            set { _Operation = value; }
        }

        [System.Text.Json.Serialization.JsonIgnore]
        public bool IsRangeOperation { get => Operation.Contains("Range"); }
    }
}
