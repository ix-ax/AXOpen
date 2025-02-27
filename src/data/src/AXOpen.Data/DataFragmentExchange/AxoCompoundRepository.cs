// inxton_axopen_data
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/inxton/axsharp/blob/dev/notices.md

using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace AXOpen.Data;

public class AxoCompoundRepository : IRepository
{
    public AxoCompoundRepository(IEnumerable<IAxoDataExchange> dataFragments)
    {
        DataFragments = dataFragments;
    }

    private IEnumerable<IAxoDataExchange> DataFragments { get; }

    public long Count { get; }

    public long LastFragmentQueryCount { protected set; get; }

    public void Create(string identifier, object data)
    {
        foreach (var dataFragment in DataFragments)
        {
            dataFragment.Repository.Create(identifier, data);
        }
    }

    public void Delete(string identifier)
    {
        foreach (var dataFragment in DataFragments)
        {
            dataFragment.Repository.Delete(identifier);
        }
    }

    public bool Exists(string identifier)
    {
        return DataFragments.First().Repository.FilteredCount(identifier) >= 1;
    }

    public long FilteredCount(string id, eSearchMode searchMode = eSearchMode.Exact)
    {
        return ((dynamic)DataFragments.First().Repository).FilteredCount(id, searchMode);
    }

    public dynamic Read(string identifier)
    {
        foreach (var dataFragment in DataFragments)
        {
            //dataFragment.RefUIData.PlainToShadow(dataFragment.Repository.Read(identifier));
        }

        return null;
    }

    public void Update(string identifier, object data)
    {
        foreach (var dataFragment in DataFragments)
        {
            //dataFragment.Repository.Update(identifier, dataFragment.Data.ShadowToPlain<>());
        }
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip, eSearchMode searchMode, string sortExpresion, bool sortAscending)
    {
        return ((dynamic)DataFragments.First().Repository).GetRecords(identifier, limit, skip, searchMode, sortExpresion, sortAscending);
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(IEnumerable<string> identifiers)
    {
             return ((dynamic)DataFragments.First().Repository).GetRecords(identifiers);
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
    {       
        return ((dynamic)DataFragments.First()).GetRecords(identifier);
    }

    public long FilteredCount(PredicateContainer predicates)
    {
        List<List<string>> fragmentEntities = new();

        if (predicates.PredicatesCount() == 0)
        {
            this.LastFragmentQueryCount = DataFragments.First().Repository.FilteredCount(predicates);
        }
        else
        {
            Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainObjectType().First())), fragment =>
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
        }

        return this.LastFragmentQueryCount;
    }
}