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
    public class QuerySymbolConfiguration
    {
        public QuerySymbolConfiguration() // just for serialization
        {
        }

        public QuerySymbolConfiguration(string symbolPathWithParent, string symbolTypeName, string operation, object minOrValue, object max)
        {
            this.SymbolPathWithParent = symbolPathWithParent;
            this.SymbolTypeFullName = symbolTypeName;
            this.Operation = operation;
            this.MinOrValue = minOrValue;
            this.Max = max;
        }

        public string SymbolPathWithParent { get; set; }
        public string SymbolTypeFullName { get; set; }

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

        public Guid TrackSymbolId { get; set; } = Guid.NewGuid();

        private string _ParentTypeName = string.Empty;

        [System.Text.Json.Serialization.JsonIgnore]
        public string ParentTypeName
        {
            get
            {
                if (string.IsNullOrEmpty(_ParentTypeName))
                {
                    _ParentTypeName = GetParentTypeName(SymbolPathWithParent);
                }

                return _ParentTypeName;
            }
        }

        private Type _SymbolType;

        [System.Text.Json.Serialization.JsonIgnore]
        public Type SymbolType
        {
            get
            {
                if (_SymbolType == null)
                {
                    _SymbolType = Type.GetType(SymbolTypeFullName);
                }

                return _SymbolType;
            }
        }

        private string _Symbol = string.Empty;

        [System.Text.Json.Serialization.JsonIgnore]
        public string Symbol
        {
            get
            {
                if (string.IsNullOrEmpty(_Symbol))
                {
                    _Symbol = RemoveParentTypeName(SymbolPathWithParent);
                }
                return _Symbol;
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

        internal object CheckType(object inputValue)
        {
            if (inputValue != null)
            {
                if (inputValue.GetType() == SymbolType)
                {
                    return inputValue;
                }
                else
                {
                    try
                    {
                        return Convert.ChangeType(inputValue, SymbolType);
                    }
                    catch (Exception ex)
                    {
                        ;
                    }
                }
            }
            
            return OperationProvider.GetMinForType(SymbolType);
        }

        public static string GetParentTypeName(string symbolPathWithParent)
        {
            int index = symbolPathWithParent.IndexOf('.');
            return index != -1 ? symbolPathWithParent.Substring(0, index) : symbolPathWithParent;
        }

        public static string RemoveParentTypeName(string symbolPathWithParent)
        {
            int index = symbolPathWithParent.IndexOf('.');
            return index != -1 ? symbolPathWithParent.Substring(index + 1) : symbolPathWithParent;
        }
    }
}