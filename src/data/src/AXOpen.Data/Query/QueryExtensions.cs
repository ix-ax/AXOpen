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
    public static class QueryExtensions
    {
        public static PredicateContainer AddQuerySymbolToPredicates(this PredicateContainer pc, IEnumerable<PlainSymbolBuilder> plains, QuerySymbolConfiguration config)
        {
            var targetPlain = plains.Where(p => p.RootTypeName == config.ParentTypeName).First();

            var lambda = PredicateBuilder.BuildLambdaPredicate(targetPlain.RootType, config.Symbol, config.Operation, config.MinOrValue, config.Max);

            pc.AddPredicates(targetPlain.RootType, lambda);

            return pc;
        }
    }
}