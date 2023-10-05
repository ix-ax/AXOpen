USING AXOpen.Core;
NAMESPACE AXOpen.Components.Drives
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS AxoDrive_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            CurrentMotionTaskId    :   INT;
        END_VAR
    END_CLASS
END_NAMESPACE