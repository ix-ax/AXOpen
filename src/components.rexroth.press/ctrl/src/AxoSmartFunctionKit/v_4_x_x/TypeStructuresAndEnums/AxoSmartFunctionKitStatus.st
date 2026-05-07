NAMESPACE AXOpen.Components.Rexroth.Press.v_4_x_x
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKitStatus
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Response status#>"}
            ResponseStatus : AxoSmartFunctionKitResponse;
            {#ix-set:AttributeName = "<#Notification Id#>"}
            NotificationId  : UINT;
            {#ix-set:AttributeName = "<#Notification to display#>"}
            NotificationToDisplay  : eAxoSmartFunctionKitStatusInformation;
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