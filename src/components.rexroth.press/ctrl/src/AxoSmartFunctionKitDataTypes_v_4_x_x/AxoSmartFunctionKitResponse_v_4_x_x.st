NAMESPACE AXOpen.Components.Rexroth.Press
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKitResponse_v_4_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Axis in reference#>"}
            AxisInReference : BOOL;
            {#ix-set:AttributeName = "<#Program active#>"}
            ProgramActive : BOOL;
            {#ix-set:AttributeName = "<#Last pressing Ok#>"}
            LastPressingOk : BOOL;
            {#ix-set:AttributeName = "<#Last pressing Nok#>"}
            LastPressingNok : BOOL;
            {#ix-set:AttributeName = "<#Sensor tared#>"}
            SensorTared : BOOL;
            {#ix-set:AttributeName = "<#Press ready#>"}
            PressReady : BOOL;
            {#ix-set:AttributeName = "<#Error#>"}
            Error : BOOL;
            {#ix-set:AttributeName = "<#Warning#>"}
            Warning : BOOL;
            {#ix-set:AttributeName = "<#Request possible#>"}
            RequestPossible : BOOL;
            {#ix-set:AttributeName = "<#Respons avialable#>"}
            ResponsAvialable : BOOL;
            {#ix-set:AttributeName = "<#Notification available#>"}
            NotificationAvailable : BOOL;
            {#ix-set:AttributeName = "<#Emergency off active#>"}
            EmergencyOffActive : BOOL;
            {#ix-set:AttributeName = "<#Safe standstill active#>"}
            SafeStandstillActive : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE