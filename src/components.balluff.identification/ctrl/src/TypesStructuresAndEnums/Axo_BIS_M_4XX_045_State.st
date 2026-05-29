NAMESPACE AXOpen.Components.Balluff.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS Axo_BIS_M_4XX_045_State 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#BitHeader1 CodeTagPresent#>"}
            BitHeader1_CodeTagPresent : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 JobAccepted#>"}
            BitHeader1_JobAccepted : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 JobEnd#>"}
            BitHeader1_JobEnd : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 JobError#>"}
            BitHeader1_JobError : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 Reserve0#>"}
            BitHeader1_Reserve0 : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 ToggleBit#>"}
            BitHeader1_ToggleBit : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 HeadFailure#>"}
            BitHeader1_HeadFailure : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 Power#>"}
            BitHeader1_Power : BOOL;
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            // {#ix-set:AttributeName = "<#iErrorCode#>"}
            // iErrorCode : BYTE;
            // {#ix-set:AttributeName = "<#iHighByteVersion#>"}
            // iHighByteVersion : BYTE;
            // {#ix-set:AttributeName = "<#iLowByteVersion#>"}
            // iLowByteVersion : BYTE;
            
            // {#ix-set:AttributeName = "<#Data#>"}
            Data : ARRAY [0..7] OF BYTE;
        
        
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#BitHeader2 CodeTagPresent#>"}
            BitHeader2_CodeTagPresent : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 JobAccepted#>"}
            BitHeader2_JobAccepted : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 JobEnd#>"}
            BitHeader2_JobEnd : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 JobError#>"}
            BitHeader2_JobError : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 Reserve0#>"}
            BitHeader2_Reserve0 : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 ToggleBit#>"}
            BitHeader2_ToggleBit : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 HeadFailure#>"}
            BitHeader2_HeadFailure : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 Power#>"}
            BitHeader2_Power : BOOL;
        END_VAR
    END_CLASS
END_NAMESPACE
        