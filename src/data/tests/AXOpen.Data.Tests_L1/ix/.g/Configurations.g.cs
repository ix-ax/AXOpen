using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;

public partial class axopen_data_tests_l1TwinController : ITwinController
{
    public AXSharp.Connector.Connector Connector { get; }
    public Tests_L1.DataExchange.DataExchangeContext DataExchange { get; }
    public Tests_L1.FragmentData.FragmentDataContext Fragments { get; }
    public Tests_L1.Distributed.DistributedDataContext Distributed { get; }
    public Tests_L1.PersistentData.PersistentDataContext Persistent { get; }

    partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
    partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
    public axopen_data_tests_l1TwinController(AXSharp.Connector.ConnectorAdapter adapter, object[] parameters)
    {
        this.Connector = adapter.GetConnector(parameters);
        DataExchange = new Tests_L1.DataExchange.DataExchangeContext(this.Connector, "", "DataExchange");
        Fragments = new Tests_L1.FragmentData.FragmentDataContext(this.Connector, "", "Fragments");
        Distributed = new Tests_L1.Distributed.DistributedDataContext(this.Connector, "", "Distributed");
        Persistent = new Tests_L1.PersistentData.PersistentDataContext(this.Connector, "", "Persistent");
    }

    public axopen_data_tests_l1TwinController(AXSharp.Connector.ConnectorAdapter adapter)
    {
        this.Connector = adapter.GetConnector(adapter.Parameters);
        DataExchange = new Tests_L1.DataExchange.DataExchangeContext(this.Connector, "", "DataExchange");
        Fragments = new Tests_L1.FragmentData.FragmentDataContext(this.Connector, "", "Fragments");
        Distributed = new Tests_L1.Distributed.DistributedDataContext(this.Connector, "", "Distributed");
        Persistent = new Tests_L1.PersistentData.PersistentDataContext(this.Connector, "", "Persistent");
    }
}