NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;

    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS FragmentProcessData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            CounterDelay : ULINT;
            // Screw_0 : sandboxtest.StandardControlUnit.ScrewData;
            // Screw_1 : sandboxtest.StandardControlUnit.ScrewData;
            // Screw_2 : sandboxtest.StandardControlUnit.ScrewData;
            // Screw_3 : sandboxtest.StandardControlUnit.ScrewData;
            // Screw_4 : sandboxtest.StandardControlUnit.ScrewData;

            Res_Screw_0 : AXOpen.Inspectors.AxoDigitalInspector;
            Tor_Screw_0 : AXOpen.Inspectors.AxoAnalogueInspector;
            Ang_Screw_0 : AXOpen.Inspectors.AxoAnalogueInspector;
            XCo_Screw_0 : AXOpen.Inspectors.AxoAnalogueInspector;
            YCo_Screw_0 : AXOpen.Inspectors.AxoAnalogueInspector;

            Res_Screw_1 : AXOpen.Inspectors.AxoDigitalInspector;
            Tor_Screw_1 : AXOpen.Inspectors.AxoAnalogueInspector;
            Ang_Screw_1 : AXOpen.Inspectors.AxoAnalogueInspector;
            XCo_Screw_1 : AXOpen.Inspectors.AxoAnalogueInspector;
            YCo_Screw_1 : AXOpen.Inspectors.AxoAnalogueInspector;

            Res_Screw_2 : AXOpen.Inspectors.AxoDigitalInspector;
            Tor_Screw_2 : AXOpen.Inspectors.AxoAnalogueInspector;
            Ang_Screw_2 : AXOpen.Inspectors.AxoAnalogueInspector;
            XCo_Screw_2 : AXOpen.Inspectors.AxoAnalogueInspector;
            YCo_Screw_2 : AXOpen.Inspectors.AxoAnalogueInspector;

            Res_Screw_3 : AXOpen.Inspectors.AxoDigitalInspector;
            Tor_Screw_3 : AXOpen.Inspectors.AxoAnalogueInspector;
            Ang_Screw_3 : AXOpen.Inspectors.AxoAnalogueInspector;
            XCo_Screw_3 : AXOpen.Inspectors.AxoAnalogueInspector;
            YCo_Screw_3 : AXOpen.Inspectors.AxoAnalogueInspector;

            Res_Screw_4 : AXOpen.Inspectors.AxoDigitalInspector;
            Tor_Screw_4 : AXOpen.Inspectors.AxoAnalogueInspector;
            Ang_Screw_4 : AXOpen.Inspectors.AxoAnalogueInspector;
            XCo_Screw_4 : AXOpen.Inspectors.AxoAnalogueInspector;
            YCo_Screw_4 : AXOpen.Inspectors.AxoAnalogueInspector;


            Traca__0 : AXOpen.Inspectors.AxoDataInspector;
            Traca__1 : AXOpen.Inspectors.AxoDataInspector;
            Reader_0 : AXOpen.Inspectors.AxoDataInspector;
            Reader_1 : AXOpen.Inspectors.AxoDataInspector;
            Camera_0 : AXOpen.Inspectors.AxoDataInspector;
            Camera_1 : AXOpen.Inspectors.AxoDataInspector;
        END_VAR
    END_CLASS

END_NAMESPACE
