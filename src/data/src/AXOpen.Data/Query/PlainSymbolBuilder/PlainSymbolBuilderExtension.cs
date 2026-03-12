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
        public static Symbol CreateNewSymbol(this PlainSymbolBuilder plainBuilder, string path)
        {
            return new Symbol(plainBuilder.RootTypeName, path);
        }

        public static QuerySymbolConfiguration CreateNewQuerySymbol(this PlainSymbolBuilder plainBuilder, string path)
        {
            var symbol = new Symbol(plainBuilder.RootTypeName, path);
            return plainBuilder.CreateNewQuerySymbol(symbol);
        }

        public static QuerySymbolConfiguration CreateNewQuerySymbol(this PlainSymbolBuilder plainBuilder, Symbol symbol)
        {
            var symbolType = plainBuilder.GetSymbolType(symbol.SymbolPath);

            var operation = OperationProvider.GetOperationsForType(symbolType).First();
            var min = OperationProvider.GetMinForType(symbolType);
            var max = OperationProvider.GetMaxForType(symbolType);

            return new QuerySymbolConfiguration(symbol.RootTypeName, symbol.SymbolPath, symbolType.FullName, operation, min, max);
        }

        public static SortSymbolConfiguration CreateNewSortSymbol(this PlainSymbolBuilder plainBuilder, string path)
        {
            var symbol = new Symbol(plainBuilder.RootTypeName, path);
            return plainBuilder.CreateNewSortSymbol(symbol);
        }

        public static SortSymbolConfiguration CreateNewSortSymbol(this PlainSymbolBuilder plainBuilder, Symbol symbol)
        {
            var symbolType = plainBuilder.GetSymbolType(symbol.SymbolPath);
            return new SortSymbolConfiguration(symbol.RootTypeName, symbol.SymbolPath, symbolType.FullName, false);
        }


        public static QuerySymbolConfiguration CreateNewQuerySymbol(this IEnumerable<PlainSymbolBuilder> plains, Symbol symbol)
        {
            var builder = plains.Where(p => p.RootTypeName == symbol.RootTypeName).First();
            return builder.CreateNewQuerySymbol(symbol);
        }


        public static SortSymbolConfiguration CreateNewSortSymbol(this IEnumerable<PlainSymbolBuilder> plains, Symbol symbol)
        {
            var plainBuilder = plains.Where(p => p.RootTypeName == symbol.RootTypeName).First();

            var t = plainBuilder.GetSymbolType(symbol.SymbolPath);

            return new SortSymbolConfiguration(symbol.RootTypeName, symbol.SymbolPath, t.FullName, false);
        }





    }
}
