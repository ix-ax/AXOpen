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
    public class PlainFilterVariable
    {
        public PlainFilterVariable(string name, Type variableType, bool isPlainType, bool isNullableType)
        {
            this.Name = name;
            this.VariableType = variableType;
            this.IsPlainType = isPlainType;
            this.IsNullableType = isNullableType;
        }

        public string Name { get; set; }
        public bool IsPlainType { get; set; }
        public bool IsNullableType { get; set; }
        public Type VariableType { get; set; }

        public Type? UnderlyingType
        {
            get
            {
                if (IsNullableType)
                {
                    return Nullable.GetUnderlyingType(VariableType);
                }
                else
                {
                    return VariableType;
                }
            }
        }
    }
}