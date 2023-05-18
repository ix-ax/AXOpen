// ix_ax_axopen_data
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using AXOpen.Base.Data;

namespace AXOpen.Data;

public class AxoCompoundRepository : IRepository
{

    public AxoCompoundRepository(IEnumerable<IAxoDataExchange> dataFragments)
    {
        DataFragments = dataFragments;
    }

    private IEnumerable<IAxoDataExchange> DataFragments { get; }

    public long Count { get; }
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
            dataFragment.Data.PlainToShadow(dataFragment.Repository.Read(identifier));
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

    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip, eSearchMode searchMode)
    {
        return ((dynamic)DataFragments.First().Repository).GetRecords(identifier, limit, skip, searchMode);
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
    {
        return ((dynamic)DataFragments.First().Repository).GetRecords(identifier);
    }
}