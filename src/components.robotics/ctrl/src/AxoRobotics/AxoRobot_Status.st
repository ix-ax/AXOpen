USING AXOpen.Core;
NAMESPACE AXOpen.Components.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS AxoRobot_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            Current    :   AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
        END_VAR
    END_CLASS
END_NAMESPACE
