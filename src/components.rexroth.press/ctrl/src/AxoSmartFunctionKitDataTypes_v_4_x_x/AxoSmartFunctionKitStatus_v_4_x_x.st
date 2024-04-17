NAMESPACE AXOpen.Components.Rexroth.Press
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKitStatus_v_4_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Response status#>"}
            ResponseStatus : AxoSmartFunctionKitResponse_v_4_x_x;
            {#ix-set:AttributeName = "<#Notification Id#>"}
            NotificationId  : UINT;
            {#ix-set:AttributeName = "<#Notification to display#>"}
            NotificationToDisplay  : eAxoSmartFunctionKitStatusInformation_v_4_x_x;
            {#ix-set:AttributeName = "<#Notification position#>"}
            NotificationPosition  : REAL;
            {#ix-set:AttributeName = "<#Notification velocity#>"}
            NotificationVelocity : REAL;
            {#ix-set:AttributeName = "<#Notification force#>"}
            NotificationForce : REAL;
            {#ix-set:AttributeName = "<#Digital Io mapping#>"}
            DigitalIoMapping : DWORD;
            {#ix-set:AttributeName = "<#Virtual Io#>"}
            VirtualIo  : DWORD;
        END_VAR 
    END_CLASS    
END_NAMESPACE