NAMESPACE AXOpen.Components.Festo.Drives
   
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_STW1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#jog1#>"}
            {#ix-attr:[ReadOnly()]}
            jog1    :  BOOL;
            {#ix-set:AttributeName = "<#jog2#>"}
            {#ix-attr:[ReadOnly()]}
            jog2    :  BOOL;
            {#ix-set:AttributeName = "<#controlByPlc#>"}
            {#ix-attr:[ReadOnly()]}
            controlByPlc    :  BOOL;
            {#ix-set:AttributeName = "<#StartHoming#>"}
            {#ix-attr:[ReadOnly()]}
            StartHoming :  BOOL;
            {#ix-set:AttributeName = "<#ReleaseBrake#>"}
            {#ix-attr:[ReadOnly()]}
            ReleaseBrake    :  BOOL;
            {#ix-set:AttributeName = "<#ExternalBlockChange#>"}
            {#ix-attr:[ReadOnly()]}
            ExternalBlockChange :  BOOL;
            {#ix-set:AttributeName = "<#reserved14#>"}
            {#ix-attr:[ReadOnly()]}
            reserved14  :  BOOL;
            {#ix-set:AttributeName = "<#reserved15#>"}
            {#ix-attr:[ReadOnly()]}
            reserved15  :  BOOL;
            {#ix-set:AttributeName = "<#on#>"}
            {#ix-attr:[ReadOnly()]}
            on_  :  BOOL;
            {#ix-set:AttributeName = "<#noCoastStop#>"}
            {#ix-attr:[ReadOnly()]}
            noCoastStop :  BOOL;
            {#ix-set:AttributeName = "<#noQuickStop#>"}
            {#ix-attr:[ReadOnly()]}
            noQuickStop :  BOOL;
            {#ix-set:AttributeName = "<#enableOperation#>"}
            {#ix-attr:[ReadOnly()]}
            enableOperation :  BOOL;
            {#ix-set:AttributeName = "<#cancelTraversing#>"}
            {#ix-attr:[ReadOnly()]}
            cancelTraversing    :  BOOL;
            {#ix-set:AttributeName = "<#intermediateStop#>"}
            {#ix-attr:[ReadOnly()]}
            intermediateStop    :  BOOL;
            {#ix-set:AttributeName = "<#activateTraversing#>"}
            {#ix-attr:[ReadOnly()]}
            activateTraversing  :  BOOL;
            {#ix-set:AttributeName = "<#acknowledgeFault#>"}
            {#ix-attr:[ReadOnly()]}
            acknowledgeFault    :  BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_POS_STW1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#MDI_MOD#>"}
            {#ix-attr:[ReadOnly()]}
            MDI_MOD    :  BOOL;
            {#ix-set:AttributeName = "<#PosModulo#>"}
            {#ix-attr:[ReadOnly()]}
            PosModulo    :  BOOL;
            {#ix-set:AttributeName = "<#NegModulo#>"}
            {#ix-attr:[ReadOnly()]}
            NegModulo    :  BOOL;
            {#ix-set:AttributeName = "<#reserved11#>"}
            {#ix-attr:[ReadOnly()]}
            reserved11 :  BOOL;
            {#ix-set:AttributeName = "<#reserved12#>"}
            {#ix-attr:[ReadOnly()]}
            reserved12    :  BOOL;
            {#ix-set:AttributeName = "<#reserved13#>"}
            {#ix-attr:[ReadOnly()]}
            reserved13 :  BOOL;
            {#ix-set:AttributeName = "<#SetupMode#>"}
            {#ix-attr:[ReadOnly()]}
            SetupMode  :  BOOL;
            {#ix-set:AttributeName = "<#MDI_Activate#>"}
            {#ix-attr:[ReadOnly()]}
            MDI_Activate  :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit0#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit0  :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit1#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit1 :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit2#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit2 :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit3#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit3 :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit4#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit4    :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit5#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit5  :  BOOL;
            {#ix-set:AttributeName = "<#travBlockBit6#>"}
            {#ix-attr:[ReadOnly()]}
            travBlockBit6    :  BOOL;
            {#ix-set:AttributeName = "<#reserved7#>"}
            {#ix-attr:[ReadOnly()]}
            reserved7    :  BOOL;
        END_VAR
    END_CLASS   
    
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_POS_STW2
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#FlyingRef#>"}
            {#ix-attr:[ReadOnly()]}
            FlyingRef    :  BOOL;
            {#ix-set:AttributeName = "<#reserved9#>"}
            {#ix-attr:[ReadOnly()]}
            reserved9    :  BOOL;
            {#ix-set:AttributeName = "<#SelectProbe#>"}
            {#ix-attr:[ReadOnly()]}
            SelectProbe    :  BOOL;
            {#ix-set:AttributeName = "<#ProbeEdgeEval#>"}
            {#ix-attr:[ReadOnly()]}
            ProbeEdgeEval :  BOOL;
            {#ix-set:AttributeName = "<#reserved12#>"}
            {#ix-attr:[ReadOnly()]}
            reserved12    :  BOOL;
            {#ix-set:AttributeName = "<#reserved13#>"}
            {#ix-attr:[ReadOnly()]}
            reserved13 :  BOOL;
            {#ix-set:AttributeName = "<#SW-Limit#>"}
            {#ix-attr:[ReadOnly()]}
            SW_Limit  :  BOOL;
            {#ix-set:AttributeName = "<#HW-Limit#>"}
            {#ix-attr:[ReadOnly()]}
            HW_Limit  :  BOOL;
            {#ix-set:AttributeName = "<#Trackingmode#>"}
            {#ix-attr:[ReadOnly()]}
            Trackingmode  :  BOOL;
            {#ix-set:AttributeName = "<#SetReferencePoint#>"}
            {#ix-attr:[ReadOnly()]}
            SetReferencePoint :  BOOL;
            {#ix-set:AttributeName = "<#reserved2#>"}
            {#ix-attr:[ReadOnly()]}
            reserved2 :  BOOL;
            {#ix-set:AttributeName = "<#reserved3#>"}
            {#ix-attr:[ReadOnly()]}
            reserved3 :  BOOL;
            {#ix-set:AttributeName = "<#reserved4#>"}
            {#ix-attr:[ReadOnly()]}
            reserved4    :  BOOL;
            {#ix-set:AttributeName = "<#jog_inc#>"}
            {#ix-attr:[ReadOnly()]}
            jog_inc  :  BOOL;
            {#ix-set:AttributeName = "<#reserved6#>"}
            {#ix-attr:[ReadOnly()]}
            reserved6    :  BOOL;
            {#ix-set:AttributeName = "<#reserved7#>"}
            {#ix-attr:[ReadOnly()]}
            reserved7    :  BOOL;
        END_VAR
    END_CLASS   

    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_STW2
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#TravelToFixStop#>"}
            {#ix-attr:[ReadOnly()]}
            TravelToFixStop    :  BOOL;
            {#ix-set:AttributeName = "<#reserved9#>"}
            {#ix-attr:[ReadOnly()]}
            reserved9    :  BOOL;
            {#ix-set:AttributeName = "<#reserved10#>"}
            {#ix-attr:[ReadOnly()]}
            reserved10    :  BOOL;
            {#ix-set:AttributeName = "<#reserved11#>"}
            {#ix-attr:[ReadOnly()]}
            reserved11 :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit0#>"}
            {#ix-attr:[ReadOnly()]}
            signOfLifeBit0    :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit1#>"}
            {#ix-attr:[ReadOnly()]}
            signOfLifeBit1 :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit2#>"}
            {#ix-attr:[ReadOnly()]}
            signOfLifeBit2  :  BOOL;
            {#ix-set:AttributeName = "<#signOfLifeBit3#>"}
            {#ix-attr:[ReadOnly()]}
            signOfLifeBit3  :  BOOL;
            {#ix-set:AttributeName = "<#reserved0#>"}
            {#ix-attr:[ReadOnly()]}
            reserved0  :  BOOL;
            {#ix-set:AttributeName = "<#reserved1#>"}
            {#ix-attr:[ReadOnly()]}
            reserved1 :  BOOL;
            {#ix-set:AttributeName = "<#reserved2#>"}
            {#ix-attr:[ReadOnly()]}
            reserved2 :  BOOL;
            {#ix-set:AttributeName = "<#reserved3#>"}
            {#ix-attr:[ReadOnly()]}
            reserved3 :  BOOL;
            {#ix-set:AttributeName = "<#reserved4#>"}
            {#ix-attr:[ReadOnly()]}
            reserved4    :  BOOL;
            {#ix-set:AttributeName = "<#reserved5#>"}
            {#ix-attr:[ReadOnly()]}
            reserved5    :  BOOL;
            {#ix-set:AttributeName = "<#reserved6#>"}
            {#ix-attr:[ReadOnly()]}
            reserved6  :  BOOL;
            {#ix-set:AttributeName = "<#reserved7#>"}
            {#ix-attr:[ReadOnly()]}
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
            {#ix-attr:[ReadOnly()]}
            STW1      :   PROFIdriveTelegram_111_STW1;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#POS_STW1#>"}
            {#ix-attr:[ReadOnly()]}
            POS_STW1      :   PROFIdriveTelegram_111_POS_STW1;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#POS_STW2#>"}
            {#ix-attr:[ReadOnly()]}
            POS_STW2      :   PROFIdriveTelegram_111_POS_STW2;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#STW2#>"}
            {#ix-attr:[ReadOnly()]}
            STW2      :   PROFIdriveTelegram_111_STW2;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Override#>"}
            {#ix-attr:[ReadOnly()]}
            Override_    :	WORD;
            {#ix-set:AttributeName = "<#MDI_TARPOS#>"}
            {#ix-attr:[ReadOnly()]}
            MDI_TARPOS  :	DINT;
            {#ix-set:AttributeName = "<#MDI_VELOCITY#>"}
            {#ix-attr:[ReadOnly()]}
            MDI_VELOCITY    :	DINT;
            {#ix-set:AttributeName = "<#MDI_ACC#>"}
            {#ix-attr:[ReadOnly()]}
            MDI_ACC :	UINT;
            {#ix-set:AttributeName = "<#MDI_DEC#>"}
            {#ix-attr:[ReadOnly()]}
            MDI_DEC :	UINT;
            {#ix-set:AttributeName = "<#reserved11#>"}
            {#ix-attr:[ReadOnly()]}
            reserved11  :	WORD;

        END_VAR
    END_CLASS
    
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_ZSW1
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#followingErrorInTolerance#>"}
            {#ix-attr:[ReadOnly()]}
            followingErrorInTolerance    :  BOOL;
            {#ix-set:AttributeName = "<#controlRequest#>"}
            {#ix-attr:[ReadOnly()]}
            controlRequest    :  BOOL;
            {#ix-set:AttributeName = "<#targetPosReached#>"}
            {#ix-attr:[ReadOnly()]}
            targetPosReached    :  BOOL;
            {#ix-set:AttributeName = "<#homePosSet#>"}
            {#ix-attr:[ReadOnly()]}
            homePosSet :  BOOL;
            {#ix-set:AttributeName = "<#acknowledgeTraversingBlockActivated#>"}
            {#ix-attr:[ReadOnly()]}
            acknowledgeTraversingBlockActivated    :  BOOL;
            {#ix-set:AttributeName = "<#driveStopped#>"}
            {#ix-attr:[ReadOnly()]}
            driveStopped :  BOOL;
            {#ix-set:AttributeName = "<#axisAccelerates#>"}
            {#ix-attr:[ReadOnly()]}
            axisAccelerates  :  BOOL;
            {#ix-set:AttributeName = "<#axisDecelerates#>"}
            {#ix-attr:[ReadOnly()]}
            axisDecelerates  :  BOOL;
            {#ix-set:AttributeName = "<#readyForSwitchOn#>"}
            {#ix-attr:[ReadOnly()]}
            readyForSwitchOn  :  BOOL;
            {#ix-set:AttributeName = "<#ready#>"}
            {#ix-attr:[ReadOnly()]}
            ready :  BOOL;
            {#ix-set:AttributeName = "<#operationEnabled#>"}
            {#ix-attr:[ReadOnly()]}
            operationEnabled :  BOOL;
            {#ix-set:AttributeName = "<#faultPresent#>"}
            {#ix-attr:[ReadOnly()]}
            faultPresent :  BOOL;
            {#ix-set:AttributeName = "<#noCoastingActive#>"}
            {#ix-attr:[ReadOnly()]}
            noCoastingActive    :  BOOL;
            {#ix-set:AttributeName = "<#noQuickStopActive#>"}
            {#ix-attr:[ReadOnly()]}
            noQuickStopActive    :  BOOL;
            {#ix-set:AttributeName = "<#switchingOnInhibitedActive#>"}
            {#ix-attr:[ReadOnly()]}
            switchingOnInhibitedActive  :  BOOL;
            {#ix-set:AttributeName = "<#warningActive#>"}
            {#ix-attr:[ReadOnly()]}
            warningActive    :  BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_111_ZSW2
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#deviceSpecificBit8#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit8    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit9#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit9    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit10#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit10    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit11#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit11 :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit0#>"}
            {#ix-attr:[ReadOnly()]}
            doSignOfLifeBit0    :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit1#>"}
            {#ix-attr:[ReadOnly()]}
            doSignOfLifeBit1 :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit2#>"}
            {#ix-attr:[ReadOnly()]}
            doSignOfLifeBit2  :  BOOL;
            {#ix-set:AttributeName = "<#doSignOfLifeBit3#>"}
            {#ix-attr:[ReadOnly()]}
            doSignOfLifeBit3  :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit0#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit0  :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit1#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit1 :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit2#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit2 :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit3#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit3 :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit4#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit4    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit5#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit5    :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit6#>"}
            {#ix-attr:[ReadOnly()]}
            deviceSpecificBit6  :  BOOL;
            {#ix-set:AttributeName = "<#deviceSpecificBit7#>"}
            {#ix-attr:[ReadOnly()]}
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
            {#ix-attr:[ReadOnly()]}
            ZSW1      :   PROFIdriveTelegram_111_ZSW1;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#POS_ZSW1#>"}
            {#ix-attr:[ReadOnly()]}
            POS_ZSW1      :   WORD;
            {#ix-set:AttributeName = "<#POS_ZSW2#>"}
            {#ix-attr:[ReadOnly()]}
            POS_ZSW2      :   WORD;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#ZSW2#>"}
            {#ix-attr:[ReadOnly()]}
            ZSW2      :   PROFIdriveTelegram_111_ZSW2;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#MELDW#>"}
            {#ix-attr:[ReadOnly()]}
            MELDW    :	WORD;
            {#ix-set:AttributeName = "<#XIST_A#>"}
            {#ix-attr:[ReadOnly()]}
            XIST_A  :	DINT;
            {#ix-set:AttributeName = "<#NIST_B#>"}
            {#ix-attr:[ReadOnly()]}
            NIST_B    :	DINT;
            {#ix-set:AttributeName = "<#Fault_Code#>"}
            {#ix-attr:[ReadOnly()]}
            Fault_Code :	UINT;
            {#ix-set:AttributeName = "<#Warn_Code#>"}
            {#ix-attr:[ReadOnly()]}
            Warn_Code :	UINT;
            {#ix-set:AttributeName = "<#Reserved#>"}
            {#ix-attr:[ReadOnly()]}
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
            {#ix-attr:[ReadOnly()]}
            OUT      :   PROFIdriveTelegram_111_OUT;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IN#>"}
            {#ix-attr:[ReadOnly()]}
            IN      :   PROFIdriveTelegram_111_IN;
        END_VAR
    END_CLASS
END_NAMESPACE