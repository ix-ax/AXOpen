NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IV3_In
        VAR PUBLIC 
            // {#ix-set:AttributeName = "<#Status#>"}
            // {#ix-attr:[ReadOnly()]}
            // Status           :   Axo_IV3_Status;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Command status bits#>"}
            {#ix-attr:[ReadOnly()]}
            CommandStatusBits           :   Axo_IV3_CommandStatusBits;                              // IB0-IB3

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Device result bits 1#>"}
            {#ix-attr:[ReadOnly()]}
            DeviceResultBits_1          :   Axo_IV3_DeviceResultBits_1;                             // IB4-IB7

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Device status words#>"}
            {#ix-attr:[ReadOnly()]}
            DeviceStatusWords           :   Axo_IV3_DeviceStatusWords;                              // IB8-IB23

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Device statistics#>"}
            {#ix-attr:[ReadOnly()]}
            DeviceStatistics            :   Axo_IV3_DeviceStatistics;                               // IB24-IB51

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Position adjust result#>"}
            {#ix-attr:[ReadOnly()]}
            PositionAdjustResult        :   Axo_IV3_PositionAdjustResult;                           // IB52-IB71

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 1#>"}
            ToolResult_1 : Axo_IV3_ToolResult;                                                      // IB72-IB91
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 2#>"}
            ToolResult_2 : Axo_IV3_ToolResult;                                                      // IB92-IB111
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 3#>"}
            ToolResult_3 : Axo_IV3_ToolResult;                                                      // IB112-IB131
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 4#>"}
            ToolResult_4 : Axo_IV3_ToolResult;                                                      // IB132-IB151
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 5#>"}
            ToolResult_5 : Axo_IV3_ToolResult;                                                      // IB152-IB171
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 6#>"}
            ToolResult_6 : Axo_IV3_ToolResult;                                                      // IB172-IB191
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 7#>"}
            ToolResult_7 : Axo_IV3_ToolResult;                                                      // IB192-IB211
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 8#>"}
            ToolResult_8 : Axo_IV3_ToolResult;                                                      // IB212-IB231
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 9#>"}
            ToolResult_9 : Axo_IV3_ToolResult;                                                      // IB232-IB251
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 10#>"}
            ToolResult_10 : Axo_IV3_ToolResult;                                                     // IB252-IB271
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 11#>"}
            ToolResult_11 : Axo_IV3_ToolResult;                                                     // IB272-IB291
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 12#>"}
            ToolResult_12 : Axo_IV3_ToolResult;                                                     // IB292-IB311
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 13#>"}
            ToolResult_13 : Axo_IV3_ToolResult;                                                     // IB312-IB331
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 14#>"}
            ToolResult_14 : Axo_IV3_ToolResult;                                                     // IB332-IB351
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 15#>"}
            ToolResult_15 : Axo_IV3_ToolResult;                                                     // IB352-IB371
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 16#>"}
            ToolResult_16 : Axo_IV3_ToolResult;                                                     // IB372-IB391
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 17#>"}
            ToolResult_17 : Axo_IV3_ToolResult;                                                     // IB392-IB411
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 18#>"}
            ToolResult_18 : Axo_IV3_ToolResult;                                                     // IB412-IB431
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 19#>"}
            ToolResult_19 : Axo_IV3_ToolResult;                                                     // IB432-IB451
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 20#>"}
            ToolResult_20 : Axo_IV3_ToolResult;                                                     // IB452-IB471
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 21#>"}
            ToolResult_21 : Axo_IV3_ToolResult;                                                     // IB472-IB491
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 22#>"}
            ToolResult_22 : Axo_IV3_ToolResult;                                                     // IB492-IB511
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 23#>"}
            ToolResult_23 : Axo_IV3_ToolResult;                                                     // IB512-IB531
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 24#>"}
            ToolResult_24 : Axo_IV3_ToolResult;                                                     // IB532-IB551
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 25#>"}
            ToolResult_25 : Axo_IV3_ToolResult;                                                     // IB552-IB571
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 26#>"}
            ToolResult_26 : Axo_IV3_ToolResult;                                                     // IB572-IB591
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 27#>"}
            ToolResult_27 : Axo_IV3_ToolResult;                                                     // IB592-IB611
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 28#>"}
            ToolResult_28 : Axo_IV3_ToolResult;                                                     // IB612-IB631
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 29#>"}
            ToolResult_29 : Axo_IV3_ToolResult;                                                     // IB632-IB651
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 30#>"}
            ToolResult_30 : Axo_IV3_ToolResult;                                                     // IB652-IB671
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 31#>"}
            ToolResult_31 : Axo_IV3_ToolResult;                                                     // IB672-IB691
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 32#>"}
            ToolResult_32 : Axo_IV3_ToolResult;                                                     // IB692-IB711
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 33#>"}
            ToolResult_33 : Axo_IV3_ToolResult;                                                     // IB712-IB731
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 34#>"}
            ToolResult_34 : Axo_IV3_ToolResult;                                                     // IB732-IB751
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 35#>"}
            ToolResult_35 : Axo_IV3_ToolResult;                                                     // IB752-IB771
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 36#>"}
            ToolResult_36 : Axo_IV3_ToolResult;                                                     // IB772-IB791
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 37#>"}
            ToolResult_37 : Axo_IV3_ToolResult;                                                     // IB792-IB811
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 38#>"}
            ToolResult_38 : Axo_IV3_ToolResult;                                                     // IB812-IB831
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 39#>"}
            ToolResult_39 : Axo_IV3_ToolResult;                                                     // IB832-IB851
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 40#>"}
            ToolResult_40 : Axo_IV3_ToolResult;                                                     // IB852-IB871
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 41#>"}
            ToolResult_41 : Axo_IV3_ToolResult;                                                     // IB872-IB891
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 42#>"}
            ToolResult_42 : Axo_IV3_ToolResult;                                                     // IB892-IB911
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 43#>"}
            ToolResult_43 : Axo_IV3_ToolResult;                                                     // IB912-IB931
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 44#>"}
            ToolResult_44 : Axo_IV3_ToolResult;                                                     // IB932-IB951
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 45#>"}
            ToolResult_45 : Axo_IV3_ToolResult;                                                     // IB952-IB971
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 46#>"}
            ToolResult_46 : Axo_IV3_ToolResult;                                                     // IB972-IB991
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 47#>"}
            ToolResult_47 : Axo_IV3_ToolResult;                                                     // IB992-IB1011
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 48#>"}
            ToolResult_48 : Axo_IV3_ToolResult;                                                     // IB1012-IB1031
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 49#>"}
            ToolResult_49 : Axo_IV3_ToolResult;                                                     // IB1032-IB1051
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 50#>"}
            ToolResult_50 : Axo_IV3_ToolResult;                                                     // IB1052-IB1071
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 51#>"}
            ToolResult_51 : Axo_IV3_ToolResult;                                                     // IB1072-IB1091
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 52#>"}
            ToolResult_52 : Axo_IV3_ToolResult;                                                     // IB1092-IB1111
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 53#>"}
            ToolResult_53 : Axo_IV3_ToolResult;                                                     // IB1112-IB1131
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 54#>"}
            ToolResult_54 : Axo_IV3_ToolResult;                                                     // IB1132-IB1151
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 55#>"}
            ToolResult_55 : Axo_IV3_ToolResult;                                                     // IB1152-IB1171
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 56#>"}
            ToolResult_56 : Axo_IV3_ToolResult;                                                     // IB1172-IB1191
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 57#>"}
            ToolResult_57 : Axo_IV3_ToolResult;                                                     // IB1192-IB1211
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 58#>"}
            ToolResult_58 : Axo_IV3_ToolResult;                                                     // IB1212-IB1231
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 59#>"}
            ToolResult_59 : Axo_IV3_ToolResult;                                                     // IB1232-IB1251
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 60#>"}
            ToolResult_60 : Axo_IV3_ToolResult;                                                     // IB1252-IB1271
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 61#>"}
            ToolResult_61 : Axo_IV3_ToolResult;                                                     // IB1272-IB1291
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 62#>"}
            ToolResult_62 : Axo_IV3_ToolResult;                                                     // IB1292-IB1311
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 63#>"}
            ToolResult_63 : Axo_IV3_ToolResult;                                                     // IB1312-IB1331
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool result 64#>"}
            ToolResult_64 : Axo_IV3_ToolResult;                                                     // IB1332-IB1351
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Device result bits 2#>"}
            {#ix-attr:[ReadOnly()]}
            DeviceResultBits_2          :   Axo_IV3_DeviceResultBits_2;                             // IB1352-IB1359

        END_VAR 
    END_CLASS    
END_NAMESPACE