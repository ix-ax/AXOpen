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
    public static class PlainSymbolBuilderExtension
    {
        public static QuerySymbolConfiguration CreateNewQuerySymbol(this IEnumerable<PlainSymbolBuilder> plains, string symbol)
        {
            var plainBuilder = plains.Where(p => p.RootTypeName == QuerySymbolConfiguration.GetParentTypeName(symbol)).First();

            var t = plainBuilder.GetSymbolType(symbol);

            var operation = OperationProvider.GetOperationsForType(t).First();
            var min = OperationProvider.GetMinForType(t);
            var max = OperationProvider.GetMaxForType(t);

            return new QuerySymbolConfiguration(symbol, t.FullName, operation, min, max);
        }

        public static SortSymbolConfiguration CreateNewSortSymbol(this IEnumerable<PlainSymbolBuilder> plains, string symbol)
        {
            var plainBuilder = plains.Where(p => p.RootTypeName == QuerySymbolConfiguration.GetParentTypeName(symbol)).First();

            var t = plainBuilder.GetSymbolType(symbol);

            return new SortSymbolConfiguration(symbol, t.FullName, false);
        }
    }
}