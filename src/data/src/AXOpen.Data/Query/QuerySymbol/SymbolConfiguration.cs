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
    public class SymbolConfiguration : Symbol
    {
        [JsonConstructor]
        public SymbolConfiguration(string rootTypeName, string symbolPath, string symbolTypeName) : base(rootTypeName, symbolPath)
        {
            this.SymbolTypeName = symbolTypeName;
        }

        public string SymbolTypeName { get; set; }

        public Guid TrackSymbolId { get; set; } = Guid.NewGuid();


        private Type _SymbolType;

        [System.Text.Json.Serialization.JsonIgnore]
        public Type SymbolType
        {
            get
            {
                if (_SymbolType == null)
                {
                    _SymbolType = ResolveType(SymbolTypeName);
                }

                return _SymbolType;
            }
        }


        internal object CheckType(object inputValue)
        {
            if (inputValue != null)
            {
                var inputType = inputValue.GetType();
                var targetType = SymbolType;

                // 1) Easiest path: same type, no conversion required.
                if (inputType == targetType)
                {
                    return inputValue;
                }

                var targetUnderlyingType = Nullable.GetUnderlyingType(targetType);

                // 2) Nullable target: assign when input matches underlying type.
                if (targetUnderlyingType != null)
                {
                    if (inputType == targetUnderlyingType)
                    {
                        return inputValue;
                    }

                    try
                    {
                        return Convert.ChangeType(inputValue, targetUnderlyingType);
                    }
                    catch (Exception)
                    {
                        // swallow
                    }
                }
                else
                {
                    // 3) Non-nullable target with nullable input that has same underlying type.
                    var inputUnderlyingType = Nullable.GetUnderlyingType(inputType);
                    if (inputUnderlyingType == targetType)
                    {
                        return inputValue;
                    }

                    try
                    {
                        return Convert.ChangeType(inputValue, targetType);
                    }
                    catch (Exception)
                    {
                        // swallow
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
