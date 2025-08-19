NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IV3_DeviceResultBits_1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Overall judgment OK#>"}
            OverallJudgmentOK : BOOL;                                                           // IB4.0
            {#ix-set:AttributeName = "<#Position correction#>"}
            PositionCorrection : BOOL;                                                          // IB4.1
            {#ix-set:AttributeName = "<#LOGIC1#>"}
            LOGIC1 : BOOL;                                                                      // IB4.2
            {#ix-set:AttributeName = "<#LOGIC2#>"}
            LOGIC2 : BOOL;                                                                      // IB4.3
            {#ix-set:AttributeName = "<#LOGIC3#>"}
            LOGIC3 : BOOL;                                                                      // IB4.4
            {#ix-set:AttributeName = "<#LOGIC4#>"}
            LOGIC4 : BOOL;                                                                      // IB4.5
            {#ix-set:AttributeName = "<#Overall judgment NG#>"}
            OverallJudgmentNG : BOOL;                                                           // IB4.6
                                                                                                // IB4.7
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool 1#>"}
            Tool_1 : BOOL;                                                                      // IB6.0
            {#ix-set:AttributeName = "<#Tool 2#>"}
            Tool_2 : BOOL;                                                                      // IB6.1
            {#ix-set:AttributeName = "<#Tool 3#>"}
            Tool_3 : BOOL;                                                                      // IB6.2
            {#ix-set:AttributeName = "<#Tool 4#>"}
            Tool_4 : BOOL;                                                                      // IB6.3
            {#ix-set:AttributeName = "<#Tool 5#>"}
            Tool_5 : BOOL;                                                                      // IB6.4
            {#ix-set:AttributeName = "<#Tool 6#>"}
            Tool_6 : BOOL;                                                                      // IB6.5
            {#ix-set:AttributeName = "<#Tool 7#>"}
            Tool_7 : BOOL;                                                                      // IB6.6
            {#ix-set:AttributeName = "<#Tool 8#>"}
            Tool_8 : BOOL;                                                                      // IB6.7
            {#ix-set:AttributeName = "<#Tool 9#>"}
            Tool_9 : BOOL;                                                                      // IB7.0
            {#ix-set:AttributeName = "<#Tool 10#>"}
            Tool_10 : BOOL;                                                                     // IB7.1
            {#ix-set:AttributeName = "<#Tool 11#>"}
            Tool_11 : BOOL;                                                                     // IB7.2
            {#ix-set:AttributeName = "<#Tool 12#>"}
            Tool_12 : BOOL;                                                                     // IB7.3
            {#ix-set:AttributeName = "<#Tool 13#>"}
            Tool_13 : BOOL;                                                                     // IB7.4
            {#ix-set:AttributeName = "<#Tool 14#>"}
            Tool_14 : BOOL;                                                                     // IB7.5
            {#ix-set:AttributeName = "<#Tool 15#>"}
            Tool_15 : BOOL;                                                                     // IB7.6
            {#ix-set:AttributeName = "<#Tool 16#>"}
            Tool_16 : BOOL;                                                                     // IB7.7
        END_VAR 
    END_CLASS    
END_NAMESPACE