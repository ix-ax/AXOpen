﻿using System.Collections.Generic;
using ix.framework.data;
using Ix.Connector;

namespace Pocos.ix.framework.data
{
    public partial interface IDataEntity
    {
        public string DataEntityId { get; set; }
        List<ValueChangeItem> Changes { get; set; }
    }
}
