USING AXOpen.Core;
USING AXOpen.Io;

{S7.extern=ReadWrite}
CLASS Component_4 EXTENDS AXOpen.Core.AxoObject
    // Preconditions: 32 input bytes/32 output bytes must be configured in the harwdware configuration.
    //      All hardware used "MUST" be reseted into the factory default state.
    // Covers Balluff IOLink IO boxes: BNI0099 and BNI00AY  
    // Tested with Siemens IOLink master 6ES7 137-6BD00-0BA0 Firmware version V2.2

    //<ComponentDeclaration>
    VAR PUBLIC   
        ExampleComponent : AXOpen.Io.AxoIOLinkET200SP_Balluff_IO;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
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
        ExampleComponent.Run(inParent   :=  THIS, 
                             hwID       :=  HwIdentifiers#et200sp_A30_CM_4xIO_Link_V2_2_32I_32O_HwID,       // Enter the hardware ID of your correctly wired IO-Link master module based on your error-free, already-compiled hardware configuration
                             Port_1     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099, // Enter the configuration of the correctly wired boxes connected to Port 1
                             Port_2     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#NONE,            // Enter the configuration of the correctly wired boxes connected to Port 2
                             Port_3     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#NONE,            // Enter the configuration of the correctly wired boxes connected to Port 3
                             Port_4     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY);// Enter the configuration of the correctly wired boxes connected to Port 4

        // A30.Inputs.C1.Box1.In[5]
        // ExampleComponent.Run(inParent   :=  THIS, 
        //                      hwID       :=  HwIdentifiers#et200sp_A30_CM_4xIO_Link_V2_2_32I_32O_HwID,       // Enter the hardware ID of your correctly wired IO-Link master module based on your error-free, already-compiled hardware configuration
        //                      Port_1     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099,         // Enter the configuration of the correctly wired boxes connected to Port 1
        //                      Port_2     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099, // Enter the configuration of the correctly wired boxes connected to Port 2
        //                      Port_3     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY,         // Enter the configuration of the correctly wired boxes connected to Port 3
        //                      Port_4     :=  AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY);// Enter the configuration of the correctly wired boxes connected to Port 4
        // Possible values for port configuration are:
        // AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#NONE              -   Port not used; nothing must be connected 
        // AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099           -   One BNI0099 box is connected to the port of the IOLink master
        // AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099   -   First BNI0099 box is connected directly to the port of the IOLink master, second BNI0099 box is connected to the last port of the previous box
        // AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY           -   One BNI00AY box is connected to the port of the IOLink master
        // AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY   -   First BNI00AY box is connected directly to the port of the IOLink master, second BNI00AY box is connected to the last port of the previous box

        //</Initialization>
    END_METHOD
END_CLASS
