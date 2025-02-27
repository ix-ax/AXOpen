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
using AXOpen.Base.Data.Query;

namespace AXOpen.Data.Query
{

    // class that will handle sort configuration, it will be transromt to SortSettings
    public class SortSymbolConfiguration : SymbolConfiguration
    {
        [JsonConstructor]
        public SortSymbolConfiguration(string symbolPathWithParent, string symbolTypeFullName, bool isAscending) : base(symbolPathWithParent, symbolTypeFullName)
        {
            this.IsAscending = isAscending;
        }

        public bool IsAscending { get; set; }
    }
}