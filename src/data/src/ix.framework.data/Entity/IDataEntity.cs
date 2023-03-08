using System.Collections.Generic;
using ix.framework.data;

namespace Pocos.ix.framework.data
{
    public partial interface IDataEntity
    {
        List<ValueChangeItem> Changes { get; set; }
    }
}
