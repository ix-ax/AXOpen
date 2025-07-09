NAMESPACE AXOpen.Components.Festo.Drives
   
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_STW1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#jog1#>"}
            jog1    :  BOOL;
            {#ix-set:AttributeName = "<#jog2#>"}
            jog2    :  BOOL;
            {#ix-set:AttributeName = "<#controlByPlc#>"}
            controlByPlc    :  BOOL;
            {#ix-set:AttributeName = "<#StartHoming#>"}
            StartHoming :  BOOL;
            {#ix-set:AttributeName = "<#ReleaseBrake#>"}
            ReleaseBrake    :  BOOL;
            {#ix-set:AttributeName = "<#ExternalBlockChange#>"}
            ExternalBlockChange :  BOOL;
            {#ix-set:AttributeName = "<#reserved14#>"}
            reserved14  :  BOOL;
            {#ix-set:AttributeName = "<#reserved15#>"}
            reserved15  :  BOOL;
            {#ix-set:AttributeName = "<#on#>"}
            on_  :  BOOL;
            {#ix-set:AttributeName = "<#noCoastStop#>"}
            noCoastStop :  BOOL;
            {#ix-set:AttributeName = "<#noQuickStop#>"}
            noQuickStop :  BOOL;
            {#ix-set:AttributeName = "<#enableOperation#>"}
            enableOperation :  BOOL;
            {#ix-set:AttributeName = "<#cancelTraversing#>"}
            cancelTraversing    :  BOOL;
            {#ix-set:AttributeName = "<#intermediateStop#>"}
            intermediateStop    :  BOOL;
            {#ix-set:AttributeName = "<#activateTraversing#>"}
            activateTraversing  :  BOOL;
            {#ix-set:AttributeName = "<#acknowledgeFault#>"}
            acknowledgeFault    :  BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_POS_STW1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#MDI_MOD#>"}
            MDI_MOD    :  BOOL;
            {#ix-set:AttributeName = "<#PosModulo#>"}
            PosModulo    :  BOOL;
            {#ix-set:AttributeName = "<#NegModulo#>"}
            NegModulo    :  BOOL;
            {#ix-set:AttributeName = "<#reserved11#>"}
            reserved11 :  BOOL;
            {#ix-set:AttributeName = "<#reserved12#>"}
            reserved12    :  BOOL;
            {#ix-set:AttributeName = "<#reserved13#>"}
            reserved13 :  BOOL;
            {#ix-set:AttributeName = "<#SetupMode#>"}
            SetupMode  :  BOOL;
            {#ix-set:AttributeName = "<#MDI_Activate#>"}
            MDI_Activate  :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit0#>"}
            travBlockBit0  :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit1#>"}
            travBlockBit1 :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit2#>"}
            travBlockBit2 :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit3#>"}
            travBlockBit3 :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit4#>"}
            travBlockBit4    :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit5#>"}
            travBlockBit5  :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit6#>"}
            travBlockBit6    :  BOOL;
            {#ix-set:AttributeName = "<#reserved7#>"}
            reserved7    :  BOOL;
        END_VAR
    END_CLASS   
    
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_POS_STW2
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#FlyingRef#>"}
            FlyingRef    :  BOOL;
            {#ix-set:AttributeName = "<#reserved9#>"}
            reserved9    :  BOOL;
            {#ix-set:AttributeName = "<#SelectProbe#>"}
            SelectProbe    :  BOOL;
            {#ix-set:AttributeName = "<#ProbeEdgeEval#>"}
            ProbeEdgeEval :  BOOL;
            {#ix-set:AttributeName = "<#reserved12#>"}
            reserved12    :  BOOL;
            {#ix-set:AttributeName = "<#reserved13#>"}
            reserved13 :  BOOL;
            {#ix-set:AttributeName = "<#SW-Limit#>"}
            SW_Limit  :  BOOL;
            {#ix-set:AttributeName = "<#HW-Limit#>"}
            HW_Limit  :  BOOL;
            {#ix-set:AttributeName = "<#Trackingmode#>"}
            Trackingmode  :  BOOL;
            {#ix-set:AttributeName = "<#SetReferencePoint#>"}
            SetReferencePoint :  BOOL;
            {#ix-set:AttributeName = "<#reserved2#>"}
            reserved2 :  BOOL;
            {#ix-set:AttributeName = "<#reserved3#>"}
            reserved3 :  BOOL;
            {#ix-set:AttributeName = "<#reserved4#>"}
            reserved4    :  BOOL;
            {#ix-set:AttributeName = "<#jog_inc#>"}
            jog_inc  :  BOOL;
            {#ix-set:AttributeName = "<#reserved6#>"}
            reserved6    :  BOOL;
            {#ix-set:AttributeName = "<#reserved7#>"}
            reserved7    :  BOOL;
        END_VAR
    END_CLASS   

    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_STW2
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#TravelToFixStop#>"}
            TravelToFixStop    :  BOOL;
            {#ix-set:AttributeName = "<#reserved9#>"}
            reserved9    :  BOOL;
            {#ix-set:AttributeName = "<#reserved10#>"}
            reserved10    :  BOOL;
            {#ix-set:AttributeName = "<#reserved11#>"}
            reserved11 :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit0#>"}
            signOfLifeBit0    :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit1#>"}
            signOfLifeBit1 :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit2#>"}
            signOfLifeBit2  :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit3#>"}
            signOfLifeBit3  :  BOOL;
            {#ix-set:AttributeName = "<#reserved0#>"}
            reserved0  :  BOOL;
            {#ix-set:AttributeName = "<#reserved1#>"}
            reserved1 :  BOOL;
            {#ix-set:AttributeName = "<#reserved2#>"}
            reserved2 :  BOOL;
            {#ix-set:AttributeName = "<#reserved3#>"}
            reserved3 :  BOOL;
            {#ix-set:AttributeName = "<#reserved4#>"}
            reserved4    :  BOOL;
            {#ix-set:AttributeName = "<#reserved5#>"}
            reserved5    :  BOOL;
            {#ix-set:AttributeName = "<#reserved6#>"}
            reserved6  :  BOOL;
            {#ix-set:AttributeName = "<#reserved7#>"}
            reserved7    :  BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_OUT
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#STW1#>"}
            STW1      :   PROFIdriveTelegram_111_STW1;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#POS_STW1#>"}
            POS_STW1      :   PROFIdriveTelegram_111_POS_STW1;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#POS_STW2#>"}
            POS_STW2      :   PROFIdriveTelegram_111_POS_STW2;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#STW2#>"}
            STW2      :   PROFIdriveTelegram_111_STW2;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Override#>"}
            Override_    :	WORD;
            {#ix-set:AttributeName = "<#MDI_TARPOS#>"}
            MDI_TARPOS  :	DINT;
            {#ix-set:AttributeName = "<#MDI_VELOCITY#>"}
            MDI_VELOCITY    :	DINT;
            {#ix-set:AttributeName = "<#MDI_ACC#>"}
            MDI_ACC :	UINT;
            {#ix-set:AttributeName = "<#MDI_DEC#>"}
            MDI_DEC :	UINT;
            {#ix-set:AttributeName = "<#reserved11#>"}
            reserved11  :	WORD;

        END_VAR
    END_CLASS
    
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_ZSW1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#followingErrorInTolerance#>"}
            followingErrorInTolerance    :  BOOL;
            {#ix-set:AttributeName = "<#controlRequest#>"}
            controlRequest    :  BOOL;
            {#ix-set:AttributeName = "<#targetPosReached#>"}
            targetPosReached    :  BOOL;
            {#ix-set:AttributeName = "<#homePosSet#>"}
            homePosSet :  BOOL;
            {#ix-set:AttributeName = "<#acknowledgeTraversingBlockActivated#>"}
            acknowledgeTraversingBlockActivated    :  BOOL;
            {#ix-set:AttributeName = "<#driveStopped#>"}
            driveStopped :  BOOL;
            {#ix-set:AttributeName = "<#axisAccelerates#>"}
            axisAccelerates  :  BOOL;
            {#ix-set:AttributeName = "<#axisDecelerates#>"}
            axisDecelerates  :  BOOL;
            {#ix-set:AttributeName = "<#readyForSwitchOn#>"}
            readyForSwitchOn  :  BOOL;
            {#ix-set:AttributeName = "<#ready#>"}
            ready :  BOOL;
            {#ix-set:AttributeName = "<#operationEnabled#>"}
            operationEnabled :  BOOL;
            {#ix-set:AttributeName = "<#faultPresent#>"}
            faultPresent :  BOOL;
            {#ix-set:AttributeName = "<#noCoastingActive#>"}
            noCoastingActive    :  BOOL;
            {#ix-set:AttributeName = "<#noQuickStopActive#>"}
            noQuickStopActive    :  BOOL;
            {#ix-set:AttributeName = "<#switchingOnInhibitedActive#>"}
            switchingOnInhibitedActive  :  BOOL;
            {#ix-set:AttributeName = "<#warningActive#>"}
            warningActive    :  BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_ZSW2
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#deviceSpecificBit8#>"}
            deviceSpecificBit8    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit9#>"}
            deviceSpecificBit9    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit10#>"}
            deviceSpecificBit10    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit11#>"}
            deviceSpecificBit11 :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit0#>"}
            doSignOfLifeBit0    :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit1#>"}
            doSignOfLifeBit1 :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit2#>"}
            doSignOfLifeBit2  :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit3#>"}
            doSignOfLifeBit3  :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit0#>"}
            deviceSpecificBit0  :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit1#>"}
            deviceSpecificBit1 :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit2#>"}
            deviceSpecificBit2 :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit3#>"}
            deviceSpecificBit3 :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit4#>"}
            deviceSpecificBit4    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit5#>"}
            deviceSpecificBit5    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit6#>"}
            deviceSpecificBit6  :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit7#>"}
            deviceSpecificBit7    :  BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_IN
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#ZSW1#>"}
            ZSW1      :   PROFIdriveTelegram_111_ZSW1;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#POS_ZSW1#>"}
            POS_ZSW1      :   WORD;
            {#ix-set:AttributeName = "<#POS_ZSW2#>"}
            POS_ZSW2      :   WORD;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#ZSW2#>"}
            ZSW2      :   PROFIdriveTelegram_111_ZSW2;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#MELDW#>"}
            MELDW    :	WORD;
            {#ix-set:AttributeName = "<#XIST_A#>"}
            XIST_A  :	DINT;
            {#ix-set:AttributeName = "<#NIST_B#>"}
            NIST_B    :	DINT;
            {#ix-set:AttributeName = "<#Fault_Code#>"}
            Fault_Code :	UINT;
            {#ix-set:AttributeName = "<#Warn_Code#>"}
            Warn_Code :	UINT;
            {#ix-set:AttributeName = "<#Reserved#>"}
            Reserved  :	WORD;
        END_VAR
    END_CLASS


    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#OUT#>"}
            OUT      :   PROFIdriveTelegram_111_OUT;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IN#>"}
            IN      :   PROFIdriveTelegram_111_IN;
        END_VAR
    END_CLASS
END_NAMESPACE