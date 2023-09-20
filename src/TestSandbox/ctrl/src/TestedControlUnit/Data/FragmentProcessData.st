NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;

    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS FragmentProcessData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            CounterDelay : ULINT;
            Screw_0 : ScrewData;
            Screw_1 : ScrewData;
            Screw_2 : ScrewData;
            Screw_3 : ScrewData;
            Screw_4 : ScrewData;
            Traca_0 : AXOpen.Inspectors.AxoDataInspector;
            Traca_1 : AXOpen.Inspectors.AxoDataInspector;
            Reader_0 : AXOpen.Inspectors.AxoDataInspector;
            Reader_1 : AXOpen.Inspectors.AxoDataInspector;
            Camera_0 : AXOpen.Inspectors.AxoDataInspector;
            Camera_1 : AXOpen.Inspectors.AxoDataInspector;
        END_VAR
    END_CLASS

END_NAMESPACE
