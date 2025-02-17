using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data
{
    public class FilterVariable
    {
        public FilterVariable(string name, Type variableType)
        {
            this.Name = name;
            this.VariableType = variableType;
        }


        public string Name { get; set; }

        public Type VariableType { get; set; }
    }
}