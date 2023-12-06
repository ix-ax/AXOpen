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
            // State           :   UINT; 
        END_VAR
    
        VAR PUBLIC  //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Position#>"}
            ActualPosition          :   LREAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Velocity#>"}
            ActualVelocity          :   LREAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Torque#>"}
            ActualTorque          :   LREAL;
        END_VAR
        VAR PUBLIC //TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            //***********Stop*********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop task#>"}
            Stop_Task                            :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop done#>"}
            {#ix-attr:[ReadOnly()]}
            Stop_Done                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop busy#>"}
            {#ix-attr:[ReadOnly()]}
            Stop_Busy                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop error#>"}
            {#ix-attr:[ReadOnly()]}
            Stop_Error                           :   BOOL;                   
            //***********Home*********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming task#>"}
            Home_Task                            :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home done#>"}
            {#ix-attr:[ReadOnly()]}
            Home_Done                            :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home busy#>"}
            {#ix-attr:[ReadOnly()]}
            Home_Busy                            :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home error#>"}
            {#ix-attr:[ReadOnly()]}
            Home_Error                          :   BOOL;
            //***********MoveAbsolute*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute task#>"}
            MoveAbsolute_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute position#>"}
            MoveAbsolute_Position                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute velocity#>"}
            MoveAbsolute_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute done#>"}
            {#ix-attr:[ReadOnly()]}
            MoveAbsolute_Done                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute busy#>"}
            {#ix-attr:[ReadOnly()]}
            MoveAbsolute_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute error#>"}
            {#ix-attr:[ReadOnly()]}
            MoveAbsolute_Error                   :   BOOL;                   
            //***********MoveRelative*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative task#>"}
            MoveRelative_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative distance#>"}
            MoveRelative_Distance                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative velocity#>"}
            MoveRelative_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative done#>"}
            {#ix-attr:[ReadOnly()]}
            MoveRelative_Done                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative busy#>"}
            {#ix-attr:[ReadOnly()]}
            MoveRelative_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative error#>"}
            {#ix-attr:[ReadOnly()]}
            MoveRelative_Error                   :   BOOL;    
            //***********TravelToFixStop*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop task#>"}
            TravelToFixStop_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop position#>"}
            TravelToFixStop_Position                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop velocity#>"}
            TravelToFixStop_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop torque#>"}
            TravelToFixStop_Torque                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop done#>"}
            {#ix-attr:[ReadOnly()]}
            TravelToFixStop_Done                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop busy#>"}
            {#ix-attr:[ReadOnly()]}
            TravelToFixStop_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Travel to fix stop error#>"}
            {#ix-attr:[ReadOnly()]}
            TravelToFixStop_Error                   :   BOOL;    
            //***********SetOverride**************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override task#>"}
            SetOverride_Task                     :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override velocity factor#>"}
            SetOverride_VelFactor                :   LREAL   :=  100.0;                     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override acceleration factor#>"}
            SetOverride_AccFactor                :   LREAL   :=  100.0;                     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override deceleration factor#>"}
            SetOverride_DecFactor               :   LREAL   :=  100.0;        
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override done#>"}
            {#ix-attr:[ReadOnly()]}
            SetOverride_Done                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override busy#>"}
            {#ix-attr:[ReadOnly()]}
            SetOverride_Busy                     :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override error#>"}
            {#ix-attr:[ReadOnly()]}
            SetOverride_Error                    :   BOOL;                   
            //***********Reset********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset task#>"}
            Reset_Task                           :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset done#>"}
            {#ix-attr:[ReadOnly()]}
            Reset_Done                           :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset busy#>"}
            {#ix-attr:[ReadOnly()]}
            Reset_Busy                           :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset error#>"}
            {#ix-attr:[ReadOnly()]}
            Reset_Error                          :   BOOL;                   
            //***********Jog**********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog positive#>"}
            JogPositive_Task                          :   AXOpen.Core.AxoMomentaryTask;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog negative#>"}
            JogNegative_Task                          :   AXOpen.Core.AxoMomentaryTask;
        END_VAR


        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#PositionScaling#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            PositionScaling         :   LREAL   :=  1000;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#VelocityScaling#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite 1073741824.0/Base speed (P1.11280701.0.0)#>"}
            VelocityScaling         :   LREAL   :=  1073741824.0;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-set:AttributeName = "<#TorqueScaling#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite (not yet discovered the proper formula :-) )#>"}
            {#ix-attr:[ReadOnly()]}
            TorqueScaling         :   LREAL   :=  1000;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            DriveStatus         :   AxoDrive_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR
        
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Positioning-Experts only")]}
            {#ix-attr:[DisplayRole("can_debug_components")]}
            Positioning         :   AxoCmmtAsPtP_Positioning;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Positioning-Experts only")]}
            {#ix-attr:[DisplayRole("can_debug_components")]}
            State           :   UINT; 

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Parametrization-Experts only")]}
            {#ix-attr:[DisplayRole("can_debug_components")]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Parametrization#>"}
            Parametrization : AxoReadWritePROFIdriveParameter;
        END_VAR


        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject; 
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  WORD;   //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   ULINT;                      //  Hardware identifier of the module acces point submodule 
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
            THIS.UpdateStatus(REF(_AxisRef));
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
                refTelegram750_In   :   REF_TO  WORD;   //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   ULINT;                      //  Hardware identifier of the module acces point submodule 
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
            THIS.UpdateStatus(REF(_AxisRef));
            THIS.UpdateOutputs(AxisRef := REF(_AxisRef), refTelegram111_Out := refTelegram111_Out, refTelegram750_Out := refTelegram750_Out);
            THIS.Close();          
        END_METHOD   

        METHOD PRIVATE AreValidReferences: BOOL
            VAR_INPUT
                refTelegram111_In       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refTelegram750_In   :   REF_TO  WORD;   //  Reference to the input data of the Profidrive telegram 750 of this axis
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
                refTelegram750_In   :   REF_TO WORD;   //  Reference to the input data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   ULINT;                      //  Hardware identifier of the module acces point submodule 
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
            Positioning.Outputs.EPosZSW1 := axisref^.telegram111_In.POS_ZSW1;
            //POS_ZSW2
            AxisRef^.Telegram111_In.POS_ZSW2.%B1                               := refTelegram111_In^[4];
            AxisRef^.Telegram111_In.POS_ZSW2.%B0                               := refTelegram111_In^[5];
            Positioning.Outputs.EPosZSW2 := axisref^.telegram111_In.POS_ZSW2;
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
            // AxisRef^.Telegram750_In.M_Actual.%B1                               := refTelegram750_In^[0];
            // AxisRef^.Telegram750_In.M_Actual.%B0                               := refTelegram750_In^[1];
            AxisRef^.Telegram750_In.M_Actual                                   := TO_INT(refTelegram750_In^);
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
            //********************INITIALIZATION**************//        
            RestoreTask.Initialize(THIS);
            Stop_Task.Initialize(THIS);
            Home_Task.Initialize(THIS);
            MoveAbsolute_Task.Initialize(THIS);
            MoveRelative_Task.Initialize(THIS);
            TravelToFixStop_Task.Initialize(THIS);
            SetOverride_Task.Initialize(THIS);
            Reset_Task.Initialize(THIS);
            JogPositive_Task.Initialize(THIS);
            JogNegative_Task.Initialize(THIS);
            //*************************************************//       
            //********************RESTORE**********************//          
            IF RestoreTask.Execute() THEN
                THIS.Restore();
                RestoreTask.DoneWhen(TRUE);
            END_IF;
            //*************************************************//                 
            //********************STOP*************************//          
            IF Stop_Task.Execute() THEN
                Positioning.Inputs.Jog1 := FALSE;
                Positioning.Inputs.Jog2 := FALSE;
                Positioning.Inputs.IntermediateStop := FALSE;
                Positioning.Inputs.ExecuteMode := FALSE;
                Positioning.Inputs.TravelToFixStop := FALSE;
                Stop_Task.DoneWhen(_AxisRef.Telegram111_In.ZSW1.driveStopped);
                Stop_Task.ThrowWhen(_AxisRef.Telegram111_In.ZSW1.faultPresent);
            END_IF;
            Stop_Done  := Stop_Task.IsDone();
            Stop_Busy  := Stop_Task.IsBusy();
            Stop_Error := Stop_Task.HasError();
            //*************************************************//         
            //********************HOME*************************//          
            Home_Task.SetIsDisabled(Stop_Busy OR MoveAbsolute_Busy OR MoveRelative_Busy OR TravelToFixStop_Busy);
            IF Home_Task.Execute() THEN
                IF State = UINT#0 THEN
                    Positioning.Inputs.EnableAxis := TRUE;
                    Positioning.Inputs.TravelToFixStop := FALSE;
                    IF Positioning.Outputs.AxisEnabled AND NOT Positioning.Outputs.ClampTorqueReached THEN
                        State := UINT#10;
                    END_IF;
                END_IF;
                IF State = UINT#10 THEN
                    Positioning.Inputs.ModePos := 4;
                    Positioning.Inputs.IntermediateStop := TRUE;
                    Positioning.Inputs.ExecuteMode := TRUE;
                    IF NOT Positioning.Outputs.AxisSpFixed THEN    
                        State := UINT#20;
                    END_IF;
                END_IF;
                IF State = UINT#20 THEN
                    Home_Task.DoneWhen(Positioning.Outputs.AxisRef);
                END_IF;
                Home_Task.ThrowWhen(Positioning.Outputs.AxisError);
            END_IF;
            IF Home_Task.DoneReached() OR Home_Task.RestoreTriggered() THEN
                Positioning.Inputs.ExecuteMode := FALSE;
                State := UINT#0;
            END_IF;
            Home_Done  := Home_Task.IsDone();
            Home_Busy  := Home_Task.IsBusy();
            Home_Error := Home_Task.HasError();
            //*************************************************//         
            //********************MOVE ABSOLUTE****************//          
            MoveAbsolute_Task.SetIsDisabled(Stop_Busy OR Home_Busy OR MoveRelative_Busy OR TravelToFixStop_Busy OR NOT Positioning.Outputs.AxisRef);
            IF MoveAbsolute_Task.Execute() THEN
                IF State = UINT#0 THEN
                    Positioning.Inputs.EnableAxis := TRUE;
                    Positioning.Inputs.TravelToFixStop := FALSE;
                    IF Positioning.Outputs.AxisEnabled AND NOT Positioning.Outputs.ClampTorqueReached THEN
                        State := UINT#10;
                    END_IF;
                END_IF;
                IF State = UINT#10 THEN
                    Positioning.Inputs.ModePos := 2;
                    Positioning.Inputs.Position := TO_DINT(MoveAbsolute_Position * PositionScaling);
                    Positioning.Inputs.Velocity := TO_DINT(MoveAbsolute_Velocity);
                    Positioning.Inputs.IntermediateStop := TRUE;
                    Positioning.Inputs.ExecuteMode := TRUE;
                    IF Positioning.Outputs.AxisAckSetpoint THEN    
                        State := UINT#20;
                    END_IF;
                END_IF;
                IF State = UINT#20 THEN
                    MoveAbsolute_Task.DoneWhen(Positioning.Outputs.AxisPosOk);
                END_IF;
                MoveAbsolute_Task.ThrowWhen(Positioning.Outputs.AxisError);
            END_IF;
            IF MoveAbsolute_Task.DoneReached() OR MoveAbsolute_Task.RestoreTriggered() THEN
                Positioning.Inputs.ExecuteMode := FALSE;
                State := UINT#0;
            END_IF;
            MoveAbsolute_Done  := MoveAbsolute_Task.IsDone();
            MoveAbsolute_Busy  := MoveAbsolute_Task.IsBusy();
            MoveAbsolute_Error := MoveAbsolute_Task.HasError();
            //*************************************************//         
            //********************MOVE RELATIVE****************//          
            MoveRelative_Task.SetIsDisabled(Stop_Busy OR Home_Busy OR MoveAbsolute_Busy OR TravelToFixStop_Busy);
            IF MoveRelative_Task.Execute() THEN
                IF State = UINT#0 THEN
                    Positioning.Inputs.EnableAxis := TRUE;
                    Positioning.Inputs.TravelToFixStop := FALSE;
                    IF Positioning.Outputs.AxisEnabled AND NOT Positioning.Outputs.ClampTorqueReached THEN
                        State := UINT#10;
                    END_IF;
                END_IF;
                IF State = UINT#10 THEN
                    Positioning.Inputs.ModePos := 1;
                    Positioning.Inputs.Position := TO_DINT(MoveRelative_Distance * PositionScaling);
                    Positioning.Inputs.Velocity := TO_DINT(MoveRelative_Velocity);
                    Positioning.Inputs.IntermediateStop := TRUE;
                    Positioning.Inputs.ExecuteMode := TRUE;
                    IF Positioning.Outputs.AxisAckSetpoint THEN    
                        State := UINT#20;
                    END_IF;
                END_IF;
                IF State = UINT#20 THEN
                    MoveRelative_Task.DoneWhen(Positioning.Outputs.AxisPosOk);
                END_IF;
                MoveRelative_Task.ThrowWhen(Positioning.Outputs.AxisError);
            END_IF;
            IF MoveRelative_Task.DoneReached() OR MoveRelative_Task.RestoreTriggered() THEN
                Positioning.Inputs.ExecuteMode := FALSE;
                State := UINT#0;
            END_IF;
            MoveRelative_Done  := MoveRelative_Task.IsDone();
            MoveRelative_Busy  := MoveRelative_Task.IsBusy();
            MoveRelative_Error := MoveRelative_Task.HasError();
            //*************************************************//         
            //********************TravelToFixStop**************//          
            TravelToFixStop_Task.SetIsDisabled(Stop_Busy OR Home_Busy OR MoveAbsolute_Busy OR MoveRelative_Busy OR NOT Positioning.Outputs.AxisRef);
            IF TravelToFixStop_Task.Execute() THEN
                //Set torque
                IF State = UINT#0 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12168;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(TravelToFixStop_Torque);
                    Parametrization.Inputs.ValueWriteLINT := 0;
                    Parametrization.Inputs.ValueWriteBOOL := FALSE;
                    State := UINT#10;
                //Set torque done
                ELSIF State = UINT#10 THEN
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        Parametrization.Inputs.Enable := FALSE;
                        Parametrization.Inputs.ReadWrite := FALSE;
                        State := UINT#20;
                    END_IF;
                    TravelToFixStop_Task.ThrowWhen(Parametrization.Outputs.Error);
                //Enable axis
                ELSIF State = UINT#20 THEN
                    Positioning.Inputs.EnableAxis := TRUE;
                    IF Positioning.Outputs.AxisEnabled THEN
                        State := UINT#30;
                    END_IF;
                //Start movement
                ELSIF State = UINT#30 THEN
                    Positioning.Inputs.ModePos := 2;
                    Positioning.Inputs.Position := TO_DINT(TravelToFixStop_Position * PositionScaling);
                    Positioning.Inputs.Velocity := TO_DINT(TravelToFixStop_Velocity );
                    Positioning.Inputs.IntermediateStop := TRUE;
                    Positioning.Inputs.ExecuteMode := TRUE;
                    Positioning.Inputs.TravelToFixStop := TRUE;
                    IF Positioning.Outputs.AxisAckSetpoint THEN    
                        State := UINT#40;
                    END_IF;
                //Waiting for torque reached
                ELSIF State = UINT#40 THEN
                    TravelToFixStop_Task.DoneWhen(Positioning.Outputs.ClampTorqueReached);
                END_IF;
                TravelToFixStop_Task.ThrowWhen(Positioning.Outputs.AxisError OR Positioning.Outputs.AxisPosOk AND  TravelToFixStop_Task.Duration >= T#1s);
            END_IF;
            IF TravelToFixStop_Task.DoneReached() OR TravelToFixStop_Task.RestoreTriggered() THEN
                Positioning.Inputs.ExecuteMode := FALSE;
                State := UINT#0;
            END_IF;
            TravelToFixStop_Done  := TravelToFixStop_Task.IsDone();
            TravelToFixStop_Busy  := TravelToFixStop_Task.IsBusy();
            TravelToFixStop_Error := TravelToFixStop_Task.HasError();
            //*************************************************//         
            //********************SET OVERRIDE*****************//          
            IF SetOverride_Task.Execute() THEN
                Positioning.Inputs.OverV := TO_INT(SetOverride_VelFactor);
                Positioning.Inputs.OverAcc := TO_INT(SetOverride_AccFactor);
                Positioning.Inputs.OverDec := TO_INT(SetOverride_DecFactor);
                SetOverride_Task.DoneWhen(NOT Positioning.Outputs.AxisError);
                SetOverride_Task.ThrowWhen(Positioning.Outputs.AxisError);
            END_IF;
            SetOverride_Done  := SetOverride_Task.IsDone();
            SetOverride_Busy  := SetOverride_Task.IsBusy();
            SetOverride_Error := SetOverride_Task.HasError();
            //*************************************************//            
            //********************RESET************************//          
            IF Reset_Task.Execute() THEN
                Positioning.Inputs.EnableAxis := FALSE;
                Positioning.Inputs.AckError :=TRUE;
                Reset_Task.DoneWhen(NOT Positioning.Outputs.AxisError);
                Reset_Task.ThrowWhen(Positioning.Outputs.AxisError AND Reset_Task.Duration > T#1s);
                IF Reset_Task.IsDone() THEN
                    Positioning.Inputs.AckError := FALSE;
                END_IF;
            END_IF;
            Reset_Done  := Reset_Task.IsDone();
            Reset_Busy  := Reset_Task.IsBusy();
            Reset_Error := Reset_Task.HasError();
            //*************************************************//          
            //********************PARAMETRIZAION***************//          
            Parametrization.Run(THIS);
            Parametrization.Inputs.HardwareId := TO_WORD(_AxisRef.Data.MAP_HW_ID);
            //*************************************************//          

            //********************POSITIONING******************//          
            // Check the Mode of Operation
            IF Positioning.Inputs.ModePos > MAXMODE THEN
                Positioning.Outputs.Error := TRUE;
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_INVALID_MODE;
                stat_ExecuteIntern := FALSE;
            ELSIF Positioning.Inputs.ModePos < 1 THEN
                Positioning.Outputs.Error := TRUE;
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_INVALID_MODE;
                stat_ExecuteIntern := FALSE;
            ELSE
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_INVALID_MODE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the Velocity Override 
            IF (Positioning.Inputs.OverV < 0) OR (Positioning.Inputs.OverV > 199) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // Write Velocity Override into Send Buffer
                _AxisRef.Telegram111_Out.Override_ := TO_WORD(TO_INT(16384.0 * (TO_REAL(Positioning.Inputs.OverV) / 100.0)));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the Acceleration Override  (0% - 100%, 100% => WORD#16#4000)
            IF (Positioning.Inputs.OverAcc < 0) OR (Positioning.Inputs.OverAcc > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // Write Acceleration Override into Send Buffer
                _AxisRef.Telegram111_Out.MDI_ACC := TO_UINT(16384.0 * (TO_REAL(Positioning.Inputs.OverAcc) / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the Deceleration Override  (0% - 100%, 100% => WORD#16#4000)
            IF (Positioning.Inputs.OverDec < 0) OR (Positioning.Inputs.OverDec > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram111_Out.MDI_DEC := TO_UINT(16384.0 * (TO_REAL(Positioning.Inputs.OverDec) / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_OVERRIDE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the AdditionalTorque  (0% - 100%, 100% => WORD#16#4000)
            IF (Positioning.Inputs.AdditionalTorque < 0) OR (Positioning.Inputs.AdditionalTorque > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram750_Out.M_ADD1 := TO_INT(16384.0 * (Positioning.Inputs.AdditionalTorque / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the PositiveTorqueLimit  (0% - 100%, 100% => WORD#16#4000)
            IF (Positioning.Inputs.PositiveTorqueLimit < 0) OR (Positioning.Inputs.PositiveTorqueLimit > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_POS;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram750_Out.M_LIMIT_POS := TO_INT(16384.0 * (Positioning.Inputs.PositiveTorqueLimit / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_POS THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;
            
            //Check the NegativeTorqueLimit  (0% - 100%, 100% => WORD#16#4000)
            IF (Positioning.Inputs.NegativeTorqueLimit < 0) OR (Positioning.Inputs.NegativeTorqueLimit > 100) THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_NEG;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // Write Deceleration Override into Send Buffer
                _AxisRef.Telegram750_Out.M_LIMIT_NEG := TO_INT(-16384.0 * (Positioning.Inputs.NegativeTorqueLimit / 100.0));
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_ADD_TORQUE_LIMIT_NEG THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;

            // Mapping of the Outputs
            Positioning.Outputs.AxisEnabled := _AxisRef.Telegram111_In.ZSW1.operationEnabled;
            Positioning.Outputs.AxisError := _AxisRef.Telegram111_In.ZSW1.faultPresent;
            Positioning.Outputs.AxisWarn := _AxisRef.Telegram111_In.ZSW1.warningActive;
            Positioning.Outputs.AxisPosOk := _AxisRef.Telegram111_In.ZSW1.targetPosReached;
            Positioning.Outputs.AxisRef := _AxisRef.Telegram111_In.ZSW1.homePosSet;
            Positioning.Outputs.AxisAckSetpoint := _AxisRef.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated;
            Positioning.Outputs.ClampTorqueReached := _AxisRef.Telegram111_In.POS_ZSW2.%X13;
            Positioning.Outputs.AxisSpFixed := _AxisRef.Telegram111_In.ZSW1.driveStopped;
            Positioning.Outputs.ActVelocity := TO_REAL(_AxisRef.Telegram111_In.NIST_B);
            Positioning.Outputs.ActTorque := _AxisRef.Telegram750_In.M_Actual;

            //scaling the ActVelocity output
            IF Positioning.Inputs.BaseSpeedValue <> 0 THEN
                Positioning.Outputs.ActVelocity := Positioning.Outputs.ActVelocity * ((Positioning.Inputs.BaseSpeedValue / REAL#1073741824.0));
            END_IF;

            Positioning.Outputs.ActPosition := _AxisRef.Telegram111_In.XIST_A;
            Positioning.Outputs.ActWarn := TO_WORD(_AxisRef.Telegram111_In.Warn_Code);
            Positioning.Outputs.ActFault := TO_WORD(_AxisRef.Telegram111_In.Fault_Code);
            Positioning.Outputs.Lockout := _AxisRef.Telegram111_In.ZSW1.switchingOnInhibitedActive;

            //Check the drive error and Lockout status
            IF Positioning.Outputs.AxisError THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_DRIVE_ERROR;
                Positioning.Outputs.Error := TRUE;
            ELSIF Positioning.Outputs.Lockout THEN
                stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_SWITCH_ON_INHIBITED;
                Positioning.Outputs.Error := TRUE;
            ELSE
                // error is gone -> set status in operational
                IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_DRIVE_ERROR OR stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_SWITCH_ON_INHIBITED THEN
                    stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                    Positioning.Outputs.Error := FALSE;
                END_IF;
            END_IF;

            //Enable the Axis
            _AxisRef.Telegram111_Out.STW1.on_ := Positioning.Inputs.EnableAxis;                        //STW1.0

            //fix values for STW1 data
            _AxisRef.Telegram111_Out.STW1.cancelTraversing := Positioning.Inputs.CancelTraversing;     //STW1.4
            _AxisRef.Telegram111_Out.STW1.intermediateStop := Positioning.Inputs.IntermediateStop;     //STW1.5
            _AxisRef.Telegram111_Out.STW1.acknowledgeFault := Positioning.Inputs.AckError;             //STW1.7
            _AxisRef.Telegram111_Out.STW1.controlByPlc := TRUE;                            //STW1.10
            _AxisRef.Telegram111_Out.STW1.enableOperation := TRUE;                         //STW1.3

            // copy the position set value into the send struct
            IF Positioning.Inputs.ModePos <> 4 OR Positioning.Inputs.ModePos <> 5 OR Positioning.Inputs.ModePos <> 6 OR Positioning.Inputs.ModePos <> 7 OR Positioning.Inputs.ModePos <> 8 THEN
                _AxisRef.Telegram111_Out.MDI_TARPOS := Positioning.Inputs.Position;
            ELSE
                _AxisRef.Telegram111_Out.MDI_TARPOS := 0;
            END_IF;

            //copy the velocity set value into the send struct
            _AxisRef.Telegram111_Out.MDI_VELOCITY := Positioning.Inputs.Velocity;

            //Jog bits
            // Mode 7
            //Generate the Jog1 Edge
            stat_Jog1PR_trig := Positioning.Inputs.Jog1 AND NOT stat_Jog1PAux;
            //Reset the Auxiliary flag 
            stat_Jog1PAux := Positioning.Inputs.Jog1;

            //Generate the Jog2 Edge
            stat_Jog2PR_trig := Positioning.Inputs.Jog2 AND NOT stat_Jog2PAux;
            //Reset the Auxiliary flag 
            stat_Jog2PAux := Positioning.Inputs.Jog2;

            //Mode 8
            //Generate the Jog1 Edge
            stat_Jog1PMode8R_trig := Positioning.Inputs.Jog1 AND NOT stat_Jog1PMode8Aux;
            //Reset the Auxiliary flag 
            stat_Jog1PMode8Aux := Positioning.Inputs.Jog1;

            //Generate the Jog2 Edge
            stat_Jog2PMode8R_trig := Positioning.Inputs.Jog2 AND NOT stat_Jog2PMode8Aux;
            //Reset the Auxiliary flag 
            stat_Jog2PMode8Aux := Positioning.Inputs.Jog2;

            IF Positioning.Inputs.ModePos <> 4 THEN
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
            stat_ExecR_Trig := Positioning.Inputs.ExecuteMode AND NOT stat_ExecAux;
            //Reset the Auxiliary flag 
            stat_ExecAux := Positioning.Inputs.ExecuteMode;

            // Set the Execute command according to the ModePos
            IF NOT Positioning.Inputs.ExecuteMode THEN
                stat_ExecuteIntern := FALSE;
                stat_StepHome := UINT#0;
            ELSIF Positioning.Inputs.ExecuteMode AND stat_Ready4Motion AND NOT (Positioning.Inputs.ModePos = 4 OR Positioning.Inputs.ModePos = 5 OR Positioning.Inputs.ModePos = 7 OR Positioning.Inputs.ModePos = 8) THEN
                stat_ExecuteIntern := TRUE;
                stat_ActMode := Positioning.Inputs.ModePos;
                stat_StepHome := UINT#0;
            ELSIF stat_ExecR_Trig AND (Positioning.Inputs.ModePos = 4 OR Positioning.Inputs.ModePos = 5) THEN
                stat_ActMode := Positioning.Inputs.ModePos;
                stat_StepHome := UINT#0;
            ELSIF Positioning.Inputs.ExecuteMode AND (stat_ActMode = 7 OR stat_ActMode = 8) THEN
                stat_ExecuteIntern := FALSE;
                stat_StepHome := UINT#0;
            ELSIF Positioning.Inputs.ExecuteMode AND Positioning.Inputs.ModePos = 4 THEN
                
                CASE stat_StepHome OF
                        
                    UINT#0: // homing is active
                        IF NOT Positioning.Outputs.AxisRef THEN
                            stat_StepHome := UINT#10;
                        ELSIF Positioning.Outputs.AxisError OR (NOT Positioning.Outputs.AxisSpFixed AND Positioning.Inputs.ModePos = 4) THEN
                            stat_ExecuteIntern := FALSE;
                        END_IF;
                        
                        UINT#10: // wait for homing done
                        IF Positioning.Outputs.AxisRef OR Positioning.Outputs.AxisError OR (NOT stat_Ready4Motion AND Positioning.Inputs.ModePos = 4) OR Positioning.Inputs.ModePos <> stat_ActMode OR NOT Positioning.Inputs.ExecuteMode THEN
                            stat_ExecuteIntern := FALSE;
                            stat_StepHome := UINT#0;
                        END_IF;
                END_CASE;
            ELSIF stat_ExecuteIntern AND Positioning.Inputs.ModePos <> stat_ActMode THEN
                stat_ExecuteIntern := FALSE;
                stat_StepHome := UINT#0;
            END_IF;

            //Reset the jog bits if the ModePos has changed
            IF (_AxisRef.Telegram111_Out.STW1.jog1 OR _AxisRef.Telegram111_Out.STW1.jog2) AND Positioning.Inputs.ModePos <> stat_ActMode THEN
                //Set the jog bits to zero
                _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
            END_IF;

            // Positionig mode with relative movement (MDI)
            IF Positioning.Inputs.ModePos = 1 THEN
                
                // Set the MDI bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Positioning.Inputs.Positive;
                
                // positioning.inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Positioning.Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    //Start Traversing Task
                    _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                    
                END_IF;
                
                // Positionig mode with absolute movement (MDI)
            ELSIF Positioning.Inputs.ModePos = 2 THEN
                
                // Set the MDI bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                
                //set the Absolute bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_MOD := TRUE;
                
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Positioning.Inputs.Positive;
                
                // positioning.inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Positioning.Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    //Start Traversing Task
                    _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                    
                END_IF;
                
                // Positioning with setup mode for endless motion
            ELSIF Positioning.Inputs.ModePos = 3 THEN
                // Set the MDI bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                
                //set the Absolute bit
                _AxisRef.Telegram111_Out.POS_STW1.MDI_MOD := TRUE;
                
                //setup mode
                _AxisRef.Telegram111_Out.POS_STW1.SetupMode := TRUE;
                
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Positioning.Inputs.Positive;
                
                // positioning.inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Positioning.Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF NOT _AxisRef.Telegram111_Out.STW1.activateTraversing THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    //Start Traversing Task
                    _AxisRef.Telegram111_Out.STW1.activateTraversing := stat_ExecuteIntern;
                    
                END_IF;
                
                //Homing mode done by the drive due to the parametrized homing method
            ELSIF Positioning.Inputs.ModePos = 4 THEN
                // positive direction
                _AxisRef.Telegram111_Out.POS_STW1.PosModulo := Positioning.Inputs.Positive;
                
                // positioning.inputs.negative direction
                _AxisRef.Telegram111_Out.POS_STW1.NegModulo := Positioning.Inputs.Negative;
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    //Start homing
                    IF NOT _AxisRef.Telegram111_Out.STW1.StartHoming THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    
                    _AxisRef.Telegram111_Out.STW1.StartHoming := stat_ExecuteIntern;
                END_IF;
                
                //set the reference point (actual position)
            ELSIF Positioning.Inputs.ModePos = 5 THEN
                
                // check if there is no error in the drive - this function works also when drive is not enabled
                IF NOT Positioning.Outputs.AxisError THEN
                    
                    //Start homing
                    IF NOT _AxisRef.Telegram111_Out.POS_STW2.SetReferencePoint THEN
                        stat_ExecuteIntern := stat_ExecR_Trig;
                    END_IF;
                    //Set the axis zero point
                    _AxisRef.Telegram111_Out.POS_STW2.SetReferencePoint := stat_ExecuteIntern;
                    
                END_IF;
                
                //Record mode - parametrized records in the drive can be used
            ELSIF Positioning.Inputs.ModePos = 6 THEN
                
                //set the position number into the record bits 
                IF (TO_INT(Positioning.Inputs.Position) < 0) OR (TO_INT(Positioning.Inputs.Position) > 127) THEN
                    // Error, wrong record number
                    stat_Status := eAxoCmmtAsPtPErrorCode#ERROR_INVALID_TRV_BLOCK;
                    Positioning.Outputs.Error := TRUE;
                ELSE
                    // error is gone -> set status in operational
                    IF stat_Status = eAxoCmmtAsPtPErrorCode#ERROR_INVALID_TRV_BLOCK THEN
                        stat_Status := eAxoCmmtAsPtPErrorCode#STATUS_IN_OPERATION;
                        Positioning.Outputs.Error := FALSE;
                    END_IF;
                    
                    // Record bit 0
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#01) = WORD#16#01 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit0 := TRUE;
                    END_IF;
                    
                    // Record bit 1
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#02) = WORD#16#02 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit1 := TRUE;
                    END_IF;
                    
                    // Record bit 2
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#04) = WORD#16#04 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit2 := TRUE;
                    END_IF;
                    
                    // Record bit 3
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#08) = WORD#16#08 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit3 := TRUE;
                    END_IF;
                    
                    // Record bit 4
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#10) = WORD#16#10 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit4 := TRUE;
                    END_IF;
                    
                    // Record bit 5
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#20) = WORD#16#20 THEN
                        _AxisRef.Telegram111_Out.POS_STW1.travBlockBit5 := TRUE;
                    END_IF;
                    
                    // Record bit 6
                    IF (TO_WORD(Positioning.Inputs.Position) AND WORD#16#40) = WORD#16#40 THEN
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
            ELSIF Positioning.Inputs.ModePos = 7 THEN
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    IF stat_Jog1PR_trig AND NOT Positioning.Inputs.Jog2 THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := TRUE;
                        stat_ActMode := Positioning.Inputs.ModePos;
                    ELSIF NOT Positioning.Inputs.Jog1 THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    END_IF;
                    
                    IF stat_Jog2PR_trig AND NOT Positioning.Inputs.Jog1 THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := TRUE;
                        stat_ActMode := Positioning.Inputs.ModePos;
                    ELSIF NOT Positioning.Inputs.Jog2 THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    END_IF;
                ELSE
                    _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    _AxisRef.Telegram111_Out.STW1.jog2 := FALSE;
                    
                END_IF;
                
                // jog incremental mode
            ELSIF Positioning.Inputs.ModePos = 8 THEN
                
                // Check if the drive is enabled for a new motion command
                IF stat_Ready4Motion THEN
                    
                    //Jog increment
                    _AxisRef.Telegram111_Out.POS_STW2.jog_inc := TRUE;
                    
                    IF stat_Jog1PMode8R_trig THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := TRUE;
                        stat_ActMode := Positioning.Inputs.ModePos;
                    ELSIF NOT Positioning.Inputs.Jog1 THEN
                        _AxisRef.Telegram111_Out.STW1.jog1 := FALSE;
                    END_IF;
                    
                    IF stat_Jog2PMode8R_trig THEN
                        _AxisRef.Telegram111_Out.STW1.jog2 := TRUE;
                        stat_ActMode := Positioning.Inputs.ModePos;
                    ELSIF NOT Positioning.Inputs.Jog2 THEN
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

            //Maping of the Positioning.Inputs.ConfigEPos to the Telegram
            _AxisRef.Telegram111_Out.STW1.noCoastStop := Positioning.Inputs.ConfigEPos.%X0;         //STW1.1
            _AxisRef.Telegram111_Out.STW1.noQuickStop := Positioning.Inputs.ConfigEPos.%X1;         //STW1.2
            _AxisRef.Telegram111_Out.POS_STW2.SW_Limit := Positioning.Inputs.ConfigEPos.%X2;
            _AxisRef.Telegram111_Out.POS_STW2.HW_Limit := Positioning.Inputs.ConfigEPos.%X3;
            _AxisRef.Telegram111_Out.POS_STW2.ProbeEdgeEval := Positioning.Inputs.ConfigEPos.%X4;
            _AxisRef.Telegram111_Out.POS_STW2.SelectProbe := Positioning.Inputs.ConfigEPos.%X5;
            _AxisRef.Telegram111_Out.STW1.ExternalBlockChange := Positioning.Inputs.ConfigEPos.%X6;
            _AxisRef.Telegram111_Out.POS_STW2.reserved2 := Positioning.Inputs.ConfigEPos.%X7;
            _AxisRef.Telegram111_Out.POS_STW1.reserved12 := Positioning.Inputs.ConfigEPos.%X8;
            _AxisRef.Telegram111_Out.STW2.reserved0 := Positioning.Inputs.ConfigEPos.%X9;
            _AxisRef.Telegram111_Out.STW2.reserved1 := Positioning.Inputs.ConfigEPos.%X10;
            _AxisRef.Telegram111_Out.STW2.reserved2 := Positioning.Inputs.ConfigEPos.%X11;
            _AxisRef.Telegram111_Out.STW2.reserved3 := Positioning.Inputs.ConfigEPos.%X12;
            _AxisRef.Telegram111_Out.STW2.reserved4 := Positioning.Inputs.ConfigEPos.%X13;
            _AxisRef.Telegram111_Out.STW2.reserved7 := Positioning.Inputs.ConfigEPos.%X14;
            _AxisRef.Telegram111_Out.STW1.ReleaseBrake := Positioning.Inputs.ReleaseBrake;           //STW1.12
            _AxisRef.Telegram111_Out.STW1.reserved14 := Positioning.Inputs.ConfigEPos.%X16;
            _AxisRef.Telegram111_Out.STW1.reserved15 := Positioning.Inputs.ConfigEPos.%X17;
            _AxisRef.Telegram111_Out.POS_STW2.Trackingmode := Positioning.Inputs.ConfigEPos.%X18;    // different mapping to SINA_POS
            _AxisRef.Telegram111_Out.POS_STW1.reserved7 := Positioning.Inputs.ConfigEPos.%X19;                // reserved
            _AxisRef.Telegram111_Out.POS_STW1.reserved11 := Positioning.Inputs.ConfigEPos.%X20;               // reserved
            _AxisRef.Telegram111_Out.POS_STW1.reserved13 := Positioning.Inputs.ConfigEPos.%X21;               // reserved
            _AxisRef.Telegram111_Out.POS_STW2.reserved13 := Positioning.Inputs.ConfigEPos.%X22;
            _AxisRef.Telegram111_Out.POS_STW2.reserved4 := Positioning.Inputs.ConfigEPos.%X23;
            _AxisRef.Telegram111_Out.POS_STW2.reserved6 := Positioning.Inputs.ConfigEPos.%X24;
            _AxisRef.Telegram111_Out.POS_STW2.reserved7 := Positioning.Inputs.ConfigEPos.%X25;
            _AxisRef.Telegram111_Out.POS_STW2.reserved12 := Positioning.Inputs.ConfigEPos.%X26;
            _AxisRef.Telegram111_Out.POS_STW2.reserved13 := Positioning.Inputs.ConfigEPos.%X27;
            _AxisRef.Telegram111_Out.STW2.reserved5 := Positioning.Inputs.ConfigEPos.%X28;
            _AxisRef.Telegram111_Out.STW2.reserved6 := Positioning.Inputs.ConfigEPos.%X29;
            _AxisRef.Telegram111_Out.STW2.TravelToFixStop := Positioning.Inputs.TravelToFixStop;     //STW2.8
            _AxisRef.Telegram111_Out.STW2.reserved9 := Positioning.Inputs.ConfigEPos.%X31;
            //Set the Status Output
            Positioning.Outputs.Status := stat_Status;
            Positioning.Outputs.ActMode := stat_ActMode;
            //*************************************************//          
        END_METHOD

        METHOD PRIVATE UpdateStatus 
            VAR_INPUT
                AxisRef :   REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsPtPAxisReference;
            END_VAR

            IF(AxisRef <> NULL) THEN
                THIS.ActualPosition := TO_LREAL(AxisRef^.Telegram111_In.XIST_A) / PositionScaling;
                THIS.ActualVelocity := TO_LREAL(AxisRef^.Telegram111_In.NIST_B) / VelocityScaling;
                THIS.ActualTorque := TO_LREAL(AxisRef^.Telegram750_In.M_Actual) / TorqueScaling;
            ELSE
                DriveStatus.Error.Id := UINT#707;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#707,AxisRef = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD  

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. 
        ///</summary>
        METHOD PUBLIC Home   : IAxoTaskState
            Home := Home_Task.Invoke();
        END_METHOD
    
        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on this axis. 
        ///</summary>       
        METHOD PUBLIC Stop   : IAxoTaskState
            Stop := Stop_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
        METHOD PUBLIC MoveAbsolute : IAxoTaskState
            VAR_INPUT
                Position        :   LREAL;                                                
                Velocity        :   LREAL;                      
            END_VAR
            MoveAbsolute_Position           := Position;
            MoveAbsolute_Velocity           := Velocity;

            MoveAbsolute := MoveAbsolute_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        METHOD PUBLIC MoveRelative : IAxoTaskState
            VAR_INPUT
                Distance        :   LREAL;                                        
                Velocity        :   LREAL;                      
            END_VAR
            MoveRelative_Distance           :=  Distance;
            MoveRelative_Velocity           :=  Velocity;

            MoveRelative :=  MoveRelative_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a maximal absolute position with specified torque defined.
        /// Returns TRUE if reaches torque specified before maximal position reached, otherwise FALSE.
        ///<summary>
        METHOD PUBLIC TravelToFixStop : IAxoTaskState
            VAR_INPUT
                Position        :   LREAL;                      
                Velocity        :   LREAL;                      
                Torque          :   LREAL;                      
            END_VAR

            TravelToFixStop_Position          :=  Position;
            TravelToFixStop_Velocity          :=  Velocity;
            TravelToFixStop_Torque            :=  Torque;

            TravelToFixStop    := TravelToFixStop_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and deceleration of the motion.
        ///<summary>
        METHOD PUBLIC SetOverride   : IAxoTaskState
            VAR_INPUT
                VelFactor       :   LREAL;                      //  Override factor for the velocity
                AccFactor       :   LREAL;                      //  Override factor for the acceleration
                DecFactor      :   LREAL;                       //  Override factor for the deceleration            
            END_VAR

            SetOverride_VelFactor   :=  VelFactor;
            SetOverride_AccFactor   :=  AccFactor;
            SetOverride_DecFactor  :=  DecFactor;

            SetOverride  := SetOverride_Task.Invoke();
        END_METHOD



        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
        METHOD PUBLIC Reset : IAxoTaskState
            Reset    := Reset_Task.Invoke();
        END_METHOD

        METHOD PROTECTED OVERRIDE Restore : IAxoTask
            Stop_Task.Restore();
            Home_Task.Restore();
            MoveAbsolute_Task.Restore();
            MoveRelative_Task.Restore();
            TravelToFixStop_Task.Restore();
            SetOverride_Task.Restore();
            Reset_Task.Restore();
            State := UINT#0;
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            JogPositive_Task.Run();
            JogNegative_Task.Run();
            //********************JOG POSITIVE*****************//          
            IF JogPositive_Task.IsSwitchedOn() THEN
                Positioning.Inputs.EnableAxis := TRUE;
                Positioning.Inputs.ModePos := 7;
                Positioning.Inputs.jog1 := TRUE;
                Positioning.Inputs.jog2 := FALSE;
            ELSE
                Positioning.Inputs.jog1 := FALSE;
            END_IF;
            //*************************************************//   
            //********************JOG NEGATIVE*****************//          
            IF JogNegative_Task.IsSwitchedOn() THEN
                Positioning.Inputs.EnableAxis := TRUE;
                Positioning.Inputs.ModePos := 7;
                Positioning.Inputs.jog2 := TRUE;
                Positioning.Inputs.jog1 := FALSE;
            ELSE
                Positioning.Inputs.jog2 := FALSE;
            END_IF;
            //*************************************************//      
        END_METHOD
    END_CLASS
END_NAMESPACE