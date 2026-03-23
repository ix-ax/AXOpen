using AXOpen.Base.Data.Query;

namespace AXOpen.Data.Query
{
    public static class QueryExtensions
    {
        public static PredicateContainer AddQuerySymbolToPredicates(this PredicateContainer pc, PlainSymbolBuilder builder, QuerySymbolConfiguration config)
        {
            if (builder == null || config == null) return pc;

            var lambda = PredicateBuilder.BuildLambdaPredicate(builder.RootType, config.SymbolPath, config.Operation, config.MinOrValue, config.Max);
            pc.AddPredicates(builder.RootType, lambda);

            return pc;
        }

        public static PredicateContainer AddSortSymbolToPredicates(this PredicateContainer pc, PlainSymbolBuilder builder, SortSymbolConfiguration config)
        {
            if (builder == null || config == null) return pc;

            var sc = new SortSettings() { MemberName = config.SymbolPath, IsAscending = config.IsAscending };
            pc.AddSortMember(sc, builder.RootType);

            return pc;
        }

        public static PredicateContainer AddQuerySymbolToPredicates(this PredicateContainer pc, IEnumerable<PlainSymbolBuilder> builders, QuerySymbolConfiguration config)
        {
            if (builders == null || config == null) return pc;

            var targetBuilders = builders.Where(p => p.RootType == config.RootType);

            if (targetBuilders != null && targetBuilders.Count() > 0)
            {
                var builder = targetBuilders.First();

                pc.AddQuerySymbolToPredicates(builder, config);
            }

            return pc;
        }

        public static PredicateContainer AddSortSymbolToPredicates(this PredicateContainer pc, IEnumerable<PlainSymbolBuilder> builders, SortSymbolConfiguration config)
        {
            if (builders == null || config == null) return pc;

            var targetBuilders = builders.Where(p => p.RootType == config.RootType);

            if (targetBuilders != null && targetBuilders.Count() > 0)
            {
                var builder = targetBuilders.First();

                var sc = new SortSettings() { MemberName = config.SymbolPath, IsAscending = config.IsAscending };

                pc.AddSortMember(sc, builder.RootType);
            }
            return pc;
        }
    }
}
