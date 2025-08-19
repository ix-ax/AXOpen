NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IV3_CommandStatusBits
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Trigger response#>"}                    
            TriggerResponse : BOOL;                                                             // IB0.0
            {#ix-set:AttributeName = "<#Master registration response#>"}
            MasterRegistrationResponse : BOOL;                                                  // IB0.1
            {#ix-set:AttributeName = "<#Program switching response#>"}
            ProgramSwitchingResponse : BOOL;                                                    // IB0.2
            {#ix-set:AttributeName = "<#Warning clear response#>"}
            WarningClearResponse : BOOL;                                                        // IB0.3
            {#ix-set:AttributeName = "<#Statistics reset response#>"}
            StatisticsResetResponse : BOOL;                                                     // IB0.4
            {#ix-set:AttributeName = "<#Buffer clear response#>"}
            BufferClearResponse : BOOL;                                                         // IB0.5
            {#ix-set:AttributeName = "<#SD card saving stop response#>"}
            SdCardSavingStopResponse : BOOL;                                                    // IB0.6
            {#ix-set:AttributeName = "<#Setting value change response#>"}
            SettingValueChangeResponse : BOOL;                                                  // IB0.7

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Trigger failed#>"}
            TriggerFailed : BOOL;                                                               // IB1.0
            {#ix-set:AttributeName = "<#Master registration failed#>"}
            MasterRegistrationFailed : BOOL;                                                    // IB1.1
            {#ix-set:AttributeName = "<#Program switching failed#>"}
            ProgramSwitchingFailed : BOOL;                                                      // IB1.2
                                                                                                // IB1.3
                                                                                                // IB1.4
                                                                                                // IB1.5
            {#ix-set:AttributeName = "<#SD card saving stop failed#>"}
            SdCardSavingStopFailed : BOOL;                                                      // IB1.6
            {#ix-set:AttributeName = "<#Setting value change failed#>"}
            SettingValueChangeFailed : BOOL;                                                    // IB1.7

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Result available#>"}
            ResultAvailable : BOOL;                                                             // IB2.0
            {#ix-set:AttributeName = "<#Result update complete#>"}
            ResultUpdateComplete : BOOL;                                                        // IB2.1
            {#ix-set:AttributeName = "<#BUSY#>"}
            BUSY : BOOL;                                                                        // IB2.2
            {#ix-set:AttributeName = "<#Imaging status#>"}
            ImagingStatus : BOOL;                                                               // IB2.3
            {#ix-set:AttributeName = "<#RUN#>"}
            RUN : BOOL;                                                                         // IB2.4
            {#ix-set:AttributeName = "<#Ready#>"}
            Ready : BOOL;                                                                       // IB2.5
            {#ix-set:AttributeName = "<#Trigger ready#>"}
            TriggerReady : BOOL;                                                                // IB2.6
            {#ix-set:AttributeName = "<#SD card identification status#>"}
            SdCardIdentificationStatus : BOOL;                                                  // IB2.7 

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Sorting mode information#>"}
            SortingModeInformation : BOOL;                                                      // IB3.0
                                                                                                // IB3.1
                                                                                                // IB3.2
                                                                                                // IB3.3
            {#ix-set:AttributeName = "<#Insufficient free space on SD card#>"}
            InsufficientFreeSpaceOnSdCard : BOOL;                                               // IB3.4
            {#ix-set:AttributeName = "<#Buffer overrun#>"}
            BufferOverrun : BOOL;                                                               // IB3.5
            {#ix-set:AttributeName = "<#Warning#>"}
            Warning : BOOL;                                                                     // IB3.6
            {#ix-set:AttributeName = "<#Error#>"}
            Error : BOOL;                                                                       // IB3.7

        END_VAR 
    END_CLASS    
END_NAMESPACE