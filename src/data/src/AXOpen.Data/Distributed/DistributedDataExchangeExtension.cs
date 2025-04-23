using AXOpen.Base.Data.Query;
using System.Collections.Concurrent;

namespace AXOpen.Data
{
    public static class DistributedDataExchangeExtension
    {
        public static List<string> GetEntityIds(this IEnumerable<IAxoDataExchange> exchanges, PredicateContainer predicates)
        {
            ConcurrentBag<List<string>> filteredIds = new();

            Parallel.ForEach(exchanges.Where(fragment =>
                predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
                {
                    var ids = fragment.GetEntityIds(predicates).ToList();
                    filteredIds.Add(ids);
                });

            List<string> commonEntities = filteredIds.Count > 1
               ? filteredIds.Skip(1)
                   .Aggregate(new HashSet<string>(filteredIds.First()), (common, next) =>
                   {
                       common.IntersectWith(next);
                       return common;
                   })
                   .ToList()
               : filteredIds.FirstOrDefault() ?? new List<string>();


            commonEntities = commonEntities.Distinct().ToList();

            return commonEntities;
        }
    }
}