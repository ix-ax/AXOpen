USING AXOpen.Core;
NAMESPACE AXOpen.Components.Drives
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS AxoDrive_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            CurrentMotionTaskId    :   eAxoMotionTaskId := eAxoMotionTaskId#Axo_None;
        END_VAR
    END_CLASS
END_NAMESPACE
