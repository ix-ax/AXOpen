USING AXOpen.Core;
USING AXOpen.Io;

{S7.extern=ReadWrite}
CLASS Component_4 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleComponent : AXOpen.Io.AxoIOLinkET200SP_Balluff_IO;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        {#ix-set:AttributeName = "<#Port 1#>"}
        Port_1      :   AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099;
        {#ix-set:AttributeName = "<#Port 2#>"}
        Port_2      :   AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#NONE;
        {#ix-set:AttributeName = "<#Port 3#>"}
        Port_3      :   AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#NONE;
        {#ix-set:AttributeName = "<#Port 4#>"}
        Port_4      :   AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY;
    END_VAR
    //</InitializationArgumentsDeclaration>    

    METHOD PUBLIC OVERRIDE Run
        VAR_INPUT
            inParent : IAxoObject;
        END_VAR     
    
        SUPER.Run(inParent);

        IF ActivateManualControl THEN
            ExampleComponent.ActivateManualControl();
        END_IF;
        
        //<Initialization>        
        ExampleComponent.Run(THIS, HwIdentifiers#et200sp_A30_CM_4xIO_Link_V2_2_32I_32O_HwID,Port_1,Port_2,Port_3,Port_4);        
        //</Initialization>

    END_METHOD
END_CLASS
