NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_CS351_compact_ControlSignals
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Program number#>"}
            ProgramNo : BYTE;
            {#ix-set:AttributeName = "<#Enable#>"}
            Enable : BOOL;
            {#ix-set:AttributeName = "<#Reset fault#>"}
            ResetFault : BOOL;
            {#ix-set:AttributeName = "<#Start clockwise#>"}
            StartClockwise : BOOL;
            {#ix-set:AttributeName = "<#Start counter clockwise#>"}
            StartCounterClockwise : BOOL;
            {#ix-set:AttributeName = "<#Reset results#>"}
            ResetResults : BOOL;
            {#ix-set:AttributeName = "<#Nok acknowledge#>"}
            NokAck : BOOL;
            {#ix-set:AttributeName = "<#User In 1#>"}
            UsrIn1 : BOOL;
            {#ix-set:AttributeName = "<#User In 2#>"}
            UsrIn2 : BOOL;
            {#ix-set:AttributeName = "<#ErgoSpin LED Green#>"}
            ES_LED_Green : BOOL;
            {#ix-set:AttributeName = "<#ErgoSpin LED Yellow#>"}
            ES_LED_Yellow : BOOL;
            {#ix-set:AttributeName = "<#ErgoSpin LED Red#>"}
            ES_LED_Red : BOOL;
            {#ix-set:AttributeName = "<#Active enable#>"}
            ActiveEnable : BOOL;
            {#ix-set:AttributeName = "<#Counter clockwise lock#>"}
            CcwLock : BOOL;
            {#ix-set:AttributeName = "<#Clockwise lock#>"}
            CwLock : BOOL;
            {#ix-set:AttributeName = "<#Clockwise AND#>"}
            CwAnd : BOOL;
            {#ix-set:AttributeName = "<#Counter clockwise AND#>"}
            CcwAND : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE