NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IV3_DeviceStatusWords
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Error No.#>"}
            ErrorNo : UINT;                                                                     // IW8
            {#ix-set:AttributeName = "<#Warning No.#>"}
            WarningNo : UINT;                                                                   // IW10
            {#ix-set:AttributeName = "<#Number of remaining buffers#>"}
            NumberOfRemainingBuffers : UINT;                                                    // IW12
            {#ix-set:AttributeName = "<#Checksum#>"}
            Checksum : UINT;                                                                    // IW14
            {#ix-set:AttributeName = "<#Current program No.#>"}
            CurrentProgramNo : UINT;                                                            // IW16
            {#ix-set:AttributeName = "<#Program No. during judgment#>"}
            ProgramNoDuringJudgment : UINT;                                                     // IW18
            {#ix-set:AttributeName = "<#Result No.#>"}
            ResultNo : UINT;                                                                    // IW20
            {#ix-set:AttributeName = "<#Processing time#>"}
            ProcessingTime : UINT;                                                              // IW22
        END_VAR 
    END_CLASS    
END_NAMESPACE