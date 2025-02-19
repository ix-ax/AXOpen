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
        public PlainFilterVariable(string name, Type variableType, bool isPlainType)
        {
            this.Name = name;
            this.VariableType = variableType;
            this.IsPlainType = isPlainType;
        }


        public string Name { get; set; }

        public bool IsPlainType { get; set; }

        public Type VariableType { get; set; }
    }
}