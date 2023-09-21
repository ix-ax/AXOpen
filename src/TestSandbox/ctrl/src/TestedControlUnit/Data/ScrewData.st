NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;

TYPE ScrewData : STRUCT
            // {#ix-set:AttributeName = "Screw data"} 
        // {#ix-attr:[Container(Layout.Stack)]}
        // {#ix-attr:[Group(GroupLayout.GroupBox)]}
        Result : AXOpen.Inspectors.AxoDigitalInspector;
        Torque : AXOpen.Inspectors.AxoAnalogueInspector;
        Angle : AXOpen.Inspectors.AxoAnalogueInspector;
        XCoordination : AXOpen.Inspectors.AxoAnalogueInspector;
        YCoordination : AXOpen.Inspectors.AxoAnalogueInspector;
    END_STRUCT;
END_TYPE


END_NAMESPACE
