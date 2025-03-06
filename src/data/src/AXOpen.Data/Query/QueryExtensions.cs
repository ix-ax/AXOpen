using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data.Query;

namespace AXOpen.Data.Query
{
    public static class QueryExtensions
    {
        public static PredicateContainer AddQuerySymbolToPredicates(this PredicateContainer pc, IEnumerable<PlainSymbolBuilder> plains, QuerySymbolConfiguration config)
        {
            if (plains == null || config == null)
            {
                return pc;
            }

            var targetPlains = plains.Where(p => p.RootTypeName == config.ParentTypeName);

            if (targetPlains != null && targetPlains.Count() > 0)
            {
                var targetPlain = targetPlains.First();

                var lambda = PredicateBuilder.BuildLambdaPredicate(targetPlain.RootType, config.Symbol, config.Operation, config.MinOrValue, config.Max);

                pc.AddPredicates(targetPlain.RootType, lambda);
            }

            return pc;
        }

        public static PredicateContainer AddSortSymbolToPredicates(this PredicateContainer pc, IEnumerable<PlainSymbolBuilder> plains, SortSymbolConfiguration config)
        {
            if (plains == null || config == null)
            {
                return pc;
            }

            var targetPlains = plains.Where(p => p.RootTypeName == config.ParentTypeName);

            if (targetPlains != null && targetPlains.Count() > 0)
            {
                var targetPlain = targetPlains.First();

                var sc = new SortSettings() { MemberName = config.Symbol, IsAscending = config.IsAscending };

                pc.AddSortMember(sc, targetPlain.RootType);
            }

            return pc;
        }
    }
}