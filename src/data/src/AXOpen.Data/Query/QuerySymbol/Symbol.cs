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
    public class Symbol
    {
        public Symbol(string rootTypeName, string symbolPath)
        {
            this.RootTypeName   = rootTypeName;
            this.SymbolPath     = symbolPath;
        }

        public string RootTypeName { get; set; }
        public string SymbolPath { get; set; }

        
        private Type _RootType;

        internal static Type? ResolveType(string? typeName)
        {
            if (string.IsNullOrWhiteSpace(typeName))
                return null;

            var type = Type.GetType(typeName, throwOnError: false, ignoreCase: false);
            if (type != null)
                return type;

            foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                type = assembly.GetType(typeName, throwOnError: false, ignoreCase: false);
                if (type != null)
                    return type;
            }

            return null;
        }

        [System.Text.Json.Serialization.JsonIgnore]
        public Type RootType
        {
            get
            {
                if (_RootType == null)
                {
                    _RootType = ResolveType(RootTypeName);
                }

                return _RootType;
            }
        }

        private string _PresentablePath;
        [System.Text.Json.Serialization.JsonIgnore]
        // used for presntable reason, if not set, will default to {RootTypeName}.{SymbolPath}.
        // for better readability can by set from outside, for example, to hide some common prefix in the symbol path.
        public string PresentablePath
        {
            set
            {
                _PresentablePath = value;
            }
            get
            {
                if (string.IsNullOrEmpty(_PresentablePath))
                {
                    _PresentablePath = $"{RootTypeName}.{SymbolPath}";
                }
                return _PresentablePath;
            }
        }

    }
}
