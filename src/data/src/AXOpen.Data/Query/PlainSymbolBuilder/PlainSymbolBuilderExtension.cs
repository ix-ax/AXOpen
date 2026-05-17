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

        public static string GetCommonPrefix(this IEnumerable<PlainSymbolBuilder> plains)
        {
            return GetCommonPrefix(plains.Select(p => p.RootTypeName));
        }

        public static string GetCommonPrefix(IEnumerable<string> names)
        {
            var list = names.Where(n => n != null).ToList();
            if (list.Count == 0)
                return "";

            var prefix = list[0];
            for (int i = 1; i < list.Count; i++)
            {
                var s = list[i];
                var len = Math.Min(prefix.Length, s.Length);
                int j = 0;
                while (j < len && prefix[j] == s[j])
                    j++;
                prefix = prefix[..j];
                if (prefix.Length == 0)
                    return "";
            }

            return prefix;
        }
    }
}
