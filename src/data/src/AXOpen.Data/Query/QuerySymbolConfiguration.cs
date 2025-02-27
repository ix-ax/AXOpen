using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.Json.Serialization;
using Newtonsoft.Json.Linq;

namespace AXOpen.Data.Query
{
    public class QuerySymbolConfiguration : SymbolConfiguration
    {
        [JsonConstructor]
        public QuerySymbolConfiguration(string symbolPathWithParent, string symbolTypeFullName, string operation, object minOrValue, object max)
            : base(symbolPathWithParent, symbolTypeFullName)
        {
            this.Operation = operation;
            this.MinOrValue = minOrValue;
            this.Max = max;
        }

        private object _MinOrValue;
        private object _Max;

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