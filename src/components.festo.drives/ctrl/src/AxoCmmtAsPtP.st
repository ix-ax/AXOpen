USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Components.Drives;
USING System.Math;

NAMESPACE AXOpen.Components.Festo.Drives
    
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoCmmtAsPtP EXTENDS AXOpen.Core.AxoComponent
        VAR CONSTANT
            MaxCounterStart             :	INT     :=	50;
            MAXMODE                     :	INT     :=	8;
        END_VAR

        VAR PRIVATE
            _AxisRef                :   AXOpen.Components.Festo.Drives.AxoCmmtAsPtPAxisReference;
            stat_Ready4Motion	    :   BOOL;
            stat_ExecuteIntern	    :   BOOL;
            stat_StepHome	        :   UINT;
            stat_RetDPRD	        :   INT;
            stat_RetDPWR	        :   INT;
            stat_ExecAux	        :   BOOL;
            stat_ExecR_Trig	        :   BOOL;
            stat_Jog1PAux	        :   BOOL;
            stat_Jog1PR_trig	    :   BOOL;
            stat_Jog2PAux	        :   BOOL;
            stat_Jog2PR_trig	    :   BOOL;
            stat_Jog1PMode8Aux	    :   BOOL;
            stat_Jog1PMode8R_trig	:   BOOL;
            stat_Jog2PMode8Aux	    :   BOOL;
            stat_Jog2PMode8R_trig	:   BOOL;
            stat_Status	            :   WORD;
            statStartCounter	    :   INT;
            stat_ActMode	        :   INT;
            stat_MaxCounterRetries	:   INT;
            
        END_VAR
    
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Positioning")]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            Inputs         :   AxoCmmtAsPtP_In;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Positioning")]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs         :   AxoCmmtAsPtP_Out;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Parametrization#>"}
            Parametrization : AxoReadWritePROFIdriveParameter;
        END_VAR

        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            DriveConfig         :   AxoDrive_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            DriveStatus         :   AxoDrive_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR
        

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject; 
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   INT;                        //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is TRUE, power is being enabled.
            END_VAR


            IF _context_ = null THEN 
                Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
                IF parent = NULL THEN
                    DriveStatus.Error.Id := UINT#700;
                    RETURN;
                END_IF;

                THIS.Initialize(parent);
                Parametrization.Initialize(THIS);
            END_IF;

            IF NOT THIS.AreValidReferences(refTelegram111_In := refTelegram111_In, refTelegram750_In := refTelegram750_In,refTelegram111_Out := refTelegram111_Out, refTelegram750_Out := refTelegram750_Out) THEN
                RETURN;
            END_IF;
            
            THIS.Open();
            THIS.UpdateInputs(refTelegram111_In := refTelegram111_In, refTelegram750_In := refTelegram750_In,MAP_HW_ID := MAP_HW_ID, AxisRef := REF(_AxisRef));
            THIS.Execute();
            // THIS.UpdateStatus(_AxisRefExt);
            THIS.UpdateOutputs(AxisRef := REF(_AxisRef), refTelegram111_Out := refTelegram111_Out, refTelegram750_Out := refTelegram750_Out);
            THIS.Close();    
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoContext; 
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   INT;                        //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is TRUE, power is being enabled.
            END_VAR
           
            IF _context_ = null THEN 
                Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
                IF parent = NULL THEN
                    DriveStatus.Error.Id := UINT#700;
                    RETURN;
                END_IF;

                THIS.Initialize(parent);
                Parametrization.Initialize(THIS);
            END_IF;

            IF NOT THIS.AreValidReferences(refTelegram111_In := refTelegram111_In, refTelegram750_In := refTelegram750_In,refTelegram111_Out := refTelegram111_Out, refTelegram750_Out := refTelegram750_Out) THEN
                RETURN;
            END_IF;
            
            THIS.Open();
            THIS.UpdateInputs(refTelegram111_In := refTelegram111_In, refTelegram750_In := refTelegram750_In,MAP_HW_ID := MAP_HW_ID, AxisRef := REF(_AxisRef));
            THIS.Execute();
            // THIS.UpdateStatus(_AxisRefExt);
            THIS.UpdateOutputs(AxisRef := REF(_AxisRef), refTelegram111_Out := refTelegram111_Out, refTelegram750_Out := refTelegram750_Out);
            THIS.Close();          
        END_METHOD   

        METHOD PRIVATE AreValidReferences: BOOL
            VAR_INPUT
                refTelegram111_In       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refTelegram750_In       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refTelegram111_Out      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter output data of the axis
                refTelegram750_Out      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
            AreValidReferences := FALSE;
            IF refTelegram750_In = NULL THEN
                DriveStatus.Error.Id := UINT#703;
            ELSIF refTelegram750_Out = NULL THEN
                DriveStatus.Error.Id := UINT#704;
            ELSIF refTelegram111_In = NULL THEN
                DriveStatus.Error.Id := UINT#705;
            ELSIF refTelegram111_Out = NULL THEN
                DriveStatus.Error.Id := UINT#706;
            ELSE
                AreValidReferences := TRUE;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#703,refTelegram750_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,refTelegram750_Out = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,refTelegram111_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,refTelegram111_Out = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD


        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PRIVATE UpdateInputs : BOOL
            VAR_INPUT
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   INT;                        //  Hardware identifier of the module acces point submodule 
                AxisRef             :   REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsPtPAxisReference;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#707,AxisRef = NULL, eAxoMessageCategory#ProgrammingError);
            IF AxisRef = NULL THEN
                DriveStatus.Error.Id := UINT#707;
                RETURN;
            END_IF;

            // ZSW1
            AxisRef^.Telegram111_In.ZSW1.followingErrorInTolerance             := refTelegram111_In^[0].%X0;
            AxisRef^.Telegram111_In.ZSW1.controlRequest                        := refTelegram111_In^[0].%X1;
            AxisRef^.Telegram111_In.ZSW1.targetPosReached                      := refTelegram111_In^[0].%X2;
            AxisRef^.Telegram111_In.ZSW1.homePosSet                            := refTelegram111_In^[0].%X3;
            AxisRef^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated   := refTelegram111_In^[0].%X4;
            AxisRef^.Telegram111_In.ZSW1.driveStopped                          := refTelegram111_In^[0].%X5;
            AxisRef^.Telegram111_In.ZSW1.axisAccelerates                       := refTelegram111_In^[0].%X6;
            AxisRef^.Telegram111_In.ZSW1.axisDecelerates                       := refTelegram111_In^[0].%X7;
            AxisRef^.Telegram111_In.ZSW1.readyForSwitchOn                      := refTelegram111_In^[1].%X0;
            AxisRef^.Telegram111_In.ZSW1.ready                                 := refTelegram111_In^[1].%X1;
            AxisRef^.Telegram111_In.ZSW1.operationEnabled                      := refTelegram111_In^[1].%X2;
            AxisRef^.Telegram111_In.ZSW1.faultPresent                          := refTelegram111_In^[1].%X3;
            AxisRef^.Telegram111_In.ZSW1.noCoastingActive                      := refTelegram111_In^[1].%X4;
            AxisRef^.Telegram111_In.ZSW1.noQuickStopActive                     := refTelegram111_In^[1].%X5;
            AxisRef^.Telegram111_In.ZSW1.switchingOnInhibitedActive            := refTelegram111_In^[1].%X6;
            AxisRef^.Telegram111_In.ZSW1.warningActive                         := refTelegram111_In^[1].%X7;
            //POS_ZSW1
            AxisRef^.Telegram111_In.POS_ZSW1.%B1                               := refTelegram111_In^[2];
            AxisRef^.Telegram111_In.POS_ZSW1.%B0                               := refTelegram111_In^[3];
            Outputs.EPosZSW1 := axisref^.telegram111_In.POS_ZSW1;
            //POS_ZSW2
            AxisRef^.Telegram111_In.POS_ZSW2.%B1                               := refTelegram111_In^[4];
            AxisRef^.Telegram111_In.POS_ZSW2.%B0                               := refTelegram111_In^[5];
            Outputs.EPosZSW2 := axisref^.telegram111_In.POS_ZSW2;
            // ZSW2
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit8                    := refTelegram111_In^[6].%X0;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit9                    := refTelegram111_In^[6].%X1;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit10                   := refTelegram111_In^[6].%X2;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit11                   := refTelegram111_In^[6].%X3;
            AxisRef^.Telegram111_In.ZSW2.doSignOfLifeBit0                      := refTelegram111_In^[6].%X4;
            AxisRef^.Telegram111_In.ZSW2.doSignOfLifeBit1                      := refTelegram111_In^[6].%X5;
            AxisRef^.Telegram111_In.ZSW2.doSignOfLifeBit2                      := refTelegram111_In^[6].%X6;
            AxisRef^.Telegram111_In.ZSW2.doSignOfLifeBit3                      := refTelegram111_In^[6].%X7;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit0                    := refTelegram111_In^[7].%X0;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit1                    := refTelegram111_In^[7].%X1;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit2                    := refTelegram111_In^[7].%X2;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit3                    := refTelegram111_In^[7].%X3;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit4                    := refTelegram111_In^[7].%X4;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit5                    := refTelegram111_In^[7].%X5;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit6                    := refTelegram111_In^[7].%X6;
            AxisRef^.Telegram111_In.ZSW2.deviceSpecificBit7                    := refTelegram111_In^[7].%X7;
            //MELDW
            AxisRef^.Telegram111_In.MELDW.%B1                                  := refTelegram111_In^[8];
            AxisRef^.Telegram111_In.MELDW.%B0                                  := refTelegram111_In^[9];
            //XIST_A
            AxisRef^.Telegram111_In.XIST_A.%B3                                 := refTelegram111_In^[10];
            AxisRef^.Telegram111_In.XIST_A.%B2                                 := refTelegram111_In^[11];
            AxisRef^.Telegram111_In.XIST_A.%B1                                 := refTelegram111_In^[12];
            AxisRef^.Telegram111_In.XIST_A.%B0                                 := refTelegram111_In^[13];
            //NIST_B
            AxisRef^.Telegram111_In.NIST_B.%B3                                 := refTelegram111_In^[14];
            AxisRef^.Telegram111_In.NIST_B.%B2                                 := refTelegram111_In^[15];
            AxisRef^.Telegram111_In.NIST_B.%B1                                 := refTelegram111_In^[16];
            AxisRef^.Telegram111_In.NIST_B.%B0                                 := refTelegram111_In^[17];
            //Fault_Code
            AxisRef^.Telegram111_In.Fault_Code.%B1                             := refTelegram111_In^[18];
            AxisRef^.Telegram111_In.Fault_Code.%B0                             := refTelegram111_In^[19];
            //Warn_Code
            AxisRef^.Telegram111_In.Warn_Code.%B1                              := refTelegram111_In^[20];
            AxisRef^.Telegram111_In.Warn_Code.%B0                              := refTelegram111_In^[21];
            //Reserved 
            AxisRef^.Telegram111_In.Reserved.%B1                               := refTelegram111_In^[22];
            AxisRef^.Telegram111_In.Reserved.%B0                               := refTelegram111_In^[23];
            //M_Actual 
            AxisRef^.Telegram750_In.M_Actual.%B1                               := refTelegram750_In^[0];
            AxisRef^.Telegram750_In.M_Actual.%B0                               := refTelegram750_In^[1];
            //MAP_HW_ID
            AxisRef^.Data.MAP_HW_ID := MAP_HW_ID;
        END_METHOD   

        ///<summary>
        /// Ensures swapping the AxisRef data structure into the hardware output data structure
        ///</summary>
        METHOD PRIVATE UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef             :   REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsPtPAxisReference;
                refTelegram111_Out  :   REF_TO ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
            END_VAR
            VAR
                tempDWord   :   DWORD;
            END_VAR
            
            Messenger.ActivateOnCondition(ULINT#708,AxisRef = NULL, eAxoMessageCategory#ProgrammingError);
            IF AxisRef = NULL THEN
                DriveStatus.Error.Id := UINT#708;
                RETURN;
            END_IF;

            //STW1
            refTelegram111_Out^[1].%X0 := AxisRef^.Telegram111_Out.STW1.on_;
            refTelegram111_Out^[1].%X1 := AxisRef^.Telegram111_Out.STW1.noCoastStop;
            refTelegram111_Out^[1].%X2 := AxisRef^.Telegram111_Out.STW1.noQuickStop;
            refTelegram111_Out^[1].%X3 := AxisRef^.Telegram111_Out.STW1.enableOperation;
            refTelegram111_Out^[1].%X4 := AxisRef^.Telegram111_Out.STW1.cancelTraversing;
            refTelegram111_Out^[1].%X5 := AxisRef^.Telegram111_Out.STW1.intermediateStop;
            refTelegram111_Out^[1].%X6 := AxisRef^.Telegram111_Out.STW1.activateTraversing;
            refTelegram111_Out^[1].%X7 := AxisRef^.Telegram111_Out.STW1.acknowledgeFault;
            refTelegram111_Out^[0].%X0 := AxisRef^.Telegram111_Out.STW1.jog1;
            refTelegram111_Out^[0].%X1 := AxisRef^.Telegram111_Out.STW1.jog2;
            refTelegram111_Out^[0].%X2 := AxisRef^.Telegram111_Out.STW1.controlByPlc;
            refTelegram111_Out^[0].%X3 := AxisRef^.Telegram111_Out.STW1.StartHoming;
            refTelegram111_Out^[0].%X4 := AxisRef^.Telegram111_Out.STW1.ReleaseBrake;
            refTelegram111_Out^[0].%X5 := AxisRef^.Telegram111_Out.STW1.ExternalBlockChange;
            refTelegram111_Out^[0].%X6 := AxisRef^.Telegram111_Out.STW1.reserved14;
            refTelegram111_Out^[0].%X7 := AxisRef^.Telegram111_Out.STW1.reserved15;
            //POS_STW1
            refTelegram111_Out^[3].%X0 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit0;
            refTelegram111_Out^[3].%X1 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit1;
            refTelegram111_Out^[3].%X2 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit2;
            refTelegram111_Out^[3].%X3 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit3;
            refTelegram111_Out^[3].%X4 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit4;
            refTelegram111_Out^[3].%X5 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit5;
            refTelegram111_Out^[3].%X6 := AxisRef^.Telegram111_Out.POS_STW1.travBlockBit6;
            refTelegram111_Out^[3].%X7 := AxisRef^.Telegram111_Out.POS_STW1.reserved7;
            refTelegram111_Out^[2].%X0 := AxisRef^.Telegram111_Out.POS_STW1.MDI_MOD;
            refTelegram111_Out^[2].%X1 := AxisRef^.Telegram111_Out.POS_STW1.PosModulo;
            refTelegram111_Out^[2].%X2 := AxisRef^.Telegram111_Out.POS_STW1.NegModulo;
            refTelegram111_Out^[2].%X3 := AxisRef^.Telegram111_Out.POS_STW1.reserved11;
            refTelegram111_Out^[2].%X4 := AxisRef^.Telegram111_Out.POS_STW1.reserved12;
            refTelegram111_Out^[2].%X5 := AxisRef^.Telegram111_Out.POS_STW1.reserved13;
            refTelegram111_Out^[2].%X6 := AxisRef^.Telegram111_Out.POS_STW1.SetupMode;
            refTelegram111_Out^[2].%X7 := AxisRef^.Telegram111_Out.POS_STW1.MDI_Activate;    
            //POS_STW2
            refTelegram111_Out^[5].%X0 := AxisRef^.Telegram111_Out.POS_STW2.Trackingmode;
            refTelegram111_Out^[5].%X1 := AxisRef^.Telegram111_Out.POS_STW2.SetReferencePoint;
            refTelegram111_Out^[5].%X2 := AxisRef^.Telegram111_Out.POS_STW2.reserved2;
            refTelegram111_Out^[5].%X3 := AxisRef^.Telegram111_Out.POS_STW2.reserved3;
            refTelegram111_Out^[5].%X4 := AxisRef^.Telegram111_Out.POS_STW2.reserved4;
            refTelegram111_Out^[5].%X5 := AxisRef^.Telegram111_Out.POS_STW2.jog_inc;
            refTelegram111_Out^[5].%X6 := AxisRef^.Telegram111_Out.POS_STW2.reserved6;
            refTelegram111_Out^[5].%X7 := AxisRef^.Telegram111_Out.POS_STW2.reserved7;
            refTelegram111_Out^[4].%X0 := AxisRef^.Telegram111_Out.POS_STW2.FlyingRef;
            refTelegram111_Out^[4].%X1 := AxisRef^.Telegram111_Out.POS_STW2.reserved9;
            refTelegram111_Out^[4].%X2 := AxisRef^.Telegram111_Out.POS_STW2.SelectProbe;
            refTelegram111_Out^[4].%X3 := AxisRef^.Telegram111_Out.POS_STW2.ProbeEdgeEval;
            refTelegram111_Out^[4].%X4 := AxisRef^.Telegram111_Out.POS_STW2.reserved12;
            refTelegram111_Out^[4].%X5 := AxisRef^.Telegram111_Out.POS_STW2.reserved13;
            refTelegram111_Out^[4].%X6 := AxisRef^.Telegram111_Out.POS_STW2.SW_Limit;
            refTelegram111_Out^[4].%X7 := AxisRef^.Telegram111_Out.POS_STW2.HW_Limit;
            //STW2
            refTelegram111_Out^[7].%X0 := AxisRef^.Telegram111_Out.STW2.reserved0;
            refTelegram111_Out^[7].%X1 := AxisRef^.Telegram111_Out.STW2.reserved1;
            refTelegram111_Out^[7].%X2 := AxisRef^.Telegram111_Out.STW2.reserved2;
            refTelegram111_Out^[7].%X3 := AxisRef^.Telegram111_Out.STW2.reserved3;
            refTelegram111_Out^[7].%X4 := AxisRef^.Telegram111_Out.STW2.reserved4;
            refTelegram111_Out^[7].%X5 := AxisRef^.Telegram111_Out.STW2.reserved5;
            refTelegram111_Out^[7].%X6 := AxisRef^.Telegram111_Out.STW2.reserved6;
            refTelegram111_Out^[7].%X7 := AxisRef^.Telegram111_Out.STW2.reserved7;
            refTelegram111_Out^[6].%X0 := AxisRef^.Telegram111_Out.STW2.TravelToFixStop;
            refTelegram111_Out^[6].%X1 := AxisRef^.Telegram111_Out.STW2.reserved9;
            refTelegram111_Out^[6].%X2 := AxisRef^.Telegram111_Out.STW2.reserved10;
            refTelegram111_Out^[6].%X3 := AxisRef^.Telegram111_Out.STW2.reserved11;
            refTelegram111_Out^[6].%X4 := AxisRef^.Telegram111_Out.STW2.signOfLifeBit0;
            refTelegram111_Out^[6].%X5 := AxisRef^.Telegram111_Out.STW2.signOfLifeBit1;
            refTelegram111_Out^[6].%X6 := AxisRef^.Telegram111_Out.STW2.signOfLifeBit2;
            refTelegram111_Out^[6].%X7 := AxisRef^.Telegram111_Out.STW2.signOfLifeBit3;   
            //Override
            refTelegram111_Out^[9] := AxisRef^.Telegram111_Out.Override_.%B0;
            refTelegram111_Out^[8] := AxisRef^.Telegram111_Out.Override_.%B1;
            //TargetPos
            tempDWord := TO_DWORD(AxisRef^.Telegram111_Out.MDI_TARPOS);
            refTelegram111_Out^[13] := tempDWord.%B0;
            refTelegram111_Out^[12] := tempDWord.%B1;
            refTelegram111_Out^[11] := tempDWord.%B2;
            refTelegram111_Out^[10] := tempDWord.%B3;
            //TargetVelocity
            tempDWord := TO_DWORD(AxisRef^.Telegram111_Out.MDI_VELOCITY);
            refTelegram111_Out^[17] := tempDWord.%B0;
            refTelegram111_Out^[16] := tempDWord.%B1;
            refTelegram111_Out^[15] := tempDWord.%B2;
            refTelegram111_Out^[14] := tempDWord.%B3;
            // ACC, DEC
            refTelegram111_Out^[19] := AxisRef^.Telegram111_Out.MDI_ACC.%B0;
            refTelegram111_Out^[18] := AxisRef^.Telegram111_Out.MDI_ACC.%B1;
            refTelegram111_Out^[21] := AxisRef^.Telegram111_Out.MDI_DEC.%B0;
            refTelegram111_Out^[20] := AxisRef^.Telegram111_Out.MDI_DEC.%B1;
            refTelegram111_Out^[23] := AxisRef^.Telegram111_Out.reserved11.%B0;
            refTelegram111_Out^[22] := AxisRef^.Telegram111_Out.reserved11.%B1;
            // M_ADD1, M_LIMIT_POS, M_LIMIT_NEG
            refTelegram750_Out^[1] := AxisRef^.Telegram750_Out.M_ADD1.%B0;
            refTelegram750_Out^[0] := AxisRef^.Telegram750_Out.M_ADD1.%B1;
            refTelegram750_Out^[3] := AxisRef^.Telegram750_Out.M_LIMIT_POS.%B0;
            refTelegram750_Out^[2] := AxisRef^.Telegram750_Out.M_LIMIT_POS.%B1;
            refTelegram750_Out^[5] := AxisRef^.Telegram750_Out.M_LIMIT_NEG.%B0;
            refTelegram750_Out^[4] := AxisRef^.Telegram750_Out.M_LIMIT_NEG.%B1;
            refTelegram750_Out^[7] := AxisRef^.Telegram750_Out.Reserved.%B0;
            refTelegram750_Out^[6] := AxisRef^.Telegram750_Out.Reserved.%B1;
        END_METHOD   


        METHOD PRIVATE Execute
            Parametrization.Run(THIS);
            Parametrization.HardwareId := TO_WORD(_AxisRef.Data.MAP_HW_ID);

            // Check the Mode of Operation
            IF Inputs.ModePos > MAXMODE THEN
                Outputs.Error := TRUE;
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_INVALID_MODE;
                stat_ExecuteIntern := FALSE;
            ELSIF Inputs.ModePos < 1 THEN
                Outputs.Error := TRUE;
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_INVALID_MODE;
                stat_ExecuteIntern := FALSE;
            ELSE
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_INVALID_MODE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the Velocity Override 
            IF (Inputs.OverV < 0) OR (Inputs.OverV > 199) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE;
                Outputs.Error := TRUE;
            ELSE
                // Write Velocity Override into Send Buffer
                _AxisRef.Telegram111_Out.Override_ := TO_WORD(TO_INT(16384.0 * (TO_REAL(Inputs.OverV) / 100.0)));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the Acceleration Override  (0% - 100%, 100% => WORD#16#4000)
            IF (Inputs.OverAcc < 0) OR (Inputs.OverAcc > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE;
                Outputs.Error := TRUE;
            ELSE
                // Write Acceleration Override into Send Buffer
                _AxisRef.Telegram111_Out.MDI_ACC := TO_UINT(16384.0 * (TO_REAL(Inputs.OverAcc) / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the Deceleration Override  (0% - 100%, 100% => WORD#16#4000)
            IF (Inputs.OverDec < 0) OR (Inputs.OverDec > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE;
                Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram111_Out.MDI_DEC := TO_UINT(16384.0 * (TO_REAL(Inputs.OverDec) / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the AdditionalTorque  (0% - 100%, 100% => WORD#16#4000)
            IF (Inputs.AdditionalTorque < 0) OR (Inputs.AdditionalTorque > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE;
                Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram750_Out.M_ADD1 := TO_INT(16384.0 * (Inputs.AdditionalTorque / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the PositiveTorqueLimit  (0% - 100%, 100% => WORD#16#4000)
            IF (Inputs.PositiveTorqueLimit < 0) OR (Inputs.PositiveTorqueLimit > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_POS;
                Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram750_Out.M_LIMIT_POS := TO_INT(16384.0 * (Inputs.PositiveTorqueLimit / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_POS THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the NegativeTorqueLimit  (0% - 100%, 100% => WORD#16#4000)
            IF (Inputs.NegativeTorqueLimit < 0) OR (Inputs.NegativeTorqueLimit > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_NEG;
                Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram750_Out.M_LIMIT_NEG := TO_INT(-16384.0 * (Inputs.NegativeTorqueLimit / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_NEG THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;

            // Mapping of the Outputs
            Outputs.AxisEnabled := _AxisRef.Telegram111_In.ZSW1.operationEnabled;
            Outputs.AxisError := _AxisRef.Telegram111_In.ZSW1.faultPresent;
            Outputs.AxisWarn := _AxisRef.Telegram111_In.ZSW1.warningActive;
            Outputs.AxisPosOk := _AxisRef.Telegram111_In.ZSW1.targetPosReached;
            Outputs.AxisRef := _AxisRef.Telegram111_In.ZSW1.homePosSet;
            Outputs.AxisAckSetpoint := _AxisRef.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated;
            Outputs.ClampTorqueReached := _AxisRef.Telegram111_In.POS_ZSW2.%X13;
            Outputs.AxisSpFixed := _AxisRef.Telegram111_In.ZSW1.driveStopped;
            Outputs.ActVelocity := TO_REAL(_AxisRef.Telegram111_In.NIST_B);
            Outputs.ActTorque := _AxisRef.Telegram750_In.M_Actual;

            //scaling the ActVelocity output
            IF Inputs.BaseSpeedValue <> 0 THEN
                Outputs.ActVelocity := Outputs.ActVelocity * ((Inputs.BaseSpeedValue / REAL#1073741824.0));
            END_IF;

            Outputs.ActPosition := _AxisRef.Telegram111_In.XIST_A;
            Outputs.ActWarn := TO_WORD(_AxisRef.Telegram111_In.Warn_Code);
            Outputs.ActFault := TO_WORD(_AxisRef.Telegram111_In.Fault_Code);
            Outputs.Lockout := _AxisRef.Telegram111_In.ZSW1.switchingOnInhibitedActive;

            //Check the drive error and Lockout status
            IF Outputs.AxisError THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_DRIVE_ERROR;
                Outputs.Error := TRUE;
            ELSIF Outputs.Lockout THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_SWITCH_ON_INHIBITED;
                Outputs.Error := TRUE;
            ELSE
                // error is gone -> set status in operational
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_DRIVE_ERROR OR stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_SWITCH_ON_INHIBITED THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Outputs.Error := FALSE;
                END_IF;
            END_IF;

            //Enable the Axis
            _AxisRef.Telegram111_Out.STW1.on_ := Inputs.EnableAxis;                        //STW1.0

            //fix values for STW1 data
            _AxisRef.Telegram111_Out.STW1.cancelTraversing := Inputs.CancelTraversing;     //STW1.4
            _AxisRef.Telegram111_Out.STW1.intermediateStop := Inputs.IntermediateStop;     //STW1.5
            _AxisRef.Telegram111_Out.STW1.acknowledgeFault := Inputs.AckError;             //STW1.7
            _AxisRef.Telegram111_Out.STW1.controlByPlc := TRUE;                            //STW1.10
            _AxisRef.Telegram111_Out.STW1.enableOperation := TRUE;                         //STW1.3

            // copy the position set value into the send struct
            IF Inputs.ModePos <> 4 OR Inputs.ModePos <> 5 OR Inputs.ModePos <> 6 OR Inputs.ModePos <> 7 OR Inputs.ModePos <> 8 THEN
                _AxisRef.Telegram111_Out.MDI_TARPOS := Inputs.Position;
            ELSE
                _AxisRef.Telegram111_Out.MDI_TARPOS := 0;
            END_IF;

            //copy the velocity set value into the send struct
            _AxisRef.Telegram111_Out.MDI_VELOCITY := Inputs.Velocity;

            //Jog bits
            // Mode 7
            //Generate the Jog1 Edge
            stat_Jog1PR_trig := Inputs.Jog1 AND NOT stat_Jog1PAux;
            //Reset the Auxiliary flag 
            stat_Jog1PAux := Inputs.Jog1;

            //Generate the Jog2 Edge
            stat_Jog2PR_trig := Inputs.Jog2 AND NOT stat_Jog2PAux;
            //Reset the Auxiliary flag 
            stat_Jog2PAux := Inputs.Jog2;

            //Mode 8
            //Generate the Jog1 Edge
            stat_Jog1PMode8R_trig := Inputs.Jog1 AND NOT stat_Jog1PMode8Aux;
            //Reset the Auxiliary flag 
            stat_Jog1PMode8Aux := Inputs.Jog1;

            //Generate the Jog2 Edge
            stat_Jog2PMode8R_trig := Inputs.Jog2 AND NOT stat_Jog2PMode8Aux;
            //Reset the Auxiliary flag 
            stat_Jog2PMode8Aux := Inputs.Jog2;

            IF Inputs.ModePos <> 4 THEN
                //Start homing
                _AxisRef.Telegram111_Out.STW1.StartHoming := FALSE;
            END_IF;

            //Relative - Absolute
            _AxisRef.Telegram111_Out.POS_STW1.MDI_MOD := FALSE;

            //Positive - Negative direction
            _AxisRef.Telegram111_Out.POS_STW1.PosModulo := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.NegModulo := FALSE;

            // setup mode 
            _AxisRef.Telegram111_Out.POS_STW1.SetupMode := FALSE;

            // MDI Active
            _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;

            //Trackingmode
            _AxisRef.Telegram111_Out.POS_STW2.Trackingmode := FALSE;

            //Jog increment
            _AxisRef.Telegram111_Out.POS_STW2.jog_inc := FALSE;

            //delete all the record bits
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
            _AxisRef.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;

            //Check if the drive is ready for a motion
            IF _AxisRef.telegram111_In.ZSW1.operationEnabled THEN
                stat_Ready4Motion := TRUE;
            ELSE
                stat_Ready4Motion := FALSE;
            END_IF;

            //Generate the Execute Edge for Mode = 4 and 5
            stat_ExecR_Trig := Inputs.ExecuteMode AND NOT stat_ExecAux;
            //Reset the Auxiliary flag 
            stat_ExecAux := Inputs.ExecuteMode;

            // Set the Execute command according to the ModePos
            IF NOT Inputs.ExecuteMode THEN
                stat_ExecuteIntern := FALSE;
                stat_StepHome := UINT#0;
            ELSIF Inputs.ExecuteMode AND stat_Ready4Motion AND NOT (Inputs.ModePos = 4 OR Inputs.ModePos = 5 OR Inputs.ModePos = 7 OR Inputs.ModePos = 8) THEN
                stat_ExecuteIntern := TRUE;
                stat_ActMode := Inputs.ModePos;
                stat_StepHome := UINT#0;
            ELSIF stat_ExecR_Trig AND (Inputs.ModePos = 4 OR Inputs.ModePos = 5) THEN
                stat_ActMode := Inputs.ModePos;
                stat_StepHome := UINT#0;
            ELSIF Inputs.ExecuteMode AND (stat_ActMode = 7 OR stat_ActMode = 8) THEN
                stat_ExecuteIntern := FALSE;
                stat_StepHome := UINT#0;
            ELSIF Inputs.ExecuteMode AND Inputs.ModePos = 4 THEN
                
                CASE stat_StepHome OF
                        
                    UINT#0: // homing is active
                        IF NOT Outputs.AxisRef THEN
                            stat_StepHome := UINT#10;
                        ELSIF Outputs.AxisError OR (NOT Outputs.AxisSpFixed AND Inputs.ModePos = 4) THEN
                            stat_ExecuteIntern := FALSE;
                        END_IF;
                        
                        UINT#10: // wait for homing done
                        IF Outputs.AxisRef OR Outputs.AxisError OR (NOT stat_Ready4Motion AND Inputs.ModePos = 4) OR Inputs.ModePos <> stat_ActMode OR NOT Inputs.ExecuteMode THEN
                            stat_ExecuteIntern := FALSE;
                            stat_StepHome := UINT#0;
                        END_IF;
                END_CASE;
            ELSIF stat_ExecuteIntern AND Inputs.ModePos <> stat_ActMode THEN
                stat_ExecuteIntern := FALSE;
                stat_StepHome := UINT#0;
            END_IF;

            //Reset the jog bits if the ModePos has changed
            IF (_AxisRef.Telegram111_Out.STW1.jog1 OR _AxisRef.Telegram111_Out.STW1.jog2) AND Inputs.ModePos <> stat_ActMode THEN
                //Set the jog bits to zero
                _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
            END_IF;

            // Positionig mode with relative movement (MDI)
            IF Inputs.ModePos = 1 THEN
                
                // Set the MDI bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Inputs.Positive;
                
                // inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    //Start Traversing Task
                    _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                    
                END_IF;
                
                // Positionig mode with absolute movement (MDI)
            ELSIF Inputs.ModePos = 2 THEN
                
                // Set the MDI bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                
                //set the Absolute bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_MOD := TRUE;
                
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Inputs.Positive;
                
                // inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    //Start Traversing Task
                    _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                    
                END_IF;
                
                // Positioning with setup mode for endless motion
            ELSIF Inputs.ModePos = 3 THEN
                // Set the MDI bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                
                //set the Absolute bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_MOD := TRUE;
                
                //setup mode
                _AxisRef.Telegram111_Out.POS_STW1.SetupMode := TRUE;
                
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Inputs.Positive;
                
                // inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    //Start Traversing Task
                    _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                    
                END_IF;
                
                //Homing mode done by the drive due to the parametrized homing method
            ELSIF Inputs.ModePos = 4 THEN
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Inputs.Positive;
                
                // inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    //Start homing
                    IF NOT _AxisRef.Telegram111_Out.STW1.StartHoming THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    _AxisRef.Telegram111_Out.STW1.StartHoming := stat_ExecuteIntern;
                END_IF;
                
                //set the reference point (actual position)
            ELSIF Inputs.ModePos = 5 THEN
                
                // check if there is no error in the drive - this function works also when drive is not enabled
                IF NOT Outputs.AxisError THEN
                    
                    //Start homing
                    IF NOT _AxisRef.Telegram111_Out.POS_STW2.SetReferencePoint THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    //Set the axis zero point
                    _AxisRef.Telegram111_Out.POS_STW2.SetReferencePoint := stat_ExecuteIntern;
                    
                END_IF;
                
                //Record mode - parametrized records in the drive can be used
            ELSIF Inputs.ModePos = 6 THEN
                
                //set the position number into the record bits 
                IF (TO_INT(Inputs.Position) < 0) OR (TO_INT(Inputs.Position) > 127) THEN
                    // Error, wrong record number
                    stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_INVALID_TRV_BLOCK;
                    Outputs.Error := TRUE;
                ELSE
                    // error is gone -> set status in operational
                    IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_INVALID_TRV_BLOCK THEN
                        stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                        Outputs.Error := FALSE;
                    END_IF;
                    
                    // Record bit 0
                    IF (TO_WORD(Inputs.Position) AND WORD#16#01) = WORD#16#01 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit0 := TRUE;
                    END_IF;
                    
                    // Record bit 1
                    IF (TO_WORD(Inputs.Position) AND WORD#16#02) = WORD#16#02 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit1 := TRUE;
                    END_IF;
                    
                    // Record bit 2
                    IF (TO_WORD(Inputs.Position) AND WORD#16#04) = WORD#16#04 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit2 := TRUE;
                    END_IF;
                    
                    // Record bit 3
                    IF (TO_WORD(Inputs.Position) AND WORD#16#08) = WORD#16#08 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit3 := TRUE;
                    END_IF;
                    
                    // Record bit 4
                    IF (TO_WORD(Inputs.Position) AND WORD#16#10) = WORD#16#10 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit4 := TRUE;
                    END_IF;
                    
                    // Record bit 5
                    IF (TO_WORD(Inputs.Position) AND WORD#16#20) = WORD#16#20 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit5 := TRUE;
                    END_IF;
                    
                    // Record bit 6
                    IF (TO_WORD(Inputs.Position) AND WORD#16#40) = WORD#16#40 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit6 := TRUE;
                    END_IF;
                    
                    // Check if the drive is enabled for a new motion command
                    IF stat_Ready4Motion THEN
                        
                        IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                            stat_ExecuteIntern := stat_ExecR_Trig;
                        END_IF;
                        
                        //Start Traversing Task
                        _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                        
                    END_IF;
                END_IF;
                
                //Jog mode - positive or negative
            ELSIF Inputs.ModePos = 7 THEN
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF stat_Jog1PR_trig AND NOT Inputs.Jog2 THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := TRUE;
                        stat_ActMode := Inputs.ModePos;
                    ELSIF NOT Inputs.Jog1 THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    END_IF;
                    
                    IF stat_Jog2PR_trig AND NOT Inputs.Jog1 THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := TRUE;
                        stat_ActMode := Inputs.ModePos;
                    ELSIF NOT Inputs.Jog2 THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    END_IF;
                ELSE
                    _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    
                END_IF;
                
                // jog incremental mode
            ELSIF Inputs.ModePos = 8 THEN
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    //Jog increment
                    _AxisRef.Telegram111_Out.POS_STW2.jog_inc := TRUE;
                    
                    IF stat_Jog1PMode8R_trig THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := TRUE;
                        stat_ActMode := Inputs.ModePos;
                    ELSIF NOT Inputs.Jog1 THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    END_IF;
                    
                    IF stat_Jog2PMode8R_trig THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := TRUE;
                        stat_ActMode := Inputs.ModePos;
                    ELSIF NOT Inputs.Jog2 THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    END_IF;
                    
                    IF stat_Jog1PMode8R_trig AND stat_Jog2PMode8R_trig THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                        _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    END_IF;
                    
                ELSE
                    _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    
                END_IF;
            ELSE
                // modepos < 1 or > 8
                stat_ExecuteIntern := FALSE;
                _AxisRef.Telegram111_Out.STW1.activateTraversing := FALSE;
                _AxisRef.Telegram111_Out.STW1.StartHoming := FALSE;
                _AxisRef.Telegram111_Out.POS_STW2.SetReferencePoint := FALSE;
                stat_StepHome := UINT#0;
                statStartCounter := 0;
            END_IF;

            //Maping of the Inputs.ConfigEPos to the Telegram
            _AxisRef.Telegram111_Out.STW1.noCoastStop := Inputs.ConfigEPos.%X0;         //STW1.1
            _AxisRef.Telegram111_Out.STW1.noQuickStop := Inputs.ConfigEPos.%X1;         //STW1.2
            _AxisRef.Telegram111_Out.POS_STW2.SW_Limit := Inputs.ConfigEPos.%X2;
            _AxisRef.Telegram111_Out.POS_STW2.HW_Limit := Inputs.ConfigEPos.%X3;
            _AxisRef.Telegram111_Out.POS_STW2.ProbeEdgeEval := Inputs.ConfigEPos.%X4;
            _AxisRef.Telegram111_Out.POS_STW2.SelectProbe := Inputs.ConfigEPos.%X5;
            _AxisRef.Telegram111_Out.STW1.ExternalBlockChange := Inputs.ConfigEPos.%X6;
            _AxisRef.Telegram111_Out.POS_STW2.reserved2 := Inputs.ConfigEPos.%X7;
            _AxisRef.Telegram111_Out.POS_STW1.reserved12 := Inputs.ConfigEPos.%X8;
            _AxisRef.Telegram111_Out.STW2.reserved0 := Inputs.ConfigEPos.%X9;
            _AxisRef.Telegram111_Out.STW2.reserved1 := Inputs.ConfigEPos.%X10;
            _AxisRef.Telegram111_Out.STW2.reserved2 := Inputs.ConfigEPos.%X11;
            _AxisRef.Telegram111_Out.STW2.reserved3 := Inputs.ConfigEPos.%X12;
            _AxisRef.Telegram111_Out.STW2.reserved4 := Inputs.ConfigEPos.%X13;
            _AxisRef.Telegram111_Out.STW2.reserved7 := Inputs.ConfigEPos.%X14;
            _AxisRef.Telegram111_Out.STW1.ReleaseBrake := Inputs.ReleaseBrake;           //STW1.12
            _AxisRef.Telegram111_Out.STW1.reserved14 := Inputs.ConfigEPos.%X16;
            _AxisRef.Telegram111_Out.STW1.reserved15 := Inputs.ConfigEPos.%X17;
            _AxisRef.Telegram111_Out.POS_STW2.Trackingmode := Inputs.ConfigEPos.%X18;    // different mapping to SINA_POS
            _AxisRef.Telegram111_Out.POS_STW1.reserved7 := Inputs.ConfigEPos.%X19;                // reserved
            _AxisRef.Telegram111_Out.POS_STW1.reserved11 := Inputs.ConfigEPos.%X20;               // reserved
            _AxisRef.Telegram111_Out.POS_STW1.reserved13 := Inputs.ConfigEPos.%X21;               // reserved
            _AxisRef.Telegram111_Out.POS_STW2.reserved13 := Inputs.ConfigEPos.%X22;
            _AxisRef.Telegram111_Out.POS_STW2.reserved4 := Inputs.ConfigEPos.%X23;
            _AxisRef.Telegram111_Out.POS_STW2.reserved6 := Inputs.ConfigEPos.%X24;
            _AxisRef.Telegram111_Out.POS_STW2.reserved7 := Inputs.ConfigEPos.%X25;
            _AxisRef.Telegram111_Out.POS_STW2.reserved12 := Inputs.ConfigEPos.%X26;
            _AxisRef.Telegram111_Out.POS_STW2.reserved13 := Inputs.ConfigEPos.%X27;
            _AxisRef.Telegram111_Out.STW2.reserved5 := Inputs.ConfigEPos.%X28;
            _AxisRef.Telegram111_Out.STW2.reserved6 := Inputs.ConfigEPos.%X29;
            _AxisRef.Telegram111_Out.STW2.TravelToFixStop := Inputs.TravelToFixStop;     //STW2.8
            _AxisRef.Telegram111_Out.STW2.reserved9 := Inputs.ConfigEPos.%X31;
            //Set the Status Output
            Outputs.Status := stat_Status;
            Outputs.ActMode := stat_ActMode;
        END_METHOD

        // METHOD PRIVATE UpdateStatus 
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     IF(_AxisReference <> NULL) THEN

        //         THIS.ActualPosition := _AxisReference^.Data.ActualPosition;
        //         THIS.ActualVelocity := _AxisReference^.Data.ActualVelocity;
        //         THIS.ActualTorque := _AxisReference^.Data.ActualTorque;

        //         IF NOT _AxisReference^.Data.PowerOK THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#Disabled;
        //         ELSIF _AxisReference^.Data.HomingRunning THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#Homing;
        //         ELSIF _AxisReference^.Data.DiscreteMotion THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#DiscreteMotion;
        //         ELSIF _AxisReference^.Data.ContinuousMotion THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#ContinousMotion;
        //         ELSIF _AxisReference^.Data.SynchronizedMotion THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#SynchronizedMotion;
        //         ELSIF _AxisReference^.Data.DriveStopReq THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#Stopping;
        //         ELSIF _AxisReference^.Data.StoppedDueError THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#Errorstop;
        //         ELSIF _AxisReference^.Data.Standstill THEN
        //             DriveState := AXOpen.Components.Drives.eAxoDriveState#Standstill;
        //         END_IF;
        //     ELSE
        //         DriveStatus.Error.Id := UINT#707;
        //     END_IF;
        //     Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);
        // END_METHOD  

        // ///<summary>
        // /// This method controls the power stage (On or Off).
        // ///</summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_Power 
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  As long as ‘Enable’ is TRUE, power is being enabled.
        //     END_VAR
        //     VAR_OUTPUT
        //         Status          :   BOOL;                       //  Effective state of the power stage
        //         Valid           :   BOOL;                       //  If TRUE, a valid set of outputs is available at the method
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification            
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#709,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        //     Status := FALSE;
        //     Error	:= FALSE;
        //     ErrorID :=	WORD#0;
        //     Valid := FALSE;
        // END_METHOD 

        // ///<summary>
        // /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        // /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        // /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        // ///</summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_Home
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the motion at rising edge
        //         Position        :   LREAL;                      //  Absolute position when the reference signal is detected             
        //         HommingMode     :   INT;                        //  Required homming mode           
        //         Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
        //         Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       // Reference known and set sucessfully
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //      END_VAR
        //      VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;

        //         _ErrorID : WORD;
        //         _HommingMode: DINT;
        //         Dummy : BOOL;
        //         _result : IAxoTaskState;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#710,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

            
        // END_METHOD

        // ///<summary>
        // /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        // /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        // /// same axis. 
        // ///</summary>
        // VAR INTERNAL
        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_Stop 
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the action at rising edge
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
        //         Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       // Zero velocity reached
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //      END_VAR
        //      VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#711,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        //     Done := FALSE;
        // END_METHOD

        // ///<summary>
        // /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        // /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        // ///</summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_Halt 
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the action at rising edge
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
        //         Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       // Zero velocity reached
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#712,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

            
        // END_METHOD

        // ///<summary>
        // /// This method commands a controlled motion to a specified absolute position.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_MoveAbsolute
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the motion at rising edge
        //         ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
        //         Position        :   LREAL;                      //  Commanded ‘Position’ for the motion (in technical unit [u]) (negative or positive)                             
        //         Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
        //         Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
        //         Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
        //         Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       // Commanded position finally reached
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
                        
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#713,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_MoveRelative 
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the motion at rising edge
        //         ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
        //         Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
        //         Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
        //         Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
        //         Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       // Commanded distance reached
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#714,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        // /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        // /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        // /// specified relative distance is added to the set position at the time of the execution.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_MoveAdditive
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the motion at rising edge
        //         ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
        //         Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
        //         Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
        //         Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
        //         Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       // Commanded distance reached
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
                        
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#715,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method commands a never ending controlled motion at a specified velocity.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_MoveVelocity
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the motion at rising edge
        //         ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
        //         Velocity        :   LREAL;                      //  Value of the maximum velocity [u/s]. Can be a signed value.
        //         Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
        //         Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
        //         Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
        //         Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-3 values: PositiveDirection, NegativeDirection, and CurrentDirection. Note: shortest way not applicable)
        //     END_VAR
        //     VAR_OUTPUT
        //         InVelocity      :   BOOL;                       // Commanded velocity reached
        //         Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       // Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
        //         Error           :   BOOL;                       // Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       // Error identification           
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //         Velocity_        :   LREAL;                     
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#716,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        //     Messenger.ActivateOnCondition(ULINT#737,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.NegativeDirection, eAxoMessageCategory#ProgrammingError);

        //     IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.PositiveDirection THEN
        //         Velocity_ := Velocity;
        //     ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.NegativeDirection THEN
        //         Velocity_ := -1 * Velocity;
        //     ELSE
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        // /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        // /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        // /// load, force is applicable. Positive torque is in the positive direction of velocity.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_TorqueControl
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start the motion at rising edge
        //         ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
        //         Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
        //         TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
        //         Velocity        :   LREAL;                      //  Absolute value of the maximum velocity.
        //         Acceleration    :   LREAL;                      //  Value of the maximum acceleration (acceleration is applicable with same sign of torque and velocity)
        //         Deceleration    :   LREAL;                      //  Value of the maximum deceleration (deceleration is applicable with opposite signs of torque and velocity)
        //         Jerk            :   LREAL;                      //  Value of the maximum jerk
        //         Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1 of 2 values: PositiveDirection, NegativeDirection or CurrentDirection). Specifies the direction of the torque. (Note: Torque input can be signed value).            
        //     END_VAR
        //     VAR_OUTPUT
        //         InTorque        :   BOOL;                       //  Setpoint value of torque or force equals the commandedvalue
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Active          :   BOOL;                       //  Indicates that the method has control on the axis
        //         CommandAborted  :   BOOL;                       //  ‘Command’ is aborted by another command
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification             
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //         Torque_          :   LREAL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#717,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        //     Messenger.ActivateOnCondition(ULINT#739,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.NegativeDirection, eAxoMessageCategory#ProgrammingError);

        //     IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.PositiveDirection THEN
        //         Torque_ := Torque;
        //     ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirectionInputs.NegativeDirection THEN
        //         Torque_ := -1 * Torque;
        //     ELSE
        //         RETURN;
        //     END_IF; 

                        
        // END_METHOD

        // ///<summary>
        // /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        // /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        // /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        // /// the commanded position, which is now positioned in the shifted coordinate system.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR  
        // METHOD PUBLIC OVERRIDE MC_SetPosition
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Start setting position in axis
        //         Position        :   LREAL;                       //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
        //         Relative        :   BOOL;                       //  ‘Relative’ distance if TRUE, ‘Absolute’ position if FALSE (= Default)
        //         ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       //  ‘Position’ has new value
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification             
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //         _result : AXOpen.Core.IAxoTaskState;
        //         _ErrorID    :   eAxoCmmtAsDriveErrorCode;
        //         _Valid  :   BOOL;
        //         _Error  :   BOOL;
        //         _Position   :   LREAL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#718,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        // /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and jerk of the motion.
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_SetOverride
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
        //         VelocityFactor  :   LREAL;                      //  New override factor for the velocity
        //         AccelerationFactor:   LREAL;                    //  New override factor for the acceleration/deceleration
        //         JerkFactor      :   LREAL;                      //  New override factor for the jer            
        //     END_VAR
        //     VAR_OUTPUT
        //         Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification             
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#719,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        // /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        // ///<summary>
        // VAR INTERNAL 

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_ReadParameter
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //         ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Value           :   DINT;                       //  Value of the specified parameter in the datatype, as specified by the vendor
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#720,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns the value of a vendor specific parameter with datatype REAL.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_ReadRealParameter
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //         ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Value           :   REAL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#721,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns the value of a vendor specific parameter with datatype BOOL.
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_ReadBoolParameter
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //         ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Value           :   BOOL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
        //     RETURN;

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#722,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method modifies the value of a vendor specific parameter.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_WriteParameter
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
        //         ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
        //         Value           :   DINT;                       //  New value of the specified parameter
        //         ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       //  Parameter successfully written
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#723,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method modifies the value of a vendor specific parameter of type Real.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_WriteRealParameter
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
        //         ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
        //         Value           :   REAL;                       //  New value of the specified parameter
        //         ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       //  Parameter successfully written
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#724,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method modifies the value of a vendor specific parameter of type BOOL.
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_WriteBoolParameter
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
        //         ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
        //         Value           :   BOOL;                       //  New value of the specified parameter
        //         ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       //  Parameter successfully written
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#725,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        // /// It provides the value of the referenced input (BOOL).
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_ReadDigitalInput
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the selected input signal continuously while enabled
        //         InputNumber     :   INT;                        //  Selects the input. Can be part of MC_INPUT_REF, if only one single input is referenced.                
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Value           :   BOOL;                       //  The value of the selected input signal
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#726,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        // /// It provides the value of the referenced output (BOOL).
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_ReadDigitalOutput
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
        //         OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Value           :   BOOL;                       //  The value of the selected output signal
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#727,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_WriteDigitalOutput
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Write the value of the selected output
        //         OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
        //         Value           :   BOOL;                       //  The value of the selected output signal
        //         ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       //  Writing of the output signal value is done
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //         Valid_          :   BOOL;
        //         Error_          :   BOOL;
        //         ErrorID_        :   WORD; 
        //     END_VAR

        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#728,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns the actual position.
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_ReadActualPosition 
        //      VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Position        :   LREAL;                       //  New absolute position (in axis’ unit [u])
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#729,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns the value of the actual velocity as long as ‘Enable’ is set. ‘Valid’ is TRUE when the 
        // /// dataoutput ‘Velocity’ is valid. If ‘Enable’ is Reset, the data loses its validity, and all outputs are reset,
        // /// no matter if new data is available.
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_ReadActualVelocity
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Velocity        :   LREAL;                       //  The value of the actual velocity (in axis’ unit [u/s])
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#730,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns the value of the actual torque or force as long as ‘Enable’ is set. ‘Valid’ is TRUE when the
        // /// data-output ‘Torque’ is valid. If ‘Enable’ is Reset, the data loses its validity, and ‘Valid’ is also reset, 
        // /// no matter if new data is available.        
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_ReadActualTorque
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         Torque          :   LREAL;                       //  The value of the actual torque or force (in technical units)
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#731,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns in detail the status of the state diagram of the axis
        // ///<summary>
        // VAR INTERNAL

        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_ReadStatus
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         ErrorStop       :   BOOL;                       //  See state diagram
        //         Disabled        :   BOOL;                       //  See state diagram
        //         Stopping        :   BOOL;                       //  See state diagram
        //         Homing          :   BOOL;                       //  See state diagram
        //         Standstill      :   BOOL;                       //  See state diagram
        //         DiscreteMotion  :   BOOL;                       //  See state diagram
        //         ContinuousMotion:   BOOL;                       //  See state diagram
        //         SynchronizedMotion: BOOL;                       //  See state diagram
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#732,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_ReadMotionState
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //         Source          :   AXOpen.Components.Abstractions.Drives.eAxoSource;                 //  Defines the source of the relevant data: CommandedValue;SetValue, ActualValue.
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         ConstantVelocity:   BOOL;                       //  Velocity is constant. Velocity may be 0. For the actual value a window is applicable (window is vendor specific)
        //         Accelerating    :   BOOL;                       //  Increasing the absolute value of the velocity
        //         Decelerating    :   BOOL;                       //  Decreasing the absolute value of the velocity
        //         DirectionPositive:  BOOL;                       //  Signals that the position is increasing
        //         DirectionNegative:  BOOL;                       //  Signals that the position is decreasing
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#733,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        // /// and certain status information.
        // ///<summary>
        // METHOD PUBLIC OVERRIDE MC_ReadAxisInfo
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         HomeAbsSwitch   :   BOOL;                       //  Digital home switch input is active
        //         LimitSwitchPos  :   BOOL;                       //  Positive hardware end switch is active
        //         LimitSwitchNeg  :   BOOL;                       //  Negative hardware end switch is active
        //         Simulation      :   BOOL;                       //  Axis is in simulation mode (e.g. motor is simulated)
        //         CommunicationReady: BOOL;                       //  “Network” is initialized and ready for communication
        //         ReadyForPowerOn :   BOOL;                       //  Drive is ready to be enabled (power on)
        //         PowerOn         :   BOOL;                       //  If TRUE shows that the power stage is switched ON
        //         IsHomed         :   BOOL;                       //  The absolute reference position is known for the axis (axis is homed)
        //         AxisWarning     :   BOOL;                       //  Warning(s) on the axis is present
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#734,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method presents general axis errors not relating to the methods. 
        // /// (for instance axis errors, drive errors, communication errors)
        // ///<summary>
        // VAR INTERNAL
        // END_VAR
        // METHOD PUBLIC OVERRIDE MC_ReadAxisError
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
        //     END_VAR
        //     VAR_OUTPUT
        //         Valid           :   BOOL;                       //  A valid output is available at the method
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //         AxisErrorID     :   DWORD;                      //  The value of the axis error. These values are vendor specific
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //         _category  :   AXOpen.Messaging.eAxoMessageCategory;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#735,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;

        // END_METHOD

        // ///<summary>
        // /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        // /// internal axis-related errors – it does not affect the output of the other methods.
        // ///<summary>
        // VAR INTERNAL

        // END_VAR    
        // METHOD PUBLIC OVERRIDE MC_Reset
        //     VAR_INPUT
        //         AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
        //         Execute         :   BOOL;                       //  Resets all internal axis-related error
        //     END_VAR
        //     VAR_OUTPUT
        //         Done            :   BOOL;                       //  ‘Standstill’ or ‘Disabled’ state is reached
        //         Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
        //         Error           :   BOOL;                       //  Signals that an error has occurred within the method
        //         ErrorID         :   WORD;                       //  Error identification
        //     END_VAR
        //     VAR 
        //         _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        //         Dummy : BOOL;
        //     END_VAR
            
        //     _AxisReference ?= AxisRef;

        //     Messenger.ActivateOnCondition(ULINT#736,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

        //     IF(_AxisReference = NULL) THEN
        //         RETURN;
        //     END_IF;


            
        // END_METHOD
    
    METHOD PROTECTED OVERRIDE Restore : IAxoTask
        ;
    END_METHOD

    METHOD PROTECTED OVERRIDE ManualControl
        ;
    END_METHOD
END_CLASS
END_NAMESPACE