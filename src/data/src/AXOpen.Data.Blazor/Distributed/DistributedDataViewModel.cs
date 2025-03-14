using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXOpen.Base.Dialogs;
using AXOpen.Data.Query;
using AXSharp.Connector;
using AXSharp.Presentation;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using System.Collections.ObjectModel;

namespace AXOpen.Data
{
    public partial class DistributedDataViewModel : IDataExchangeQueryViewModel
    {
        public DistributedDataViewModel(IEnumerable<IAxoDataExchange> dataFragments)
        {
            DataFragments = dataFragments;
        }

        #region IDataExchangeQueryViewModel

        private List<Type> _PlainerTypes;

        public IEnumerable<Type> GetPlainTypes()
        {
            if (_PlainerTypes == null)
            {
                _PlainerTypes = new List<Type>();
                foreach (var exchange in DataFragments)
                {
                    _PlainerTypes.Add(exchange.GetPlainTypes().First());
                }
            }
            return _PlainerTypes;
        }

        public Task FillObservableRecordsAsync(PredicateContainer? predicates = null)
        {
            throw new NotImplementedException();
        }

        public void InvokeStateHasChanged()
        {
            throw new NotImplementedException();
        }

        #endregion IDataExchangeQueryViewModel

        public int LastFragmentQueryCount { set; get; }

        protected IEnumerable<IAxoDataExchange> DataFragments { get; private set; }
        public PredicateContainer InjectedPredicateContainer { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public Dictionary<string, List<IBrowsableDataObject>> GetRecords(PredicateContainer predicates,
            int limit, int skip)
        {
            List<List<string>> fragmentEntities = new();

            Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
            {
                var ids = fragment.GetEntityIds(predicates).ToList();
                lock (fragmentEntities)
                {
                    fragmentEntities.Add(ids);
                }
            });

            List<string> commonEntities = fragmentEntities.Count > 1
                ? fragmentEntities.Skip(1)
                    .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                    {
                        common.IntersectWith(next);
                        return common;
                    })
                    .ToList()
                : fragmentEntities.FirstOrDefault() ?? new List<string>();

            this.LastFragmentQueryCount = commonEntities.Count;

            var toFind = commonEntities.Skip(skip).Take(limit).ToList();

            var records = GetRecords(toFind).ToList();

            var orderedRecords = records.OrderBy(record => toFind.IndexOf(record.DataEntityId))
                .ToList();

            return orderedRecords;
        }

        public Dictionary<string, List<IBrowsableDataObject>> GetRecords(IEnumerable<string> identifiers)
        {
            return new Dictionary<string, List<IBrowsableDataObject>>();
        }

        public IEnumerable<string> GetEntityIds(PredicateContainer predicates)
        {
            List<List<string>> fragmentEntities = new();

            Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
            {
                var ids = fragment.GetEntityIds(predicates).ToList();
                lock (fragmentEntities)
                {
                    fragmentEntities.Add(ids);
                }
            });

            List<string> commonEntities = fragmentEntities.Count > 1
                ? fragmentEntities.Skip(1)
                    .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                    {
                        common.IntersectWith(next);
                        return common;
                    })
                    .ToList()
                : fragmentEntities.FirstOrDefault() ?? new List<string>();

            this.LastFragmentQueryCount = commonEntities.Count;

            var toFind = commonEntities;

            this.LastFragmentQueryCount = commonEntities.Count();

            return commonEntities;
        }
    }
}