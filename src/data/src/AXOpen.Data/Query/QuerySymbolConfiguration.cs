using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data.Query
{
    public class QuerySymbolConfiguration
    {
        //public QuerySymbolConfiguration() // just for serialization
        //{
        //}

        public QuerySymbolConfiguration(string symbolPathWithParent, string symbolTypeName, string operation, object minOrValue, object max)
        {
            this.SymbolPathWithParent = symbolPathWithParent;
            this.SymbolTypeFullName = symbolTypeName;
            this.Operation = operation;
            this.MinOrValue = minOrValue;
            this.Max = max;
        }

        public Guid TrackSymbolId { get; set; } = Guid.NewGuid();

        private string _ParentTypeName = string.Empty;

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

        public string SymbolPathWithParent { get; set; }
        public string SymbolTypeFullName { get; set; }

        private Type _SymbolType;

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

        public bool IsRangeOperation { get => Operation.Contains("Range"); }


        public object MinOrValue { set; get; }
        public object Max { set; get; }

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