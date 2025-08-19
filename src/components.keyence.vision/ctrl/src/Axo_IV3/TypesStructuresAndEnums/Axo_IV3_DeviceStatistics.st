NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IV3_DeviceStatistics
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Processing time MAX#>"}
            ProcessingTimeMax : UINT;                                                           // IW24
            {#ix-set:AttributeName = "<#Processing time MIN#>"}
            ProcessingTimeMin : UINT;                                                           // IW26
            {#ix-set:AttributeName = "<#Processing time AVE#>"}
            ProcessingTimeAve : UINT;                                                           // IW28
                                                                                                // IW30
            {#ix-set:AttributeName = "<#Number of triggers#>"}
            NumberOfTriggers : UDINT;                                                           // ID32
            {#ix-set:AttributeName = "<#Number of OKs#>"}
            NumberOfOKs : UDINT;                                                                // ID36
            {#ix-set:AttributeName = "<#Number of NGs#>"}
            NumberOfNGs : UDINT;                                                                // ID40
            {#ix-set:AttributeName = "<#Number of trigger errors#>"}
            NumberOfTriggerErrors : UDINT;                                                      // ID44
                                                                                                // ID48
        END_VAR 
    END_CLASS    
END_NAMESPACE