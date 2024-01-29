USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Components.Drives;
USING System.Math;
USING System.BitAccess;

NAMESPACE AXOpen.Components.Festo.Drives
    
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoCmmtAs EXTENDS AXOpen.Components.Drives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive

        VAR PUBLIC //Debug
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentHeader()]}
            State : UINT;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentHeader()]}
            Debug : LINT;
        END_VAR

        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required position#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantRequiredPosition         :   LREAL   :=  1000;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual position#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantActualPosition         :   LREAL   :=  0.001;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required velocity#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantRequiredVelocity         :   LREAL   :=  1;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual velocity#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantActualVelocity         :   LREAL   :=  0.000000000931322574615478515625;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required torque#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantRequiredTorque         :   LREAL   :=  1;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual torque#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantActualTorque         :   LREAL   :=  0.00006103515625;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required acceleration#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantRequiredAcceleration        :   LREAL   :=  0.00006103515625;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required deceleration#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the Festo Automation Suite#>"}
            ScalingConstantRequiredDeceleration        :   LREAL   :=  0.00006103515625;
        END_VAR
        VAR PUBLIC

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            ScalingRead             :   BOOL := FALSE;
            PNU_11724               :   LINT;
            PNU_11725               :   LINT;
            PNU_12345               :   REAL;
            PNU_11122               :   REAL;
            PNU_810                 :   REAL;
            PNU_811                 :   REAL;
            PNU_11203               :   BOOL;
            PNU_11734               :   LINT;
            PNU_11735               :   LINT;
            // State : UINT;
            _AxisRefExt :  AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
            Parametrization : AxoReadWritePROFIdriveParameter; 
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject; 
                hwID                :   WORD;
                hwIdTelegram111     :   WORD;                       //  Hardware ID of the Profidrive telegram 111 of this axis
                hwIdTelegram750     :   WORD;                       //  Hardware ID of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   WORD;                       //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#742, Enable AND NOT EnablePositive, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#743, Enable AND NOT EnableNegative, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#701, hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702, hwIdTelegram111 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703, hwIdTelegram750 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704, MAP_HW_ID = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                DriveStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdTelegram111 = WORD#0 THEN
                DriveStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdTelegram750 = WORD#0 THEN
                DriveStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF MAP_HW_ID = WORD#0 THEN
                DriveStatus.Error.Id := UINT#704;
                RETURN;
            END_IF;
        
            THIS.Initialize(parent);

            THIS.Open();

            _AxisRefExt.Data.hwID                := hwID;
            _AxisRefExt.Data.hwIdTelegram111     := hwIdTelegram111;
            _AxisRefExt.Data.hwIdTelegram750     := hwIdTelegram750;
            _AxisRefExt.Data.MAP_HW_ID           := MAP_HW_ID;


            Parametrization.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            SUPER.Execute(_AxisRefExt,Enable,EnablePositive,EnableNegative);
            THIS.Execute(_AxisRefExt);
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoContext; 
                hwID                :   WORD;
                hwIdTelegram111     :   WORD;                       //  Hardware ID of the Profidrive telegram 111 of this axis
                hwIdTelegram750     :   WORD;                       //  Hardware ID of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   WORD;                       //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#742, Enable AND NOT EnablePositive, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#743, Enable AND NOT EnableNegative, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#701, hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702, hwIdTelegram111 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703, hwIdTelegram750 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704, MAP_HW_ID = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                DriveStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdTelegram111 = WORD#0 THEN
                DriveStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdTelegram750 = WORD#0 THEN
                DriveStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF MAP_HW_ID = WORD#0 THEN
                DriveStatus.Error.Id := UINT#704;
                RETURN;
            END_IF;
        
            THIS.Initialize(parent);

            THIS.Open();

            _AxisRefExt.Data.hwID                := hwID;
            _AxisRefExt.Data.hwIdTelegram111     := hwIdTelegram111;
            _AxisRefExt.Data.hwIdTelegram750     := hwIdTelegram750;
            _AxisRefExt.Data.MAP_HW_ID           := MAP_HW_ID;


            Parametrization.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            SUPER.Execute(_AxisRefExt,Enable,EnablePositive,EnableNegative);
            THIS.Execute(_AxisRefExt);
        END_METHOD   

        METHOD PRIVATE Execute
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                tempDWord   :   DWORD;
            END_VAR

            _AxisReference ?= AxisRef;
            Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);            
            IF(_AxisReference = NULL) THEN
                DriveStatus.Error.Id := UINT#707;
                RETURN;
            END_IF;
            //********************Diagnostics******************//          
            HardwareDiagnosticsTask.Run(TO_UINT(_AxisReference^.Data.hwID));
            //********************PARAMETRIZAION***************//          
            Parametrization.Run(THIS);
            Parametrization.Inputs.HardwareId := _AxisReference^.Data.MAP_HW_ID;            
            //*******************SCALING***********************//          
            Messenger.ActivateOnCondition(ULINT#744,NOT ScalingRead , eAxoMessageCategory#Warning);            
            IF NOT ScalingRead THEN
                IF State = UINT#0 THEN
                    State := UINT#1;
                END_IF;
                //Reading PNU 11724 Factor group Position
                IF State = UINT#1 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11724;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11724 := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#2;
                    END_IF;
                END_IF;
                IF State = UINT#2 THEN
                    Parametrization.Inputs.Enable := FALSE;
                    IF NOT Parametrization.Outputs.Done THEN
                        State := UINT#3;
                    END_IF;
                END_IF;
                //Reading PNU 11725 Factor group Velocity
                IF State = UINT#3 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11725;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11725 := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#4;
                    END_IF;
                END_IF;
                IF State = UINT#4 THEN
                    Parametrization.Inputs.Enable := FALSE;
                    IF NOT Parametrization.Outputs.Done THEN
                        State := UINT#5;
                    END_IF;
                END_IF;                
                //Reading PNU 12345 Base value velocity
                IF State = UINT#5 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 12345;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_12345 := Parametrization.Outputs.ValueReadREAL;
                        State := UINT#6;
                    END_IF;
                END_IF;
                IF State = UINT#6 THEN
                    Parametrization.Inputs.Enable := FALSE;
                    IF NOT Parametrization.Outputs.Done THEN
                        State := UINT#7;
                    END_IF;
                END_IF;  
                //Reading PNU 11122 Maximum motor torque/servo drive 
                IF State = UINT#7 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11122;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11122 := Parametrization.Outputs.ValueReadREAL;
                        State := UINT#8;
                    END_IF;
                END_IF;
                IF State = UINT#8 THEN
                    Parametrization.Inputs.Enable := FALSE;
                    IF NOT Parametrization.Outputs.Done THEN
                        State := UINT#9;
                    END_IF;
                END_IF;
                //Reading PNU 810 Base value acceleration
                IF State = UINT#9 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 810;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_810 := Parametrization.Outputs.ValueReadREAL;
                        State := UINT#10;
                    END_IF;
                END_IF;
                IF State = UINT#10 THEN
                    Parametrization.Inputs.Enable := FALSE;
                    IF NOT Parametrization.Outputs.Done THEN
                        State := UINT#11;
                    END_IF;
                END_IF;    
                //Reading PNU 811 Base value deceleration
                IF State = UINT#11 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 811;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_811 := Parametrization.Outputs.ValueReadREAL;
                        State := UINT#12;
                    END_IF;
                END_IF;
                IF State = UINT#12 THEN
                    Parametrization.Inputs.Enable := FALSE;
                    IF NOT Parametrization.Outputs.Done THEN
                        State := UINT#13;
                    END_IF;
                END_IF;    
                
                IF State = UINT#13 THEN
                    ScalingConstantRequiredPosition := EXP(LN(10) * TO_LREAL(-1 * PNU_11724));
                    ScalingConstantActualPosition := EXP(LN(10) * TO_LREAL(PNU_11724));
                    ScalingConstantRequiredVelocity := EXP(LN(10) * TO_LREAL(-1 * PNU_11725));
                    ScalingConstantActualVelocity := PNU_12345 / 1073741824.0;
                    ScalingConstantRequiredTorque := 1;
                    ScalingConstantActualTorque := PNU_11122 / 16384;
                    ScalingConstantRequiredAcceleration := 16384 / PNU_810;
                    ScalingConstantRequiredDeceleration := 16384 / PNU_811;
                    THIS.
                    ScalingRead := TRUE;
                    State := UINT#0;

                    AxoStop_Deceleration := 1.0;
                    AxoStop_Jerk := 500.0;
                    AxoHalt_Deceleration := 1.0;
                    AxoHalt_Jerk := 500.0;
                    AxoHome_Position := 0.0;
                    AxoHome_HommingMode := -17;
                    AxoHome_Velocity := 0.01;
                    AxoHome_Acceleration := 1;
                    AxoHome_Deceleration := 1;
                    AxoSetPosition_Position := 0.0;
                    AxoMoveAbsolute_Position := 0.0;
                    AxoMoveAbsolute_Velocity := 0.01;
                    AxoMoveAbsolute_Acceleration := 1;
                    AxoMoveAbsolute_Deceleration := 1;
                    AxoMoveAbsolute_Jerk := 500;
                    AxoMoveRelative_Distance := 0.0;
                    AxoMoveRelative_Velocity := 0.01;
                    AxoMoveRelative_Acceleration := 1;
                    AxoMoveRelative_Deceleration := 1;
                    AxoMoveRelative_Jerk := 500;
                    AxoMoveAdditive_Distance := 0.0;
                    AxoMoveAdditive_Velocity := 0.01;
                    AxoMoveAdditive_Acceleration := 1;
                    AxoMoveAdditive_Deceleration := 1;
                    AxoMoveAdditive_Jerk := 500;
                    AxoMoveVelocity_Velocity := 0.01;
                    AxoMoveVelocity_Acceleration := 1;
                    AxoMoveVelocity_Deceleration := 1;
                    AxoMoveVelocity_Jerk := 500;
                    AxoTorqueControl_Torque := 0.0;
                    AxoTorqueControl_TorqueRamp := 1;
                    AxoTorqueControl_Velocity := 0.01;
                    AxoTorqueControl_Acceleration := 1;
                    AxoTorqueControl_Deceleration := 1;
                    AxoTorqueControl_Jerk := 500;
                    AxoJog_Velocity := 0.01;
                    AxoJog_Acceleration := 1;
                    AxoJog_Deceleration := 1;
                    AxoJog_Jerk := 500;
                END_IF;                                
                RETURN;
            END_IF;
            //*************************************************//

            THIS.ActualPosition := TO_LREAL(_AxisReference^.Telegram111_In.XIST_A) * ScalingConstantActualPosition;
            THIS.ActualVelocity := TO_LREAL(_AxisReference^.Telegram111_In.NIST_B) * ScalingConstantActualVelocity;
            THIS.ActualTorque := TO_LREAL(_AxisReference^.Telegram750_In.M_Actual) * ScalingConstantActualTorque;

            IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Disabled;
            ELSIF State>=UINT#20 AND State<UINT#59 OR _AxisReference^.Telegram111_Out.STW1.StartHoming THEN// AxisRef^.Fieldbus_Out.DriveToZeroPoint
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Homing;
            ELSIF State>=UINT#80 AND State<UINT#109 THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#DiscreteMotion;
            ELSIF State>=UINT#110 AND State<UINT#129 THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#ContinuousMotion;
            // ELSIF _AxisReference^.Data.SynchronizedMotion THEN
            //     DriveState := AXOpen.Components.Drives.eAxoDriveState#SynchronizedMotion;
            ELSIF NOT _AxisReference^.Telegram111_Out.STW1.cancelTraversing AND NOT _AxisReference^.Telegram111_In.ZSW1.driveStopped THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Stopping;
            ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent AND _AxisReference^.Telegram111_In.ZSW1.driveStopped THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Errorstop;
            ELSIF _AxisReference^.Telegram111_In.ZSW1.driveStopped THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Standstill;
            END_IF;

            THIS.Close();               
        END_METHOD

        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PROTECTED  OVERRIDE UpdateInputs : BOOL
            VAR_INPUT
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            ;
        END_METHOD   

        ///<summary>
        /// Ensures swapping the AxisRef data structure into the hardware output data structure
        ///</summary>
        METHOD PROTECTED OVERRIDE UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
            ;
        END_METHOD   

        METHOD PROTECTED  UpdateInputs : BOOL
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                _Telegram111 : ARRAY[0..23] OF BYTE; 
                _Telegram750 : ARRAY[0..1] OF WORD; 
                returnValue : WORD;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                DriveStatus.Error.Id := UINT#707;
                RETURN;
            END_IF;

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_AxisReference^.Data.hwIdTelegram111 ,_Telegram111);
            Messenger.ActivateOnCondition(ULINT#827,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RETURN;
            END_IF;

            // ZSW1
            _AxisReference^.Telegram111_In.ZSW1.followingErrorInTolerance             := _Telegram111[0].%X0;
            _AxisReference^.Telegram111_In.ZSW1.controlRequest                        := _Telegram111[0].%X1;
            _AxisReference^.Telegram111_In.ZSW1.targetPosReached                      := _Telegram111[0].%X2;
            _AxisReference^.Telegram111_In.ZSW1.homePosSet                            := _Telegram111[0].%X3;
            _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated   := _Telegram111[0].%X4;
            _AxisReference^.Telegram111_In.ZSW1.driveStopped                          := _Telegram111[0].%X5;
            _AxisReference^.Telegram111_In.ZSW1.axisAccelerates                       := _Telegram111[0].%X6;
            _AxisReference^.Telegram111_In.ZSW1.axisDecelerates                       := _Telegram111[0].%X7;
            _AxisReference^.Telegram111_In.ZSW1.readyForSwitchOn                      := _Telegram111[1].%X0;
            _AxisReference^.Telegram111_In.ZSW1.ready                                 := _Telegram111[1].%X1;
            _AxisReference^.Telegram111_In.ZSW1.operationEnabled                      := _Telegram111[1].%X2;
            _AxisReference^.Telegram111_In.ZSW1.faultPresent                          := _Telegram111[1].%X3;
            _AxisReference^.Telegram111_In.ZSW1.noCoastingActive                      := _Telegram111[1].%X4;
            _AxisReference^.Telegram111_In.ZSW1.noQuickStopActive                     := _Telegram111[1].%X5;
            _AxisReference^.Telegram111_In.ZSW1.switchingOnInhibitedActive            := _Telegram111[1].%X6;
            _AxisReference^.Telegram111_In.ZSW1.warningActive                         := _Telegram111[1].%X7;
            //POS_ZSW1
            _AxisReference^.Telegram111_In.POS_ZSW1.%B1                               := _Telegram111[2];
            _AxisReference^.Telegram111_In.POS_ZSW1.%B0                               := _Telegram111[3];
            // Positioning.Outputs.EPosZSW1 := _AxisReference^.Telegram111_In.POS_ZSW1;
            //POS_ZSW2
            _AxisReference^.Telegram111_In.POS_ZSW2.%B1                               := _Telegram111[4];
            _AxisReference^.Telegram111_In.POS_ZSW2.%B0                               := _Telegram111[5];
            // Positioning.Outputs.EPosZSW2 := _AxisReference^.Telegram111_In.POS_ZSW2;
            // ZSW2
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit8                    := _Telegram111[6].%X0;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit9                    := _Telegram111[6].%X1;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit10                   := _Telegram111[6].%X2;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit11                   := _Telegram111[6].%X3;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit0                      := _Telegram111[6].%X4;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit1                      := _Telegram111[6].%X5;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit2                      := _Telegram111[6].%X6;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit3                      := _Telegram111[6].%X7;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit0                    := _Telegram111[7].%X0;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit1                    := _Telegram111[7].%X1;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit2                    := _Telegram111[7].%X2;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit3                    := _Telegram111[7].%X3;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit4                    := _Telegram111[7].%X4;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit5                    := _Telegram111[7].%X5;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit6                    := _Telegram111[7].%X6;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit7                    := _Telegram111[7].%X7;
            //MELDW
            _AxisReference^.Telegram111_In.MELDW.%B1                                  := _Telegram111[8];
            _AxisReference^.Telegram111_In.MELDW.%B0                                  := _Telegram111[9];
            //XIST_A
            _AxisReference^.Telegram111_In.XIST_A.%B3                                 := _Telegram111[10];
            _AxisReference^.Telegram111_In.XIST_A.%B2                                 := _Telegram111[11];
            _AxisReference^.Telegram111_In.XIST_A.%B1                                 := _Telegram111[12];
            _AxisReference^.Telegram111_In.XIST_A.%B0                                 := _Telegram111[13];
            //NIST_B
            _AxisReference^.Telegram111_In.NIST_B.%B3                                 := _Telegram111[14];
            _AxisReference^.Telegram111_In.NIST_B.%B2                                 := _Telegram111[15];
            _AxisReference^.Telegram111_In.NIST_B.%B1                                 := _Telegram111[16];
            _AxisReference^.Telegram111_In.NIST_B.%B0                                 := _Telegram111[17];
            //Fault_Code
            _AxisReference^.Telegram111_In.Fault_Code.%B1                             := _Telegram111[18];
            _AxisReference^.Telegram111_In.Fault_Code.%B0                             := _Telegram111[19];
            //Warn_Code
            _AxisReference^.Telegram111_In.Warn_Code.%B1                              := _Telegram111[20];
            _AxisReference^.Telegram111_In.Warn_Code.%B0                              := _Telegram111[21];
            //Reserved 
            _AxisReference^.Telegram111_In.Reserved.%B1                               := _Telegram111[22];
            _AxisReference^.Telegram111_In.Reserved.%B0                               := _Telegram111[23];
            //M_Actual 
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_AxisReference^.Data.hwIdTelegram750,_Telegram750);
            Messenger.ActivateOnCondition(ULINT#828,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RETURN;
            END_IF;
            _AxisReference^.Telegram750_In.M_Actual                                   := TO_INT(_Telegram750[0]);
        END_METHOD   

        METHOD PROTECTED UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                tempDWord   :   DWORD;
                _Telegram111 : ARRAY[0..23] OF BYTE; 
                _Telegram750 : ARRAY[0..7] OF BYTE; 
                returnValue : WORD;
            END_VAR
            _AxisReference ?= AxisRef;
            Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);            
            IF(_AxisReference = NULL) THEN
                DriveStatus.Error.Id := UINT#707;
                RETURN;
            END_IF;
            

            //STW1
            _Telegram111[1].%X0 := _AxisReference^.Telegram111_Out.STW1.on_;
            _Telegram111[1].%X1 := _AxisReference^.Telegram111_Out.STW1.noCoastStop;
            _Telegram111[1].%X2 := _AxisReference^.Telegram111_Out.STW1.noQuickStop;
            _Telegram111[1].%X3 := _AxisReference^.Telegram111_Out.STW1.enableOperation;
            _Telegram111[1].%X4 := _AxisReference^.Telegram111_Out.STW1.cancelTraversing;
            _Telegram111[1].%X5 := _AxisReference^.Telegram111_Out.STW1.intermediateStop;
            _Telegram111[1].%X6 := _AxisReference^.Telegram111_Out.STW1.activateTraversing;
            _Telegram111[1].%X7 := _AxisReference^.Telegram111_Out.STW1.acknowledgeFault;
            _Telegram111[0].%X0 := _AxisReference^.Telegram111_Out.STW1.jog1;
            _Telegram111[0].%X1 := _AxisReference^.Telegram111_Out.STW1.jog2;
            _Telegram111[0].%X2 := _AxisReference^.Telegram111_Out.STW1.controlByPlc;
            _Telegram111[0].%X3 := _AxisReference^.Telegram111_Out.STW1.StartHoming;
            _Telegram111[0].%X4 := _AxisReference^.Telegram111_Out.STW1.ReleaseBrake;
            _Telegram111[0].%X5 := _AxisReference^.Telegram111_Out.STW1.ExternalBlockChange;
            _Telegram111[0].%X6 := _AxisReference^.Telegram111_Out.STW1.reserved14;
            _Telegram111[0].%X7 := _AxisReference^.Telegram111_Out.STW1.reserved15;
            //POS_STW1
            _Telegram111[3].%X0 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0;
            _Telegram111[3].%X1 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1;
            _Telegram111[3].%X2 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2;
            _Telegram111[3].%X3 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3;
            _Telegram111[3].%X4 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4;
            _Telegram111[3].%X5 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5;
            _Telegram111[3].%X6 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6;
            _Telegram111[3].%X7 := _AxisReference^.Telegram111_Out.POS_STW1.reserved7;
            _Telegram111[2].%X0 := _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD;
            _Telegram111[2].%X1 := _AxisReference^.Telegram111_Out.POS_STW1.PosModulo;
            _Telegram111[2].%X2 := _AxisReference^.Telegram111_Out.POS_STW1.NegModulo;
            _Telegram111[2].%X3 := _AxisReference^.Telegram111_Out.POS_STW1.reserved11;
            _Telegram111[2].%X4 := _AxisReference^.Telegram111_Out.POS_STW1.reserved12;
            _Telegram111[2].%X5 := _AxisReference^.Telegram111_Out.POS_STW1.reserved13;
            _Telegram111[2].%X6 := _AxisReference^.Telegram111_Out.POS_STW1.SetupMode;
            _Telegram111[2].%X7 := _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate;    
            //POS_STW2
            _Telegram111[5].%X0 := _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode;
            _Telegram111[5].%X1 := _AxisReference^.Telegram111_Out.POS_STW2.SetReferencePoint;
            _Telegram111[5].%X2 := _AxisReference^.Telegram111_Out.POS_STW2.reserved2;
            _Telegram111[5].%X3 := _AxisReference^.Telegram111_Out.POS_STW2.reserved3;
            _Telegram111[5].%X4 := _AxisReference^.Telegram111_Out.POS_STW2.reserved4;
            _Telegram111[5].%X5 := _AxisReference^.Telegram111_Out.POS_STW2.jog_inc;
            _Telegram111[5].%X6 := _AxisReference^.Telegram111_Out.POS_STW2.reserved6;
            _Telegram111[5].%X7 := _AxisReference^.Telegram111_Out.POS_STW2.reserved7;
            _Telegram111[4].%X0 := _AxisReference^.Telegram111_Out.POS_STW2.FlyingRef;
            _Telegram111[4].%X1 := _AxisReference^.Telegram111_Out.POS_STW2.reserved9;
            _Telegram111[4].%X2 := _AxisReference^.Telegram111_Out.POS_STW2.SelectProbe;
            _Telegram111[4].%X3 := _AxisReference^.Telegram111_Out.POS_STW2.ProbeEdgeEval;
            _Telegram111[4].%X4 := _AxisReference^.Telegram111_Out.POS_STW2.reserved12;
            _Telegram111[4].%X5 := _AxisReference^.Telegram111_Out.POS_STW2.reserved13;
            _Telegram111[4].%X6 := _AxisReference^.Telegram111_Out.POS_STW2.SW_Limit;
            _Telegram111[4].%X7 := _AxisReference^.Telegram111_Out.POS_STW2.HW_Limit;
            //STW2
            _Telegram111[7].%X0 := _AxisReference^.Telegram111_Out.STW2.reserved0;
            _Telegram111[7].%X1 := _AxisReference^.Telegram111_Out.STW2.reserved1;
            _Telegram111[7].%X2 := _AxisReference^.Telegram111_Out.STW2.reserved2;
            _Telegram111[7].%X3 := _AxisReference^.Telegram111_Out.STW2.reserved3;
            _Telegram111[7].%X4 := _AxisReference^.Telegram111_Out.STW2.reserved4;
            _Telegram111[7].%X5 := _AxisReference^.Telegram111_Out.STW2.reserved5;
            _Telegram111[7].%X6 := _AxisReference^.Telegram111_Out.STW2.reserved6;
            _Telegram111[7].%X7 := _AxisReference^.Telegram111_Out.STW2.reserved7;
            _Telegram111[6].%X0 := _AxisReference^.Telegram111_Out.STW2.TravelToFixStop;
            _Telegram111[6].%X1 := _AxisReference^.Telegram111_Out.STW2.reserved9;
            _Telegram111[6].%X2 := _AxisReference^.Telegram111_Out.STW2.reserved10;
            _Telegram111[6].%X3 := _AxisReference^.Telegram111_Out.STW2.reserved11;
            _Telegram111[6].%X4 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit0;
            _Telegram111[6].%X5 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit1;
            _Telegram111[6].%X6 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit2;
            _Telegram111[6].%X7 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit3;   
            //Override
            _Telegram111[9] := _AxisReference^.Telegram111_Out.Override_.%B0;
            _Telegram111[8] := _AxisReference^.Telegram111_Out.Override_.%B1;
            //TargetPos
            tempDWord := TO_DWORD(_AxisReference^.Telegram111_Out.MDI_TARPOS);
            _Telegram111[13] := tempDWord.%B0;
            _Telegram111[12] := tempDWord.%B1;
            _Telegram111[11] := tempDWord.%B2;
            _Telegram111[10] := tempDWord.%B3;
            //TargetVelocity
            tempDWord := TO_DWORD(_AxisReference^.Telegram111_Out.MDI_VELOCITY);
            _Telegram111[17] := tempDWord.%B0;
            _Telegram111[16] := tempDWord.%B1;
            _Telegram111[15] := tempDWord.%B2;
            _Telegram111[14] := tempDWord.%B3;
            // ACC, DEC
            _Telegram111[19] := _AxisReference^.Telegram111_Out.MDI_ACC.%B0;
            _Telegram111[18] := _AxisReference^.Telegram111_Out.MDI_ACC.%B1;
            _Telegram111[21] := _AxisReference^.Telegram111_Out.MDI_DEC.%B0;
            _Telegram111[20] := _AxisReference^.Telegram111_Out.MDI_DEC.%B1;
            _Telegram111[23] := _AxisReference^.Telegram111_Out.reserved11.%B0;
            _Telegram111[22] := _AxisReference^.Telegram111_Out.reserved11.%B1;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_AxisReference^.Data.hwIdTelegram111,_Telegram111);
            Messenger.ActivateOnCondition(ULINT#829,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RETURN;
            END_IF;
            // M_ADD1, M_LIMIT_POS, M_LIMIT_NEG
            _Telegram750[1] := _AxisReference^.Telegram750_Out.M_ADD1.%B0;
            _Telegram750[0] := _AxisReference^.Telegram750_Out.M_ADD1.%B1;
            _Telegram750[3] := _AxisReference^.Telegram750_Out.M_LIMIT_POS.%B0;
            _Telegram750[2] := _AxisReference^.Telegram750_Out.M_LIMIT_POS.%B1;
            _Telegram750[5] := _AxisReference^.Telegram750_Out.M_LIMIT_NEG.%B0;
            _Telegram750[4] := _AxisReference^.Telegram750_Out.M_LIMIT_NEG.%B1;
            _Telegram750[7] := _AxisReference^.Telegram750_Out.Reserved.%B0;
            _Telegram750[6] := _AxisReference^.Telegram750_Out.Reserved.%B1;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_AxisReference^.Data.hwIdTelegram750,_Telegram750);
            Messenger.ActivateOnCondition(ULINT#830,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RETURN;
            END_IF;

        END_METHOD   


        ///<summary>
        /// This method controls the power stage (On or Off).
        ///</summary>
        VAR INTERNAL
            MC_PowerEnable_PV					:	BOOL := FALSE;		//Enable - previous value
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Power 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            END_VAR
            VAR_OUTPUT
                Status          :   BOOL;                       //  Effective state of the power stage
                Valid           :   BOOL;                       //  If true, a valid set of outputs is available at the method
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification            
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#709,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable THEN
                THIS.UpdateInputs(AxisRef);
                IF NOT MC_PowerEnable_PV THEN
                    _AxisReference^.Telegram750_Out.M_LIMIT_POS := 16384;
                    _AxisReference^.Telegram750_Out.M_LIMIT_NEG := -16384;
                    _AxisReference^.Telegram111_Out.MDI_ACC := TO_UINT(16384.0 * _AxisReference^.Data.OverrideAccelerationFactor);
                    _AxisReference^.Telegram111_Out.MDI_DEC := TO_UINT(16384.0 * _AxisReference^.Data.OverrideAccelerationFactor);
                    _AxisReference^.Telegram111_Out.Override_ := TO_WORD(TO_INT(16384.0 * _AxisReference^.Data.OverrideVelocityFactor));
                    _AxisReference^.Telegram111_Out.MDI_VELOCITY := DINT#1;
                END_IF;
                _AxisReference^.Telegram111_Out.STW1.on_ := TRUE;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                // _AxisReference^.Telegram111_Out.MDI_VELOCITY := DINT#1;
                _AxisReference^.Telegram111_Out.POS_STW2.SW_Limit := TRUE;
                _AxisReference^.Telegram111_Out.POS_STW2.HW_Limit := TRUE;
                _AxisReference^.Telegram111_Out.STW1.noCoastStop := TRUE;
                _AxisReference^.Telegram111_Out.STW1.noQuickStop := TRUE;
                _AxisReference^.Telegram111_Out.STW1.enableOperation := TRUE;
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE;
                _AxisReference^.Telegram111_Out.STW1.intermediateStop := TRUE;
                _AxisReference^.Telegram111_Out.STW1.controlByPlc := TRUE;
                IF _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                    Status	:= TRUE;						(* Status OK*)
                    Valid := TRUE;
                ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent = TRUE THEN
                    Error		:= TRUE; 						(*	Set the ERROR-Output *)
                    Valid := TRUE;
                    ErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                END_IF;
                THIS.UpdateOutputs(AxisRef);
            END_IF;


            IF NOT Enable AND MC_PowerEnable_PV THEN
                THIS.UpdateInputs(AxisRef);
                _AxisReference^.Telegram111_Out.STW1.on_  := FALSE;
                THIS.UpdateOutputs(AxisRef);
            END_IF;

            MC_PowerEnable_PV := Enable;
        END_METHOD 

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
        VAR INTERNAL
            MC_HomeExecute_PV					: 	BOOL;				//Execute - previous value
            MC_HomeErrorID					    : 	WORD;
            MC_HomeCycle					    : 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Home
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                Position        :   LREAL;                      //  Absolute position when the reference signal is detected             
                HommingMode     :   INT;                        //  Required homming mode           
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Reference known and set sucessfully
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
             VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                HommingModeInvalid : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#710,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#745, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#746, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            HommingModeInvalid := TRUE;
            IF HommingMode = -27 OR  HommingMode = -23 OR HommingMode = -18 OR  HommingMode = -17 OR  HommingMode = -2 OR  HommingMode = -1 OR HommingMode = 1 OR HommingMode = 2 THEN
                HommingModeInvalid := FALSE;
            ELSIF HommingMode = 7 OR  HommingMode = 11 OR HommingMode = 17 OR  HommingMode = 18 OR  HommingMode = 23 OR  HommingMode = 27 OR HommingMode = 33 OR HommingMode = 34 OR HommingMode = 37 THEN
                HommingModeInvalid := FALSE;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#747, Execute AND HommingModeInvalid, eAxoMessageCategory#ProgrammingError);
            
            IF THIS.AxoHome_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Home;
            END_IF;

            IF Execute AND NOT MC_HomeExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_HomeCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 		
                THIS.UpdateInputs(AxisRef);
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_HomeErrorID :=  WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#20;
                END_IF;

                IF State = UINT#20 THEN
                    IF Acceleration <= 0 OR Deceleration <= 0 OR HommingModeInvalid THEN
                        State := UINT#59;
                    ELSE
                        State := UINT#21;
                    END_IF;
                END_IF;
                //Write  PNU 11206 Acceleration
                IF State = UINT#21 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11206; //Acc
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Acceleration);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#22;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#748;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#22 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#23;
                    END_IF;
                END_IF;   
                //Write  PNU 11209 Acceleration
                IF State = UINT#23 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11209;//Acc
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Acceleration);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#24;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#749;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#24 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#25;
                    END_IF;
                END_IF;        
                //Write  PNU 11728 Acceleration
                IF State = UINT#25 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11728;//Acc
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Acceleration);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#26;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#750;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#26 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#27;
                    END_IF;
                END_IF;                 
                //Write  PNU 11205 Velocity
                IF State = UINT#27 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11205; //Vel
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Velocity);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#28;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#751;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#28 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#29;
                    END_IF;
                END_IF;        
                //Write  PNU 11208 Velocity
                IF State = UINT#29 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11208;//Vel
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Velocity)*REAL#0.5;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#30;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#752;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#30 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#31;
                    END_IF;
                END_IF;        
                //Write  PNU 11211 Velocity
                IF State = UINT#31 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11211;//Vel
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Velocity)*REAL#5.0;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#32;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#753;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#32 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#33;
                    END_IF;
                END_IF;    
                //Read  PNU 11735 Homing mode
                IF State = UINT#33 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11735;//mode
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11735 := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#34;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#765;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#34 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#35;
                    END_IF;
                END_IF;    
                //Write  PNU 11735 Homing mode
                IF State = UINT#35 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11735;//mode
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := TO_LINT(HommingMode);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#36;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#754;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#36 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#37;
                    END_IF;
                END_IF;    
                //Write  PNU 12681 deactivate save zero offset
                IF State = UINT#37 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12681;//deactivate save zero offset
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBOOL := FALSE;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#38;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#756;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#38 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#39;
                    END_IF;
                END_IF;    
                //Homing started
                IF State = UINT#39 THEN
                    Busy := TRUE;            
                    Active := TRUE;     
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := TRUE; 
                    IF  NOT _AxisReference^.Telegram111_In.ZSW1.targetPosReached AND NOT _AxisReference^.Telegram111_In.ZSW1.homePosSet THEN
                        State := UINT#40;
                    END_IF;
                END_IF;                                       
                IF State = UINT#40 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Telegram111_In.ZSW1.targetPosReached AND _AxisReference^.Telegram111_In.ZSW1.homePosSet THEN
                        _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                        IF Position = 0 THEN
                            State := UINT#57;
                        ELSE
                            State := UINT#41;
                        END_IF;
                    END_IF;
                END_IF;  
                //Read PNU 11203 Move to axis zero after homming
                IF State = UINT#41 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11203;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11203 := Parametrization.Outputs.ValueReadBool;
                        State := UINT#42;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#757;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#42 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#43;
                    END_IF;
                END_IF; 
                //Read PNU 11734 Axis zero point offset
                IF State = UINT#43 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11734;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11734 := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#44;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#758;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#44 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#45;
                    END_IF;
                END_IF; 
                //Write PNU 11203 deactivate Move to axis zero after homming
                IF State = UINT#45 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11203;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBOOL := FALSE;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#46;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#759;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#46 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#47;
                    END_IF;
                END_IF;   
                //Write PNU 11734 Axis zero point offset
                IF State = UINT#47 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11734;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := TO_LINT(Position * -10000000000.0);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#48;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#760;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#48 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#49;
                    END_IF;
                END_IF; 
                //Write  PNU 11735 Homing mode
                IF State = UINT#49 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11735;//mode
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := TO_LINT(37);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#50;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#761;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#50 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#51;
                    END_IF;
                END_IF;    
                //Homing started
                IF State = UINT#51 THEN
                    Busy := TRUE;            
                    Active := TRUE;     
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := TRUE; 
                    IF  NOT _AxisReference^.Telegram111_In.ZSW1.targetPosReached AND NOT _AxisReference^.Telegram111_In.ZSW1.homePosSet THEN
                        State := UINT#52;
                    END_IF;
                END_IF;                                       
                IF State = UINT#52 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Telegram111_In.ZSW1.targetPosReached AND _AxisReference^.Telegram111_In.ZSW1.homePosSet THEN
                        _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                        State := UINT#53;
                    END_IF;
                END_IF;  
                //Write PNU 11203 Move to axis zero after homming
                IF State = UINT#53 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11203;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBool := PNU_11203;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#54;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#762;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#54 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#55;
                    END_IF;
                END_IF; 
                //Write PNU 11734 Axis zero point offset
                IF State = UINT#55 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11734;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := PNU_11734;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                         State := UINT#56;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#763;
                        State := UINT#59;
                    END_IF;
                END_IF;
                IF State = UINT#56 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#57;
                    END_IF;
                END_IF; 

                IF State = UINT#57 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11735;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := PNU_11735;

                    IF Parametrization.Outputs.Error THEN 
                        MC_HomeErrorID := WORD#766;
                        State := UINT#59;
                    END_IF;                    
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE;
                    Done := Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error;            
                    MC_HomeCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#58 THEN
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE;
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#59 THEN
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE;
                    MC_HomeCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#20 AND State<UINT#57 THEN
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#58;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_HomeErrorID = WORD#0 THEN
                            MC_HomeErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#59;
                    ELSIF _AxisReference^.Data.Cycle <> MC_HomeCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#58;
                    END_IF;                  
                END_IF;         
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoHome_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_HomeErrorID := WORD#0;
                State := UINT#0;
                // MC_HomeCycle := ULINT#0;     
                Parametrization.Inputs.Enable := FALSE;
                Parametrization.Inputs.ReadWrite   := FALSE;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;
            IF THIS.AxoHome_Task.RestoreTriggered() AND State>=UINT#20 AND State<=UINT#59 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_HomeErrorID := WORD#0;
                State := UINT#0;
                MC_HomeCycle := ULINT#0;     
                Parametrization.Inputs.Enable := FALSE;
                Parametrization.Inputs.ReadWrite   := FALSE;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_HomeErrorID;
            MC_HomeExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        ///</summary>
        VAR INTERNAL
            MC_StopExecute_PV					: 	BOOL;				//Execute - previous value
            MC_StopErrorID					    : 	WORD;
            MC_StopCycle					    : 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Stop 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the action at rising edge
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#711,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#740, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#741, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF THIS.AxoStop_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Stop;
            END_IF;

            IF Execute AND NOT MC_StopExecute_PV THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_StopCycle := _AxisReference^.Data.Cycle ;
                State := UINT#0;
            END_IF;

            IF Execute THEN 				
                THIS.UpdateInputs(AxisRef);         
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_StopErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    State := UINT#60;
                END_IF;

                IF State = UINT#60 THEN
                    IF Deceleration <= 0 OR Jerk <= 0 THEN
                        State := UINT#69;
                    ELSE
                        State := UINT#61;
                    END_IF;
                END_IF;
                //Writing PNU 12327 Jerk
                IF State = UINT#61 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Jerk);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#62;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_StopErrorID := WORD#755;
                        State := UINT#69;
                    END_IF;
                END_IF;
                IF State = UINT#62 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Telegram111_Out.MDI_DEC := TO_UINT(Deceleration * ScalingConstantRequiredDeceleration);
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#63;
                    END_IF;
                END_IF;               
                IF State = UINT#63 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Telegram111_In.ZSW1.driveStopped  THEN
                        State := UINT#64;
                    END_IF;
                END_IF;     
                IF State = UINT#64 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        State := UINT#65;
                    END_IF;
                END_IF;                          
                IF State = UINT#65 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        State := UINT#66;
                    END_IF;
                END_IF;                          
                IF State = UINT#66 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        State := UINT#67;
                    END_IF;
                END_IF;                          
                IF State = UINT#67 THEN
                    Done := TRUE;            
                    Active := TRUE;     
                    MC_StopCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#68 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#69 THEN
                    _AxisReference^.Telegram111_Out.MDI_DEC := UINT#16384;
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    MC_StopCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#60 AND State<UINT#67 THEN
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#68;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_StopErrorID = WORD#0 THEN
                            MC_StopErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#69;
                    ELSIF _AxisReference^.Data.Cycle <> MC_StopCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#1068;
                    END_IF;                  
                END_IF;           
                THIS.UpdateOutputs(AxisRef);                
            END_IF;

            IF THIS.AxoStop_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                MC_StopErrorID := WORD#0;
                State := UINT#0;
                // MC_StopCycle := ULINT#0;              
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoStop_Task.RestoreTriggered() AND State>=UINT#60 AND State<=UINT#69 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                MC_StopErrorID := WORD#0;
                State := UINT#0;
                MC_StopCycle := ULINT#0;  
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_StopErrorID;
            MC_StopExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        ///</summary>
        VAR INTERNAL
            MC_HaltExecute_PV					: 	BOOL;				//Execute - previous value
            MC_HaltErrorID					    : 	WORD;
            MC_HaltCycle					    : 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Halt 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the action at rising edge
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#711,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#825, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#826, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF THIS.AxoHalt_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Halt;
            END_IF;

            IF Execute AND NOT MC_HaltExecute_PV THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_HaltCycle := _AxisReference^.Data.Cycle ;
                State := UINT#0;
            END_IF;

            IF Execute THEN 				
                THIS.UpdateInputs(AxisRef);         
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_HaltErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    State := UINT#70;
                END_IF;

                IF State = UINT#70 THEN
                    IF Deceleration <= 0 OR Jerk <= 0 THEN
                        State := UINT#79;
                    ELSE
                        State := UINT#71;
                    END_IF;
                END_IF;
                IF State = UINT#71 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(Jerk);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#72;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_HaltErrorID := WORD#764;
                        State := UINT#79;
                    END_IF;
                END_IF;
                IF State = UINT#72 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Telegram111_Out.MDI_DEC := TO_UINT(Deceleration * ScalingConstantRequiredDeceleration);
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#73;
                    END_IF;
                END_IF;               
                IF State = UINT#73 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Telegram111_In.ZSW1.driveStopped  THEN
                        State := UINT#74;
                    END_IF;
                END_IF;          
                IF State = UINT#74 THEN
                    IF TRUE THEN
                        State := UINT#75;
                    END_IF;
                END_IF;                                           
                IF State = UINT#75 THEN
                    IF TRUE THEN
                        State := UINT#76;
                    END_IF;
                END_IF;                                           
                IF State = UINT#76 THEN
                    IF TRUE THEN
                        State := UINT#77;
                    END_IF;
                END_IF;                                           
                IF State = UINT#77 THEN
                    Done := TRUE;            
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                    MC_HaltCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#78 THEN
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#79 THEN
                    _AxisReference^.Telegram111_Out.MDI_DEC := UINT#16384;
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    MC_HaltCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#70 AND State<UINT#77 THEN
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#78;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_HaltErrorID = WORD#0 THEN
                            MC_HaltErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#79;
                    ELSIF _AxisReference^.Data.Cycle <> MC_HaltCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#78;
                    END_IF;                  
                END_IF;           
                THIS.UpdateOutputs(AxisRef);                
            END_IF;

            IF THIS.AxoHalt_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                MC_HaltErrorID := WORD#0;
                State := UINT#0;
                // MC_HaltCycle := ULINT#0;     
                THIS.UpdateOutputs(AxisRef);         
            END_IF;
        
            IF THIS.AxoHalt_Task.RestoreTriggered() AND State>=UINT#70 AND State<=UINT#79 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                MC_HaltErrorID := WORD#0;
                State := UINT#0;
                MC_HaltCycle := ULINT#0;   
                THIS.UpdateOutputs(AxisRef);           
            END_IF;     

            ErrorID := MC_HaltErrorID;
            MC_HaltExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
        VAR INTERNAL
            MC_MoveAbsoluteExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveAbsoluteErrorID					    : 	WORD;
            MC_MoveAbsoluteCycle					    : 	ULINT;
            MC_MoveAbsoluteContinuousUpdate_SV          :   BOOL;
            MC_MoveAbsolutePosition_PV                  :   LREAL;                                          
            MC_MoveAbsoluteVelocity_PV                  :   LREAL;                    
            MC_MoveAbsoluteAcceleration_PV              :   LREAL;                    
            MC_MoveAbsoluteDeceleration_PV              :   LREAL;                                
            MC_MoveAbsoluteJerk_PV                      :   LREAL;                     
            MC_MoveAbsoluteDirection_PV                 :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveAbsolute
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Position        :   LREAL;                      //  Commanded ‘Position’ for the motion (in technical unit [u]) (negative or positive)                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded position finally reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
                        
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#713,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#767, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#768, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#769, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#770, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF THIS.AxoMoveAbsolute_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_MoveAbsolute;
            END_IF;

            IF Execute AND NOT MC_MoveAbsoluteExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_MoveAbsoluteCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                THIS.UpdateInputs(AxisRef);         

                IF NOT ContinuousUpdate THEN
                    MC_MoveAbsoluteContinuousUpdate_SV := FALSE;
                END_IF;

                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_MoveAbsoluteErrorID := WORD#16#0000;        
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;
                    MC_MoveAbsoluteContinuousUpdate_SV := ContinuousUpdate;
                    State := UINT#80;
                END_IF;
                IF State = UINT#80 THEN
                    Busy := TRUE;            
                    Active := TRUE;   
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        _AxisReference^.Telegram111_Out.MDI_TARPOS := TO_DINT(Position * ScalingConstantRequiredPosition);
                        _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                        _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);                        
                        MC_MoveAbsolutePosition_PV      :=  Position;                  
                        MC_MoveAbsoluteVelocity_PV      :=  Velocity;                  
                        MC_MoveAbsoluteAcceleration_PV  :=  Acceleration;              
                        MC_MoveAbsoluteDeceleration_PV  :=  Deceleration;              
                        MC_MoveAbsoluteJerk_PV          :=  Jerk;                      
                        MC_MoveAbsoluteDirection_PV     :=  Direction;                                         
                        State := UINT#81;
                    END_IF;
                END_IF;
                //Writing PNU 12327 Jerk
                IF State = UINT#81 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(MC_MoveAbsoluteJerk_PV * _AxisReference^.Data.OverrideJerkFactor);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#82;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveAbsoluteErrorID := WORD#771;
                        State := UINT#89;
                    END_IF;
                END_IF;
                IF State = UINT#82 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#83;
                    END_IF;
                END_IF;               
                //Executing movement
                IF State = UINT#83 THEN
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := TRUE; 
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := TRUE;        
                    IF _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN      
                        State := UINT#84;
                    END_IF;    
                END_IF;
                IF State = UINT#84 THEN
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                    IF _AxisReference^.Telegram111_In.ZSW1.targetPosReached THEN      
                        State := UINT#85;
                    END_IF;    
                END_IF;
                IF State = UINT#85 THEN
                    IF TRUE THEN      
                        State := UINT#86;
                    END_IF;    
                END_IF;
                IF State = UINT#86 THEN
                    IF TRUE THEN      
                        State := UINT#87;
                    END_IF;    
                END_IF;
                IF State = UINT#87 THEN
                    Done := TRUE;            
                    MC_MoveAbsoluteCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#88 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#89 THEN
                    MC_MoveAbsoluteCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#80 AND State<UINT#87 THEN
                    IF MC_MoveAbsoluteContinuousUpdate_SV AND (
                        MC_MoveAbsolutePosition_PV      <>  Position OR                  
                        MC_MoveAbsoluteVelocity_PV      <>  Velocity OR                  
                        MC_MoveAbsoluteAcceleration_PV  <>  Acceleration OR              
                        MC_MoveAbsoluteDeceleration_PV  <>  Deceleration OR              
                        MC_MoveAbsoluteJerk_PV          <>  Jerk OR                      
                        MC_MoveAbsoluteDirection_PV     <>  Direction ) THEN
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                        IF NOT _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN    
                            State := UINT#80;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#88;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_MoveAbsoluteErrorID = WORD#0 THEN
                            MC_MoveAbsoluteErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#89;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveAbsoluteCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#88;
                    END_IF;                  
                END_IF;   

                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveAbsolute_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveAbsoluteErrorID := WORD#0;
                State := UINT#0;
                // MC_MoveAbsoluteCycle := ULINT#0;    
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveAbsolute_Task.RestoreTriggered() AND State>=UINT#80 AND State<=UINT#89 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveAbsoluteErrorID := WORD#0;
                MC_MoveAbsoluteCycle := ULINT#0;     
                State := UINT#0;
                MC_MoveAbsoluteExecute_PV := FALSE;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;                     

            ErrorID := MC_MoveAbsoluteErrorID;
            MC_MoveAbsoluteExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL
            MC_MoveRelativeExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveRelativeErrorID					    : 	WORD;
            MC_MoveRelativeCycle					    : 	ULINT;
            MC_MoveRelativeContinuousUpdate_SV          :   BOOL;
            MC_MoveRelativeDistance_PV                  :   LREAL;                                          
            MC_MoveRelativeVelocity_PV                  :   LREAL;                    
            MC_MoveRelativeAcceleration_PV              :   LREAL;                    
            MC_MoveRelativeDeceleration_PV              :   LREAL;                                
            MC_MoveRelativeJerk_PV                      :   LREAL;                     
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveRelative 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#714,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#772, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#773, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#774, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#775, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF THIS.AxoMoveRelative_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_MoveRelative;
            END_IF;

            IF Execute AND NOT MC_MoveRelativeExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_MoveRelativeCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                THIS.UpdateInputs(AxisRef);         
                IF NOT ContinuousUpdate THEN
                    MC_MoveRelativeContinuousUpdate_SV := FALSE;
                END_IF;

                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_MoveRelativeErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;
                    MC_MoveRelativeContinuousUpdate_SV := ContinuousUpdate;
                    State := UINT#90;
                END_IF;
                IF State = UINT#90 THEN
                    Busy := TRUE;            
                    Active := TRUE;   
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        _AxisReference^.Telegram111_Out.MDI_TARPOS := TO_DINT(Distance * ScalingConstantRequiredPosition);
                        _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                        _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        MC_MoveRelativeDistance_PV      :=  Distance;                  
                        MC_MoveRelativeVelocity_PV      :=  Velocity;                  
                        MC_MoveRelativeAcceleration_PV  :=  Acceleration;              
                        MC_MoveRelativeDeceleration_PV  :=  Deceleration;              
                        MC_MoveRelativeJerk_PV          :=  Jerk;   
                        State := UINT#91;
                    END_IF;
                END_IF;
                //Writing PNU 12327 Jerk
                IF State = UINT#91 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(MC_MoveRelativeJerk_PV * _AxisReference^.Data.OverrideJerkFactor);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#92;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveRelativeErrorID := WORD#776;
                        State := UINT#99;
                    END_IF;
                END_IF;
                IF State = UINT#92 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#93;
                    END_IF;
                END_IF;               
                //Executing movement
                IF State = UINT#93 THEN
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := TRUE;        
                    IF _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN      
                        State := UINT#94;
                    END_IF;    
                END_IF;
                IF State = UINT#94 THEN
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                    IF _AxisReference^.Telegram111_In.ZSW1.targetPosReached THEN      
                        State := UINT#95;
                    END_IF;    
                END_IF;
                IF State = UINT#95 THEN
                    IF TRUE THEN      
                        State := UINT#96;
                    END_IF;    
                END_IF;
                IF State = UINT#96 THEN
                    IF TRUE THEN      
                        State := UINT#97;
                    END_IF;    
                END_IF;
                IF State = UINT#97 THEN
                    Done := TRUE;            
                    MC_MoveRelativeCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#98 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#99 THEN
                    MC_MoveRelativeCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#90 AND State<UINT#97 THEN
                    IF MC_MoveRelativeContinuousUpdate_SV AND (
                        MC_MoveRelativeDistance_PV      <>  Distance OR                  
                        MC_MoveRelativeVelocity_PV      <>  Velocity OR                  
                        MC_MoveRelativeAcceleration_PV  <>  Acceleration OR              
                        MC_MoveRelativeDeceleration_PV  <>  Deceleration OR              
                        MC_MoveRelativeJerk_PV          <>  Jerk ) THEN
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;    
                        IF NOT _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN    
                            _AxisReference^.Telegram111_Out.MDI_TARPOS := TO_DINT((Distance) * ScalingConstantRequiredPosition) - _AxisReference^.Telegram111_In.XIST_A;
                            _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                            _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            MC_MoveRelativeDistance_PV      :=  Distance;                  
                            MC_MoveRelativeVelocity_PV      :=  Velocity;                  
                            MC_MoveRelativeAcceleration_PV  :=  Acceleration;              
                            MC_MoveRelativeDeceleration_PV  :=  Deceleration;              
                            MC_MoveRelativeJerk_PV          :=  Jerk;   
                            State := UINT#91;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#98;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_MoveRelativeErrorID = WORD#0 THEN
                            MC_MoveRelativeErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#99;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveRelativeCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#98;
                    END_IF;                  
                END_IF;   
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveRelative_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveRelativeErrorID := WORD#0;
                // MC_MoveRelativeCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveRelative_Task.RestoreTriggered() AND State>=UINT#90 AND State<=UINT#99 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveRelativeErrorID := WORD#0;
                MC_MoveRelativeCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_MoveRelativeErrorID;
            MC_MoveRelativeExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL
            MC_MoveAdditiveExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveAdditiveErrorID					    : 	WORD;
            MC_MoveAdditiveCycle					    : 	ULINT;
            MC_MoveAdditiveContinuousUpdate_SV          :   BOOL;
            MC_MoveAdditiveDistance_PV                  :   LREAL;                                          
            MC_MoveAdditiveVelocity_PV                  :   LREAL;                    
            MC_MoveAdditiveAcceleration_PV              :   LREAL;                    
            MC_MoveAdditiveDeceleration_PV              :   LREAL;                                
            MC_MoveAdditiveJerk_PV                      :   LREAL;   
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveAdditive
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#715,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#777, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#778, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#779, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#780, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF Execute AND NOT MC_MoveAdditiveExecute_PV THEN
                State := UINT#0;
            END_IF;

            IF Execute THEN 	
                THIS.UpdateInputs(AxisRef);         
                IF NOT ContinuousUpdate THEN
                    MC_MoveAdditiveContinuousUpdate_SV := FALSE;
                END_IF;

                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;   
                    MC_MoveAdditiveErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    // _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    // _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;

                    Parametrization.Inputs.Enable := FALSE;
                    MC_MoveAdditiveContinuousUpdate_SV := ContinuousUpdate;                    
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        MC_MoveAdditiveDistance_PV      :=  Distance;                  
                        MC_MoveAdditiveVelocity_PV      :=  Velocity;                  
                        MC_MoveAdditiveAcceleration_PV  :=  Acceleration;              
                        MC_MoveAdditiveDeceleration_PV  :=  Deceleration;              
                        MC_MoveAdditiveJerk_PV          :=  Jerk;   
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;    
                        IF _AxisReference^.Status.CurrentMotionTaskId = eAxoMotionTaskId#Axo_MoveAbsolute THEN
                            AxoMoveAbsolute_Task.Abort();
                            _AxisReference^.Telegram111_Out.MDI_TARPOS := TO_DINT((MC_MoveAbsolutePosition_PV + Distance) * ScalingConstantRequiredPosition);
                            _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                            _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        ELSE
                            _AxisReference^.Telegram111_Out.MDI_TARPOS := TO_DINT((Distance) * ScalingConstantRequiredPosition);
                            _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                            _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                        END_IF;
                        IF _AxisReference^.Status.CurrentMotionTaskId = eAxoMotionTaskId#Axo_MoveRelative THEN
                            AxoMoveRelative_Task.Abort();
                        END_IF;
                        _AxisReference^.Status.CurrentMotionTaskId := eAxoMotionTaskId#Axo_MoveAdditive;
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                        MC_MoveAdditiveCycle := _AxisReference^.Data.Cycle ;
                        State := UINT#101;
                    END_IF;
                END_IF;
                IF State = UINT#100 THEN
                    State := UINT#101;
                END_IF;
                //Writing PNU 12327 Jerk
                IF State = UINT#101 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(MC_MoveAdditiveJerk_PV * _AxisReference^.Data.OverrideJerkFactor);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#102;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveAdditiveErrorID := WORD#781;
                        State := UINT#109;
                    END_IF;
                END_IF;
                IF State = UINT#102 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#103;
                    END_IF;
                END_IF;               
                //Executing movement
                IF State = UINT#103 THEN
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := TRUE;        
                    IF _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN      
                        State := UINT#104;
                    END_IF;    
                END_IF;
                IF State = UINT#104 THEN
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                    IF _AxisReference^.Telegram111_In.ZSW1.targetPosReached THEN      
                        State := UINT#105;
                    END_IF;    
                END_IF;
                IF State = UINT#105 THEN
                    IF TRUE THEN      
                        State := UINT#106;
                    END_IF;    
                END_IF;
                IF State = UINT#106 THEN
                    IF TRUE THEN      
                        State := UINT#107;
                    END_IF;    
                END_IF;
                IF State = UINT#107 THEN
                    Done := TRUE;            
                    MC_MoveAdditiveCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#108 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#109 THEN
                    MC_MoveAdditiveCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#100 AND State<UINT#107 THEN
                    IF MC_MoveAdditiveContinuousUpdate_SV AND (
                        MC_MoveAdditiveDistance_PV      <>  Distance OR                  
                        MC_MoveAdditiveVelocity_PV      <>  Velocity OR                  
                        MC_MoveAdditiveAcceleration_PV  <>  Acceleration OR              
                        MC_MoveAdditiveDeceleration_PV  <>  Deceleration OR              
                        MC_MoveAdditiveJerk_PV          <>  Jerk ) THEN
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;    
                        IF NOT _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN    
                            IF _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD THEN
                                _AxisReference^.Telegram111_Out.MDI_TARPOS := _AxisReference^.Telegram111_Out.MDI_TARPOS  + TO_DINT((Distance - MC_MoveAdditiveDistance_PV) * ScalingConstantRequiredPosition);
                            ELSE
                                _AxisReference^.Telegram111_Out.MDI_TARPOS := TO_DINT((Distance) * ScalingConstantRequiredPosition) - _AxisReference^.Telegram111_In.XIST_A;
                            END_IF;
                            _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                            _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            MC_MoveAdditiveDistance_PV      :=  Distance;                  
                            MC_MoveAdditiveVelocity_PV      :=  Velocity;                  
                            MC_MoveAdditiveAcceleration_PV  :=  Acceleration;              
                            MC_MoveAdditiveDeceleration_PV  :=  Deceleration;              
                            MC_MoveAdditiveJerk_PV          :=  Jerk;   
                            State := UINT#101; 
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#108;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_MoveAdditiveErrorID = WORD#0 THEN
                            MC_MoveAdditiveErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#109;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveAdditiveCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#108;
                    END_IF;                  
                END_IF;   
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveAdditive_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveAdditiveErrorID := WORD#0;
                // MC_MoveAdditiveCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveAdditive_Task.RestoreTriggered() AND State>=UINT#100 AND State<=UINT#109 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveAdditiveErrorID := WORD#0;
                MC_MoveAdditiveCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_MoveAdditiveErrorID;
            MC_MoveAdditiveExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        ///<summary>
        VAR INTERNAL
            MC_MoveVelocityExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveVelocityErrorID					    : 	WORD;
            MC_MoveVelocityCycle					    : 	ULINT;
            MC_MoveVelocityContinuousUpdate_SV          :   BOOL;
            MC_MoveVelocityVelocity_PV                  :   LREAL;                    
            MC_MoveVelocityAcceleration_PV              :   LREAL;                    
            MC_MoveVelocityDeceleration_PV              :   LREAL;                                
            MC_MoveVelocityJerk_PV                      :   LREAL;                     
            MC_MoveVelocityDirection_PV                 :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Velocity        :   LREAL;                      //  Value of the maximum velocity [u/s]. Can be a signed value.
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-3 values: PositiveDirection, NegativeDirection, and CurrentDirection. Note: shortest way not applicable)
            END_VAR
            VAR_OUTPUT
                InVelocity      :   BOOL;                       // Commanded velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
                Velocity_   :   LREAL;                     
                Direction_  :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;                         
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#716,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#737,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection, eAxoMessageCategory#ProgrammingError);

            IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection THEN
                Velocity_ := Velocity;
            ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection THEN
                Velocity_ := -1 * Velocity;
            ELSE
                RETURN;
            END_IF;

            IF Velocity_> 0 THEN 
                Direction_ := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            ELSE
                Direction_ := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
            END_IF;
                     
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#713,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#782, Execute AND Velocity = 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#783, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#784, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#785, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF THIS.AxoMoveVelocity_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_MoveVelocity;
            END_IF;

            IF Execute AND NOT MC_MoveVelocityExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_MoveVelocityCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                THIS.UpdateInputs(AxisRef);         
                IF NOT ContinuousUpdate THEN
                    MC_MoveVelocityContinuousUpdate_SV := FALSE;
                END_IF;

                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_MoveVelocityErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;
                    MC_MoveVelocityContinuousUpdate_SV := ContinuousUpdate;
                    State := UINT#110;
                END_IF;
                IF State = UINT#110 THEN
                    Busy := TRUE;            
                    Active := TRUE;   
                    IF Velocity <> 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        _AxisReference^.Telegram111_Out.MDI_TARPOS := DINT#0;
                        _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(ABS(Velocity_) *ScalingConstantRequiredVelocity);
                        _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);                     

                        MC_MoveVelocityVelocity_PV      :=  Velocity_;                  
                        MC_MoveVelocityAcceleration_PV  :=  Acceleration;              
                        MC_MoveVelocityDeceleration_PV  :=  Deceleration;              
                        MC_MoveVelocityJerk_PV          :=  Jerk;                      
                        MC_MoveVelocityDirection_PV     :=  Direction_;                                         
                        State := UINT#111;
                    END_IF;
                END_IF;
                //Writing PNU 12327 Jerk
                IF State = UINT#111 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(MC_MoveVelocityJerk_PV * _AxisReference^.Data.OverrideJerkFactor);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#112;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#786;
                        State := UINT#119;
                    END_IF;
                END_IF;
                IF State = UINT#112 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#113;
                    END_IF;
                END_IF;               
                //Executing movement
                IF State = UINT#113 THEN
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := TRUE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := TRUE;
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := Direction_ = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := Direction_ = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := TRUE;     
   
                    IF _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN      
                        State := UINT#114;
                    END_IF;    
                END_IF;
                IF State = UINT#114 THEN
                    // _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.targetPosReached  AND NOT _AxisReference^.Telegram111_In.ZSW1.axisAccelerates THEN      
                        State := UINT#115;
                    END_IF;    
                END_IF;
                IF State = UINT#115 THEN
                    IF TRUE THEN      
                        State := UINT#116;
                    END_IF;    
                END_IF;
                IF State = UINT#116 THEN
                    InVelocity := TRUE;            
                    IF NOT MC_MoveVelocityContinuousUpdate_SV THEN      
                        State := UINT#117;
                    END_IF;    
                END_IF;
                IF State = UINT#117 THEN
                    InVelocity := TRUE;            
                    MC_MoveVelocityCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#118 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#119 THEN
                    MC_MoveVelocityCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#110 AND State<UINT#117 THEN
                    IF MC_MoveVelocityContinuousUpdate_SV AND (
                        MC_MoveVelocityVelocity_PV      <>  Velocity_ OR                  
                        MC_MoveVelocityAcceleration_PV  <>  Acceleration OR              
                        MC_MoveVelocityDeceleration_PV  <>  Deceleration OR              
                        MC_MoveVelocityJerk_PV          <>  Jerk OR                      
                        MC_MoveVelocityDirection_PV     <>  Direction_ ) THEN
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                        IF NOT _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN    
                            State := UINT#110;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#118;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_MoveVelocityErrorID = WORD#0 THEN
                            MC_MoveVelocityErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#119;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveVelocityCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#118;
                    END_IF;                  
                END_IF;   
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveVelocity_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveVelocityErrorID := WORD#0;
                // MC_MoveVelocityCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoMoveVelocity_Task.RestoreTriggered() AND State>=UINT#110 AND State<=UINT#119 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_MoveVelocityErrorID := WORD#0;
                MC_MoveVelocityCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_MoveVelocityErrorID;
            MC_MoveVelocityExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
        VAR INTERNAL
            MC_TorqueControlExecute_PV					: 	BOOL;				//Execute - previous value
            MC_TorqueControlErrorID					    : 	WORD;
            MC_TorqueControlCycle					    : 	ULINT;
            MC_TorqueControlContinuousUpdate_SV         :   BOOL;
            MC_TorqueControlTorque_PV                   :   LREAL;                    
            MC_TorqueControlTorqueRamp_PV               :   LREAL;                    
            MC_TorqueControlPositionLimit_PV            :   LREAL;                    
            MC_TorqueControlVelocity_PV                 :   LREAL;                    
            MC_TorqueControlAcceleration_PV             :   LREAL;                    
            MC_TorqueControlDeceleration_PV             :   LREAL;                                
            MC_TorqueControlJerk_PV                     :   LREAL;                     
            MC_TorqueControlDirection_PV                :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
        END_VAR
        METHOD PUBLIC OVERRIDE MC_TorqueControl
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
                PositionLimit   :   LREAL;                      //  Position limit
                Velocity        :   LREAL;                      //  Absolute value of the maximum velocity.
                Acceleration    :   LREAL;                      //  Value of the maximum acceleration (acceleration is applicable with same sign of torque and velocity)
                Deceleration    :   LREAL;                      //  Value of the maximum deceleration (deceleration is applicable with opposite signs of torque and velocity)
                Jerk            :   LREAL;                      //  Value of the maximum jerk
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1 of 2 values: PositiveDirection, NegativeDirection or CurrentDirection). Specifies the direction of the torque. (Note: Torque input can be signed value).            
            END_VAR
            VAR_OUTPUT
                InTorque        :   BOOL;                       //  Setpoint value of torque or force equals the commandedvalue
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Active          :   BOOL;                       //  Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       //  ‘Command’ is aborted by another command
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
                Torque_          :   LREAL;
                PositiveDirection_  : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#717,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#739,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#814, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#815, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#816, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#817, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#818, Execute AND Torque = 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#819, Execute AND TorqueRamp <= 0, eAxoMessageCategory#ProgrammingError);
            
            IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection THEN
                Torque_ := Torque;
            ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection THEN
                Torque_ := -1 * Torque;
            ELSE
                RETURN;
            END_IF; 
            PositiveDirection_ := Torque_ > 0;                        

            IF THIS.AxoTorqueControl_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_TorqueControl;
            END_IF;

            IF Execute AND NOT MC_TorqueControlExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_TorqueControlCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                THIS.UpdateInputs(AxisRef);         
                IF NOT ContinuousUpdate THEN
                    MC_TorqueControlContinuousUpdate_SV := FALSE;
                END_IF;

                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_TorqueControlErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;
                    MC_TorqueControlContinuousUpdate_SV := ContinuousUpdate;
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration > 0 AND Jerk > 0 AND Torque <> 0 AND TorqueRamp > 0 THEN
                        _AxisReference^.Telegram111_Out.MDI_TARPOS :=  TO_DINT(PositionLimit * ScalingConstantRequiredPosition);
                        _AxisReference^.Telegram111_Out.MDI_VELOCITY :=  TO_DINT(Velocity *ScalingConstantRequiredVelocity);
                        _AxisReference^.Telegram111_Out.MDI_ACC :=  TO_UINT(Acceleration *ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Telegram111_Out.MDI_DEC :=  TO_UINT(Deceleration *ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);                     

                        MC_TorqueControlPositionLimit_PV :=  PositionLimit;                  
                        MC_TorqueControlVelocity_PV      :=  Velocity;                  
                        MC_TorqueControlAcceleration_PV  :=  Acceleration;              
                        MC_TorqueControlDeceleration_PV  :=  Deceleration;              
                        MC_TorqueControlJerk_PV          :=  Jerk;                      
                        MC_TorqueControlDirection_PV     :=  Direction;                                         
                        MC_TorqueControlTorque_PV        :=  Torque;                      
                        MC_TorqueControlTorqueRamp_PV    :=  TorqueRamp;          
                        State := UINT#120;
                    END_IF;
                END_IF;
                IF State = UINT#120 THEN
                    Busy := TRUE;            
                    Active := TRUE;   
                    IF PositiveDirection_ AND THIS.ActualPosition >= MC_TorqueControlPositionLimit_PV THEN
                        State := UINT#129;
                        MC_TorqueControlErrorID := TO_WORD(823);
                    ELSIF NOT PositiveDirection_ AND THIS.ActualPosition <= MC_TorqueControlPositionLimit_PV THEN
                        State := UINT#129;
                        MC_TorqueControlErrorID := TO_WORD(824);
                    ELSE
                        State := UINT#121;
                    END_IF;
                END_IF;
                //Writing PNU 12168 Clamping torque
                IF State = UINT#121 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12168;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(MC_TorqueControlTorque_PV * ScalingConstantRequiredTorque);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#122;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_TorqueControlErrorID := WORD#820;
                        State := UINT#129;
                    END_IF;
                END_IF;
                IF State = UINT#122 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#123;
                    END_IF;
                END_IF;               
                //Writing PNU 12327 Jerk
                IF State = UINT#123 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12327;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := TO_REAL(MC_TorqueControlJerk_PV * _AxisReference^.Data.OverrideJerkFactor);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#124;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_TorqueControlErrorID := WORD#821;
                        State := UINT#129;
                    END_IF;
                END_IF;
                IF State = UINT#124 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#125;
                    END_IF;
                END_IF;               
                //Executing movement
                IF State = UINT#125 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := TRUE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := TRUE;
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := TRUE;     
   
                    IF _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN      
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                        State := UINT#126;
                    END_IF;    
                END_IF;
                IF State = UINT#126 THEN
                    InTorque :=  _AxisReference^.Telegram111_In.POS_ZSW2.%X13;            
                    IF NOT MC_TorqueControlContinuousUpdate_SV THEN      
                        State := UINT#127;
                    END_IF;    
                END_IF;
                IF State = UINT#127 THEN
                    InTorque :=  _AxisReference^.Telegram111_In.POS_ZSW2.%X13;            
                    MC_TorqueControlCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#128 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#129 THEN
                    MC_TorqueControlCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         

                IF (State=UINT#126 OR State =UINT#127) AND _AxisReference^.Telegram111_In.ZSW1.targetPosReached THEN
                    MC_TorqueControlErrorID := TO_WORD(822);
                    State := UINT#129;
                END_IF;
                
                IF State>=UINT#120 AND State<UINT#127 THEN
                    IF MC_TorqueControlContinuousUpdate_SV AND (
                        MC_TorqueControlTorque_PV        <>  Torque OR                  
                        MC_TorqueControlTorqueRamp_PV    <>  TorqueRamp OR                  
                        MC_TorqueControlPositionLimit_PV <>  PositionLimit OR                  
                        MC_TorqueControlVelocity_PV      <>  Velocity OR                  
                        MC_TorqueControlAcceleration_PV  <>  Acceleration OR              
                        MC_TorqueControlDeceleration_PV  <>  Deceleration OR              
                        MC_TorqueControlJerk_PV          <>  Jerk OR                      
                        MC_TorqueControlDirection_PV     <>  Direction ) THEN
                        _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE;        
                        IF NOT _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated THEN    
                            State := UINT#120;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#128;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_TorqueControlErrorID = WORD#0 THEN
                            MC_TorqueControlErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#129;
                    ELSIF _AxisReference^.Data.Cycle <> MC_TorqueControlCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#128;
                    END_IF;                  
                END_IF;   
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoTorqueControl_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_TorqueControlErrorID := WORD#0;
                // MC_TorqueControlCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF THIS.AxoTorqueControl_Task.RestoreTriggered() AND State>=UINT#120 AND State<=UINT#129 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                MC_TorqueControlErrorID := WORD#0;
                MC_TorqueControlCycle := ULINT#0;     
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_TorqueControlErrorID;
            MC_TorqueControlExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
        VAR INTERNAL
            MC_SetPositionExecute_PV				: 	BOOL;				//Execute - previous value
            MC_SetPositionErrorID					: 	WORD;
            MC_SetPositionCycle					    : 	ULINT;						
            MC_SetPositionActualPosition            : 	LINT;						
        END_VAR  
        METHOD PUBLIC OVERRIDE MC_SetPosition
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start setting position in axis
                Position        :   LREAL;                       //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
                Relative        :   BOOL;                       //  ‘Relative’ distance if True, ‘Absolute’ position if False (= Default)
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Position’ has new value
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#718,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF THIS.AxoSetPosition_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_SetPosition;
            END_IF;

            IF Execute AND NOT MC_SetPositionExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_SetPositionCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 				
                THIS.UpdateInputs(AxisRef);         
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_SetPositionErrorID := WORD#16#0000;
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                    _AxisReference^.Telegram111_Out.STW1.activateTraversing := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                    _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                    _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                    _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#130;
                END_IF;
                //Read  PNU 11735 Homing mode
                IF State = UINT#130 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11735;//mode
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11735 := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#131;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#787;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#131 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#132;
                    END_IF;
                END_IF;    
                //Write  PNU 12681 deactivate save zero offset
                IF State = UINT#132 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 12681;//deactivate save zero offset
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBOOL := FALSE;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#133;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#789;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#133 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#134;
                    END_IF;
                END_IF;    
                //Read PNU 11203 Move to axis zero after homming
                IF State = UINT#134 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11203;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11203 := Parametrization.Outputs.ValueReadBool;
                        State := UINT#135;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#790;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#135 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#136;
                    END_IF;
                END_IF; 
                //Read PNU 11734 Axis zero point offset
                IF State = UINT#136 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 11734;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        PNU_11734 := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#137;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#791;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#137 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#138;
                    END_IF;
                END_IF; 
                //Write PNU 11203 deactivate Move to axis zero after homming
                IF State = UINT#138 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11203;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBOOL := FALSE;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#139;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#792;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#139 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    MC_SetPositionActualPosition :=  TO_LINT(ActualPosition * -10000000000.0);
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#140;
                    END_IF;
                END_IF;   
                //Write PNU 11734 Axis zero point offset
                IF State = UINT#140 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11734;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Relative THEN
                        Parametrization.Inputs.ValueWriteLINT := MC_SetPositionActualPosition + TO_LINT(Position * -10000000000.0);
                    ELSE
                        Parametrization.Inputs.ValueWriteLINT := TO_LINT(Position * -10000000000.0);
                    END_IF;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#141;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#793;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#141 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#142;
                    END_IF;
                END_IF; 
                //Write  PNU 11735 Homing mode
                IF State = UINT#142 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11735;//mode
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := TO_LINT(37);
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#143;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#794;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#143 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#144;
                    END_IF;
                END_IF;    
                //Homing started
                IF State = UINT#144 THEN
                    Busy := TRUE;            
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := TRUE; 
                    IF  NOT _AxisReference^.Telegram111_In.ZSW1.targetPosReached AND NOT _AxisReference^.Telegram111_In.ZSW1.homePosSet THEN
                        State := UINT#145;
                    END_IF;
                END_IF;                                       
                IF State = UINT#145 THEN
                    Busy := TRUE;            
                    IF _AxisReference^.Telegram111_In.ZSW1.targetPosReached AND _AxisReference^.Telegram111_In.ZSW1.homePosSet THEN
                        _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                        State := UINT#146;
                    END_IF;
                END_IF;  
                //Write PNU 11203 Move to axis zero after homming
                IF State = UINT#146 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11203;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBool := PNU_11203;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#147;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#795;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#147 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#148;
                    END_IF;
                END_IF; 
                //Write PNU 11734 Axis zero point offset
                IF State = UINT#148 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11734;//Move to axis zero after homming
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := PNU_11734;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                         State := UINT#149;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_SetPositionErrorID := WORD#796;
                        State := UINT#159;
                    END_IF;
                END_IF;
                IF State = UINT#149 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#150;
                    END_IF;
                END_IF; 
                //Write PNU 11735 homming mode
                IF State = UINT#150 THEN
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 11735;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := PNU_11735;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#151;
                   END_IF;
                   IF Parametrization.Outputs.Error THEN 
                       MC_SetPositionErrorID := WORD#797;
                       State := UINT#159;
                   END_IF;
                END_IF;
                IF State = UINT#151 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#152;
                    END_IF;
                END_IF; 
                IF State = UINT#152 THEN
                    Busy := TRUE;            
                    IF TRUE THEN
                        State := UINT#153;
                    END_IF;
                END_IF; 
                IF State = UINT#153 THEN
                    Busy := TRUE;            
                    IF TRUE THEN
                        State := UINT#154;
                    END_IF;
                END_IF; 
                IF State = UINT#154 THEN
                    Busy := TRUE;            
                    IF TRUE THEN
                        State := UINT#155;
                    END_IF;
                END_IF; 
                IF State = UINT#155 THEN
                    Busy := TRUE;            
                    IF TRUE THEN
                        State := UINT#156;
                    END_IF;
                END_IF; 
                IF State = UINT#156 THEN
                    Busy := TRUE;            
                    IF TRUE THEN
                        State := UINT#157;
                    END_IF;
                END_IF; 
                IF State = UINT#157 THEN
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE;
                    Done := TRUE;            
                    MC_SetPositionCycle := ULINT#0;     
                END_IF;    
                IF State = UINT#158 THEN
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE;
                END_IF;         
                IF State = UINT#159 THEN
                    _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE;
                    MC_SetPositionCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#130 AND State<UINT#157 THEN
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#158;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        IF MC_SetPositionErrorID = WORD#0 THEN
                            MC_SetPositionErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        END_IF;
                        State := UINT#159;
                    ELSIF _AxisReference^.Data.Cycle <> MC_SetPositionCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#158;
                    END_IF;                  
                END_IF;                  
            END_IF;

            IF THIS.AxoSetPosition_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_SetPositionErrorID := WORD#0;
                // MC_SetPositionCycle := ULINT#0;     
                Parametrization.Inputs.Enable := FALSE;
                Parametrization.Inputs.ReadWrite   := FALSE;
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;
            IF THIS.AxoSetPosition_Task.RestoreTriggered() AND State>=UINT#20 AND State<=UINT#59 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_SetPositionErrorID := WORD#0;
                MC_SetPositionCycle := ULINT#0;     
                Parametrization.Inputs.Enable := FALSE;
                Parametrization.Inputs.ReadWrite   := FALSE;
                State := UINT#0;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;     

            ErrorID := MC_SetPositionErrorID;
            MC_SetPositionExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and jerk of the motion.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_SetOverride
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
                VelocityFactor  :   LREAL;                      //  New override factor for the velocity
                AccelerationFactor:   LREAL;                    //  New override factor for the acceleration/deceleration
                JerkFactor      :   LREAL;                      //  New override factor for the jer            
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#719,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#798, Enable AND  (VelocityFactor <= 0.0 OR  VelocityFactor >= 2.0), eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#799, Enable AND  (AccelerationFactor <= 0.0 OR  AccelerationFactor > 1.0), eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#800, Enable AND  (JerkFactor <= 0.0 OR JerkFactor > 1.0), eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable THEN
                Busy := TRUE;
                IF VelocityFactor <= 0.0 OR  VelocityFactor >= 2.0 OR AccelerationFactor <= 0.0 OR  AccelerationFactor > 1.0 OR JerkFactor <= 0.0 OR  JerkFactor > 1.0 THEN
                    Error := TRUE;
                ELSE             
                    _AxisReference^.Data.OverrideVelocityFactor := VelocityFactor;  
                    _AxisReference^.Data.OverrideAccelerationFactor := AccelerationFactor;
                    _AxisReference^.Data.OverrideJerkFactor := JerkFactor;    
                    _AxisReference^.Telegram111_Out.Override_ := TO_WORD(TO_INT(16384.0/VelocityFactor));
                    THIS.UpdateOutputs(AxisRef);         
                    Enabled	:= TRUE;
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        VAR INTERNAL 
            MC_ReadParameterEnable_PV       : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadParameterErrorID         : 	WORD;
            MC_ReadParameterCycle			: 	ULINT;
            MC_ReadParameterValue			: 	LINT;
            MC_ReadParameterValid			: 	BOOL;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   LINT;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#720,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;
            
            IF Enable AND NOT MC_ReadParameterEnable_PV AND State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadParameter;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadParameterErrorID := WORD#16#0000;         
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#160;
                END_IF;
                IF State = UINT#160 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := TO_INT(ParameterNumber);
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        MC_ReadParameterValid := TRUE;
                        MC_ReadParameterValue := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#161;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#801;
                        State := UINT#169;
                    END_IF;
                END_IF;
                IF State = UINT#161 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#160;
                    END_IF;
                END_IF;               
                IF State = UINT#169 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#160 AND State<UINT#167 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#169;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadParameterEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadParameterErrorID := WORD#0;
                MC_ReadParameterCycle := ULINT#0;  
                MC_ReadParameterValid := FALSE;
                MC_ReadParameterValue := LINT#0;   
                State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadParameterErrorID;
            Valid := MC_ReadParameterValid;
            Value := MC_ReadParameterValue;
            MC_ReadParameterEnable_PV := Enable;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype REAL.
        ///<summary>
        VAR INTERNAL
            MC_ReadRealParameterEnable_PV       : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadRealParameterErrorID         : 	WORD;
            MC_ReadRealParameterCycle			: 	ULINT;
            MC_ReadRealParameterValue			: 	REAL;
            MC_ReadRealParameterValid			: 	BOOL;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   REAL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#721,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;
            IF Enable AND NOT MC_ReadRealParameterEnable_PV AND State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadRealParameter;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadRealParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadRealParameterErrorID := WORD#16#0000;
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#170;
                END_IF;
                IF State = UINT#170 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := TO_INT(ParameterNumber);
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        MC_ReadRealParameterValid := TRUE;
                        MC_ReadRealParameterValue := Parametrization.Outputs.ValueReadREAL;
                        State := UINT#171;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#802;
                        State := UINT#179;
                    END_IF;
                END_IF;
                IF State = UINT#171 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#170;
                    END_IF;
                END_IF;               
                IF State = UINT#179 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#170 AND State<UINT#177 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadRealParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#179;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadRealParameterEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadRealParameterErrorID := WORD#0;
                MC_ReadRealParameterCycle := ULINT#0;  
                MC_ReadRealParameterValid := FALSE;
                MC_ReadRealParameterValue := REAL#0.0;   
                State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadRealParameterErrorID;
            Valid := MC_ReadRealParameterValid;
            Value := MC_ReadRealParameterValue;
            MC_ReadRealParameterEnable_PV := Enable;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        ///<summary>
        VAR INTERNAL 
            MC_ReadBoolParameterEnable_PV       : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadBoolParameterErrorID         : 	WORD;
            MC_ReadBoolParameterCycle			: 	ULINT;
            MC_ReadBoolParameterValue			: 	BOOL;
            MC_ReadBoolParameterValid			: 	BOOL;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            RETURN;

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#722,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadBoolParameterEnable_PV AND State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadBoolParameter;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadBoolParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadBoolParameterErrorID := WORD#16#0000;
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#180;
                END_IF;
                IF State = UINT#180 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := TO_INT(ParameterNumber);
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        MC_ReadBoolParameterValid := TRUE;
                        MC_ReadBoolParameterValue := Parametrization.Outputs.ValueReadBOOL;
                        State := UINT#181;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#801;
                        State := UINT#189;
                    END_IF;
                END_IF;
                IF State = UINT#181 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#180;
                    END_IF;
                END_IF;               
                IF State = UINT#189 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#180 AND State<UINT#187 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadBoolParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#189;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadBoolParameterEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadBoolParameterErrorID := WORD#0;
                MC_ReadBoolParameterCycle := ULINT#0;  
                MC_ReadBoolParameterValid := FALSE;
                MC_ReadBoolParameterValue := FALSE;   
                State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadBoolParameterErrorID;
            Valid := MC_ReadBoolParameterValid;
            Value := MC_ReadBoolParameterValue;
            MC_ReadBoolParameterEnable_PV := Enable;

        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter.
        ///<summary>
        VAR INTERNAL
            MC_WriteParameterExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteParameterErrorID        : 	WORD;
            MC_WriteParameterCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   LINT;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#723,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF THIS.AxoWriteParameter_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteParameter;
            END_IF;

            IF Execute AND NOT MC_WriteParameterExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#190;
                END_IF;
                IF State = UINT#190 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := TO_INT(ParameterNumber);
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteLINT := Value;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#191;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_WriteParameterErrorID := WORD#804;
                        State := UINT#199;
                    END_IF;
                END_IF;
                IF State = UINT#191 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#197;
                    END_IF;
                END_IF;               
                IF State = UINT#197 THEN
                    Done := TRUE;
                    MC_WriteParameterCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#199 THEN
                    MC_WriteParameterCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#190 AND State<UINT#197 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#199;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteParameter_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteParameterErrorID := WORD#0;
                // MC_WriteParameterCycle := ULINT#0;     
                State := UINT#0;
            END_IF;

            IF THIS.AxoWriteParameter_Task.RestoreTriggered() AND State>=UINT#190 AND State<=UINT#199 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteParameterErrorID := WORD#0;
                MC_WriteParameterCycle := ULINT#0;     
                State := UINT#0;
            END_IF;     

            ErrorID := MC_WriteParameterErrorID;
            MC_WriteParameterExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type Real.
        ///<summary>
        VAR INTERNAL
            MC_WriteRealParameterExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteRealParameterErrorID        : 	WORD;
            MC_WriteRealParameterCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#724,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF THIS.AxoWriteRealParameter_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteRealParameter;
            END_IF;

            IF Execute AND NOT MC_WriteRealParameterExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteRealParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#200;
                END_IF;
                IF State = UINT#200 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := TO_INT(ParameterNumber);
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteREAL := Value;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#201;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_WriteRealParameterErrorID := WORD#805;
                        State := UINT#209;
                    END_IF;
                END_IF;
                IF State = UINT#201 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#207;
                    END_IF;
                END_IF;               
                IF State = UINT#207 THEN
                    Done := TRUE;
                    MC_WriteRealParameterCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#209 THEN
                    MC_WriteRealParameterCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#200 AND State<UINT#207 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteRealParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#209;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteRealParameter_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteRealParameterErrorID := WORD#0;
                // MC_WriteRealParameterCycle := ULINT#0;     
                State := UINT#0;
            END_IF;

            IF THIS.AxoWriteRealParameter_Task.RestoreTriggered() AND State>=UINT#200 AND State<=UINT#209 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteRealParameterErrorID := WORD#0;
                MC_WriteRealParameterCycle := ULINT#0;     
                State := UINT#0;
            END_IF;     

            ErrorID := MC_WriteRealParameterErrorID;
            MC_WriteRealParameterExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type BOOL.
        ///<summary>
        VAR INTERNAL
            MC_WriteBoolParameterExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteBoolParameterErrorID        : 	WORD;
            MC_WriteBoolParameterCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#725,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF THIS.AxoWriteBoolParameter_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteBoolParameter;
            END_IF;

            IF Execute AND NOT MC_WriteBoolParameterExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteBoolParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#210;
                END_IF;
                IF State = UINT#210 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := TO_INT(ParameterNumber);
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBOOL := Value;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#211;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_WriteBoolParameterErrorID := WORD#805;
                        State := UINT#219;
                    END_IF;
                END_IF;
                IF State = UINT#211 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#217;
                    END_IF;
                END_IF;               
                IF State = UINT#217 THEN
                    Done := TRUE;
                    MC_WriteBoolParameterCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#219 THEN
                    MC_WriteBoolParameterCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#210 AND State<UINT#217 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteBoolParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#219;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteBoolParameter_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteBoolParameterErrorID := WORD#0;
                // MC_WriteBoolParameterCycle := ULINT#0;     
                State := UINT#0;
            END_IF;

            IF THIS.AxoWriteBoolParameter_Task.RestoreTriggered() AND State>=UINT#210 AND State<=UINT#219 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteBoolParameterErrorID := WORD#0;
                MC_WriteBoolParameterCycle := ULINT#0;     
                State := UINT#0;
            END_IF;     

            ErrorID := MC_WriteBoolParameterErrorID;
            MC_WriteBoolParameterExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        /// It provides the value of the referenced input (BOOL).
        ///<summary>
        VAR INTERNAL
            MC_ReadDigitalInputEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadDigitalInputErrorID          : 	WORD;
            MC_ReadDigitalInputCycle			: 	ULINT;
            MC_ReadDigitalInputValue			: 	BOOL;
            MC_ReadDigitalInputValid			: 	BOOL;					
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadDigitalInput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected input signal continuously while enabled
                InputNumber     :   INT;                        //  Selects the input. Can be part of MC_INPUT_REF, if only one single input is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected input signal
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#726,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadDigitalInputEnable_PV AND State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadDigitalInput;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadDigitalInputCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadDigitalInputErrorID := WORD#16#0000;         
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#220;
                END_IF;
                IF State = UINT#220 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 2888;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        MC_ReadDigitalInputValid := TRUE;
                        MC_ReadDigitalInputValue := GetBit(TO_LWORD(Parametrization.Outputs.ValueReadLINT), TO_USINT(InputNumber));
                        State := UINT#221;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#807;
                        State := UINT#229;
                    END_IF;
                END_IF;
                IF State = UINT#221 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#220;
                    END_IF;
                END_IF;               
                IF State = UINT#229 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#220 AND State<UINT#227 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadDigitalInputCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#229;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadDigitalInputEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadDigitalInputErrorID := WORD#0;
                MC_ReadDigitalInputCycle := ULINT#0;  
                MC_ReadDigitalInputValid := FALSE;
                MC_ReadDigitalInputValue := FALSE;   
                State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadDigitalInputErrorID;
            Valid := MC_ReadDigitalInputValid;
            Value := MC_ReadDigitalInputValue;
            MC_ReadDigitalInputEnable_PV := Enable;	          
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
        VAR INTERNAL
            MC_ReadDigitalOutputEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadDigitalOutputErrorID          : 	WORD;
            MC_ReadDigitalOutputCycle			: 	ULINT;
            MC_ReadDigitalOutputValue			: 	BOOL;
            MC_ReadDigitalOutputValid			: 	BOOL;					
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected output signal
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#727,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadDigitalOutputEnable_PV AND State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadDigitalOutput;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadDigitalOutputCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadDigitalOutputErrorID := WORD#16#0000;         
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#230;
                END_IF;
                IF State = UINT#230 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 2888;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        MC_ReadDigitalOutputValid := TRUE;
                        MC_ReadDigitalOutputValue := GetBit(TO_LWORD(Parametrization.Outputs.ValueReadLINT), TO_USINT(OutputNumber));
                        State := UINT#231;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#809;
                        State := UINT#239;
                    END_IF;
                END_IF;
                IF State = UINT#231 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#230;
                    END_IF;
                END_IF;               
                IF State = UINT#239 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#230 AND State<UINT#237 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadDigitalOutputCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#239;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadDigitalOutputEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadDigitalOutputErrorID := WORD#0;
                MC_ReadDigitalOutputCycle := ULINT#0;  
                MC_ReadDigitalOutputValid := FALSE;
                MC_ReadDigitalOutputValue := FALSE;   
                State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadDigitalOutputErrorID;
            Valid := MC_ReadDigitalOutputValid;
            Value := MC_ReadDigitalOutputValue;
            MC_ReadDigitalOutputEnable_PV := Enable;	          
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        VAR INTERNAL
            MC_WriteDigitalOutputExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteDigitalOutputErrorID        : 	WORD;
            MC_WriteDigitalOutputCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the selected output
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
                Value           :   BOOL;                       //  The value of the selected output signal
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Writing of the output signal value is done
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
                Valid_          :   BOOL;
                Error_          :   BOOL;
                ErrorID_        :   WORD; 
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#728,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF THIS.AxoWriteDigitalOutput_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteDigitalOutput;
            END_IF;

            IF Execute AND NOT MC_WriteDigitalOutputExecute_PV AND State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteDigitalOutputCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#240;
                    //Remove after implementation on the drive side
                    State := UINT#249;
                    MC_WriteDigitalOutputErrorID := WORD#810;
                END_IF;
                IF State = UINT#240 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := TRUE;
                    Parametrization.Inputs.ParameterNo := 0;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    Parametrization.Inputs.ValueWriteBOOL := Value;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        State := UINT#241;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_WriteDigitalOutputErrorID := WORD#811;
                        State := UINT#249;
                    END_IF;
                END_IF;
                IF State = UINT#241 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#247;
                    END_IF;
                END_IF;               
                IF State = UINT#247 THEN
                    Done := TRUE;
                    MC_WriteDigitalOutputCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#249 THEN
                    MC_WriteDigitalOutputCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#240 AND State<UINT#247 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteDigitalOutputCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#249;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteDigitalOutput_Task.DoneReached() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteDigitalOutputErrorID := WORD#0;
                // MC_WriteDigitalOutputCycle := ULINT#0;     
                State := UINT#0;
            END_IF;

            IF THIS.AxoWriteDigitalOutput_Task.RestoreTriggered() AND State>=UINT#240 AND State<=UINT#249 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteDigitalOutputErrorID := WORD#0;
                MC_WriteDigitalOutputCycle := ULINT#0;     
                State := UINT#0;
            END_IF;     

            ErrorID := MC_WriteDigitalOutputErrorID;
            MC_WriteDigitalOutputExecute_PV := Execute;

        END_METHOD

        ///<summary>
        /// This method returns the actual position.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualPosition 
             VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Position        :   LREAL;                       //  New absolute position (in axis’ unit [u])
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#729,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable THEN
                THIS.UpdateInputs(AxisRef);         
                Valid := TRUE;
                Position := THIS.ActualPosition;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual velocity as long as ‘Enable’ is set. ‘Valid’ is true when the 
        /// dataoutput ‘Velocity’ is valid. If ‘Enable’ is Reset, the data loses its validity, and all outputs are reset,
        /// no matter if new data is available.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Velocity        :   LREAL;                       //  The value of the actual velocity (in axis’ unit [u/s])
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#730,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable THEN
                THIS.UpdateInputs(AxisRef);         
                Valid := TRUE;
                Velocity := THIS.ActualVelocity;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual torque or force as long as ‘Enable’ is set. ‘Valid’ is true when the
        /// data-output ‘Torque’ is valid. If ‘Enable’ is Reset, the data loses its validity, and ‘Valid’ is also reset, 
        /// no matter if new data is available.        
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualTorque
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Torque          :   LREAL;                       //  The value of the actual torque or force (in technical units)
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#731,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;
            IF Enable THEN
                THIS.UpdateInputs(AxisRef);         
                Valid := TRUE;
                Torque := THIS.ActualTorque;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the state diagram of the axis
        ///<summary>
        VAR INTERNAL
            MC_ReadStatusEnable_PV				: 	BOOL := FALSE;		//Enable - previous value                                                    
            MC_ReadStatusDone_PV				:	BOOL := FALSE;		//Done - previous value                                                      
            MC_ReadStatusStateNumber			: 	INT; 				//Call number of the method MC_ReadRealParameter                             
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadStatus
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable              :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid               :   BOOL;                       //  A valid output is available at the method
                Busy                :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error               :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID             :   WORD;                       //  Error identification
                ErrorStop           :   BOOL;                       //  See state diagram
                Disabled            :   BOOL;                       //  See state diagram
                Stopping            :   BOOL;                       //  See state diagram
                Homing              :   BOOL;                       //  See state diagram
                Standstill          :   BOOL;                       //  See state diagram
                DiscreteMotion      :   BOOL;                       //  See state diagram
                ContinuousMotion     :   BOOL;                       //  See state diagram
                SynchronizedMotion  : BOOL;                       //  See state diagram
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#732,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;
            
            IF Enable THEN
                THIS.UpdateInputs(AxisRef);         
                Valid := TRUE;
                Error                   := _AxisReference^.Telegram111_In.ZSW1.faultPresent;
                ErrorID                 := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                ErrorStop               := DriveState = AXOpen.Components.Drives.eAxoDriveState#ErrorStop;;                         
                Disabled                := DriveState = AXOpen.Components.Drives.eAxoDriveState#Disabled;
                Stopping                := DriveState = AXOpen.Components.Drives.eAxoDriveState#Stopping;
                Homing                  := DriveState = AXOpen.Components.Drives.eAxoDriveState#Homing;
                Standstill              := DriveState = AXOpen.Components.Drives.eAxoDriveState#Standstill;
                DiscreteMotion          := DriveState = AXOpen.Components.Drives.eAxoDriveState#DiscreteMotion;
                ContinuousMotion        := DriveState = AXOpen.Components.Drives.eAxoDriveState#ContinuousMotion;
                SynchronizedMotion      := DriveState = AXOpen.Components.Drives.eAxoDriveState#SynchronizedMotion;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        ///<summary>
        VAR INTERNAL
            MC_ReadMotionStateEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadMotionStateErrorID          : 	WORD;
            MC_ReadMotionStateCycle			: 	ULINT;
            MC_ReadMotionStateValue			: 	LINT;
            MC_ReadMotionStateValid			: 	BOOL;					
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadMotionState
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                Source          :   AXOpen.Components.Abstractions.Drives.eAxoSource;                 //  Defines the source of the relevant data: CommandedValue;SetValue, ActualValue.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                ConstantVelocity:   BOOL;                       //  Velocity is constant. Velocity may be 0. For the actual value a window is applicable (window is vendor specific)
                Accelerating    :   BOOL;                       //  Increasing the absolute value of the velocity
                Decelerating    :   BOOL;                       //  Decreasing the absolute value of the velocity
                DirectionPositive:  BOOL;                       //  Signals that the position is increasing
                DirectionNegative:  BOOL;                       //  Signals that the position is decreasing
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#733,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;
            IF Enable THEN
                THIS.UpdateInputs(AxisRef);         
                Valid := TRUE;
                Error                   := _AxisReference^.Telegram111_In.ZSW1.faultPresent;
                ErrorID                 := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                ConstantVelocity        := FALSE;
                Accelerating            := _AxisReference^.Telegram111_In.ZSW1.axisAccelerates;
                Decelerating            := _AxisReference^.Telegram111_In.ZSW1.axisDecelerates;
                DirectionPositive       := _AxisReference^.Telegram111_In.POS_ZSW2.%X4;
                DirectionNegative       := _AxisReference^.Telegram111_In.POS_ZSW2.%X5;
             END_IF;
        END_METHOD

        ///<summary>
        /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        /// and certain status information.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadAxisInfo
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable              :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid               :   BOOL;                       //  A valid output is available at the method
                Busy                :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error               :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID             :   WORD;                       //  Error identification
                HomeAbsSwitch       :   BOOL;                       //  Digital home switch input is active
                LimitSwitchPos      :   BOOL;                       //  Positive hardware end switch is active
                LimitSwitchNeg      :   BOOL;                       //  Negative hardware end switch is active
                Simulation          :   BOOL;                       //  Axis is in simulation mode (e.g. motor is simulated)
                CommunicationReady  :   BOOL;                         //  “Network” is initialized and ready for communication
                ReadyForPowerOn     :   BOOL;                       //  Drive is ready to be enabled (power on)
                PowerOn             :   BOOL;                       //  If TRUE shows that the power stage is switched ON
                IsHomed             :   BOOL;                       //  The absolute reference position is known for the axis (axis is homed)
                AxisWarning         :   BOOL;                       //  Warning(s) on the axis is present
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#734,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable THEN
                THIS.UpdateInputs(AxisRef);         
                Valid := TRUE;
                Error                   := _AxisReference^.Telegram111_In.ZSW1.faultPresent;
                ErrorID                 := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                HomeAbsSwitch           := FALSE;
                LimitSwitchPos          := _AxisReference^.Telegram111_In.POS_ZSW1.%X9;
                LimitSwitchNeg          := _AxisReference^.Telegram111_In.POS_ZSW1.%X8;
                Simulation              := FALSE;          
                CommunicationReady      := FALSE;
                ReadyForPowerOn         := _AxisReference^.Telegram111_In.ZSW1.readyForSwitchOn;
                PowerOn                 := _AxisReference^.Telegram111_In.ZSW1.operationEnabled;
                IsHomed                 := _AxisReference^.Telegram111_In.ZSW1.homePosSet;
                AxisWarning             := _AxisReference^.Telegram111_In.ZSW1.warningActive;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        ///<summary>
        VAR INTERNAL
            MC_ReadAxisErrorEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadAxisErrorErrorID          : 	WORD;
            MC_ReadAxisErrorCycle			: 	ULINT;
            MC_ReadAxisErrorValue			: 	LINT;
            MC_ReadAxisErrorValid			: 	BOOL;					
            LastMessageCode :   ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadAxisError
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                AxisErrorID     :   DWORD;                      //  The value of the axis error. These values are vendor specific
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
                _category  :   AXOpen.Messaging.eAxoMessageCategory;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#735,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadAxisErrorEnable_PV AND State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadAxisError;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadAxisErrorCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                THIS.UpdateInputs(AxisRef);         
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadAxisErrorErrorID := WORD#16#0000;         
                    Parametrization.Inputs.Enable := FALSE;
                    State := UINT#310;
                END_IF;
                IF State = UINT#310 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := TRUE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    Parametrization.Inputs.ParameterNo := 12306;
                    Parametrization.Inputs.Subindex    := 0;
                    Parametrization.Inputs.AxisNo  := BYTE#1;
                    Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
                    IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
                        MC_ReadAxisErrorValid := TRUE;
                        MC_ReadAxisErrorValue := Parametrization.Outputs.ValueReadLINT;
                        State := UINT#311;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        MC_MoveVelocityErrorID := WORD#813;
                        State := UINT#319;
                    END_IF;
                END_IF;
                IF State = UINT#311 THEN
                    Busy := TRUE;            
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#310;
                    END_IF;
                END_IF;               
                IF State = UINT#319 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#310 AND State<UINT#317 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadAxisErrorCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#319;
                    END_IF;                  
                END_IF;  
                THIS.UpdateOutputs(AxisRef);          
            END_IF;

            IF NOT Enable AND MC_ReadAxisErrorEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadAxisErrorErrorID := WORD#0;
                MC_ReadAxisErrorCycle := ULINT#0;  
                MC_ReadAxisErrorValid := FALSE;
                MC_ReadAxisErrorValue := LINT#0;   
                State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadAxisErrorErrorID;
            Valid := MC_ReadAxisErrorValid;
            MC_ReadAxisErrorEnable_PV := Enable;	          

            Messenger.ActivateOnCondition(LastMessageCode,Enable AND Valid AND LastMessageCode = TO_ULINT(MC_ReadAxisErrorValue), eAxoMessageCategory#Error);
            IF NOT Messenger.IsActive THEN
                LastMessageCode := TO_ULINT(MC_ReadAxisErrorValue);
            END_IF;
        END_METHOD

        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
        VAR INTERNAL
            MC_ResetExecute_PV					: 	BOOL := FALSE;		//Execute - previous value           
            MC_ResetPower_PV					: 	BOOL := FALSE;		//Execute - previous value           
        END_VAR    
        METHOD PUBLIC OVERRIDE MC_Reset
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Resets all internal axis-related error
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Standstill’ or ‘Disabled’ state is reached
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#736,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Execute AND NOT MC_ResetExecute_PV THEN
                _AxisReference^.Telegram111_Out.STW1.StartHoming := FALSE; 
                _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
                _AxisReference^.Telegram111_Out.POS_STW1.PosModulo := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.NegModulo := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.SetupMode := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
                _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
                _AxisReference^.Telegram111_Out.STW2.TravelToFixStop := FALSE;
                Parametrization.Inputs.Enable := FALSE;
                State := UINT#320;
            END_IF;

            IF Execute THEN
                THIS.UpdateInputs(AxisRef);         

                IF State = UINT#320 THEN
                    Busy := TRUE;
                    THIS.Restore();
                    THIS.AxoReset_Task.Invoke();
                    State := UINT#321;
                END_IF;
                IF State = UINT#321 THEN
                    Busy := TRUE;
                    MC_ResetPower_PV := AxoPower_Task.IsSwitchedOn();
                    State := UINT#322;
                END_IF;
                IF State = UINT#322 THEN
                    Busy := TRUE;
                    THIS.AxoPower_Task.SwitchOff();
                    IF THIS.AxoPower_Task.IsSwitchedOff() THEN
                        State := UINT#323;
                    END_IF;                
                END_IF;                
                IF State = UINT#323 THEN
                    Busy := TRUE;
                    _AxisReference^.Telegram111_Out.STW1.acknowledgeFault := TRUE;
                    State := UINT#324;
                END_IF;
                IF State = UINT#324 THEN
                    Busy := TRUE;
                    IF  NOT _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        State := UINT#325;
                    END_IF;
                    IF  _AxisReference^.Telegram111_In.ZSW1.faultPresent  AND THIS.AxoReset_Task.Duration >=T#2S THEN
                        State := UINT#329;
                    END_IF;
                END_IF;
                IF State = UINT#325 THEN
                    Busy := TRUE;
                    IF MC_ResetPower_PV THEN
                        State := UINT#326;
                    ELSE
                        State := UINT#327;
                    END_IF;                       
                END_IF;   
                IF State = UINT#326 THEN
                    Busy := TRUE;
                    THIS.AxoPower_Task.SwitchOn();
                    IF THIS.AxoPower_Task.IsSwitchedOn() THEN
                        State := UINT#327;
                    END_IF;                
                END_IF;                                    
                IF State = UINT#327 THEN
                    _AxisReference^.Telegram111_Out.STW1.acknowledgeFault := FALSE;
                    Done := TRUE;
                END_IF;
                IF State = UINT#329 THEN
                    _AxisReference^.Telegram111_Out.STW1.acknowledgeFault := FALSE;
                    Error := TRUE;
                    ErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                END_IF;
                THIS.UpdateOutputs(AxisRef);         
            END_IF;

            IF NOT Execute AND MC_ResetExecute_PV THEN
                State := UINT#0;
            END_IF;

            MC_ResetExecute_PV := Execute;
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore
            MC_HomeExecute_PV					:= FALSE;
            MC_HomeErrorID					    := WORD#0;
            MC_HomeCycle					    := ULINT#0;
            MC_StopExecute_PV					:= FALSE;
            MC_StopErrorID					    := WORD#0;
            MC_StopCycle					    := ULINT#0;
            MC_HaltExecute_PV					:= FALSE;
            MC_HaltErrorID					    := WORD#0;
            MC_HaltCycle					    := ULINT#0;
            MC_MoveAbsoluteExecute_PV			:= FALSE;
            MC_MoveAbsoluteErrorID				:= WORD#0;
            MC_MoveAbsoluteCycle				:= ULINT#0;
            MC_MoveAbsoluteContinuousUpdate_SV  := FALSE;
            MC_MoveAbsolutePosition_PV          := LREAL#0.0;                                          
            MC_MoveAbsoluteVelocity_PV          := LREAL#0.0;                    
            MC_MoveAbsoluteAcceleration_PV      := LREAL#0.0;                    
            MC_MoveAbsoluteDeceleration_PV      := LREAL#0.0;                                
            MC_MoveAbsoluteJerk_PV              := LREAL#0.0;                     
            MC_MoveAbsoluteDirection_PV         := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#CurrentDirection;        
            MC_MoveRelativeExecute_PV			:= FALSE;
            MC_MoveRelativeErrorID				:= WORD#0;
            MC_MoveRelativeCycle				:= ULINT#0;
            MC_MoveRelativeContinuousUpdate_SV  := FALSE;
            MC_MoveRelativeDistance_PV          := LREAL#0.0;                                        
            MC_MoveRelativeVelocity_PV          := LREAL#0.0;                  
            MC_MoveRelativeAcceleration_PV      := LREAL#0.0;                  
            MC_MoveRelativeDeceleration_PV      := LREAL#0.0;                              
            MC_MoveRelativeJerk_PV              := LREAL#0.0;
            MC_MoveAdditiveExecute_PV			:= FALSE;
            MC_MoveAdditiveErrorID				:= WORD#0;
            MC_MoveAdditiveCycle				:= ULINT#0;
            MC_MoveAdditiveContinuousUpdate_SV  := FALSE;
            MC_MoveAdditiveDistance_PV          := LREAL#0.0;                                       
            MC_MoveAdditiveVelocity_PV          := LREAL#0.0;                 
            MC_MoveAdditiveAcceleration_PV      := LREAL#0.0;                 
            MC_MoveAdditiveDeceleration_PV      := LREAL#0.0;                             
            MC_MoveAdditiveJerk_PV              := LREAL#0.0;
            MC_MoveVelocityExecute_PV			:= FALSE;
            MC_MoveVelocityErrorID				:= WORD#0;
            MC_MoveVelocityCycle				:= ULINT#0;
            MC_MoveVelocityContinuousUpdate_SV  := FALSE;
            MC_MoveVelocityVelocity_PV          := LREAL#0.0;               
            MC_MoveVelocityAcceleration_PV      := LREAL#0.0;               
            MC_MoveVelocityDeceleration_PV      := LREAL#0.0;                           
            MC_MoveVelocityJerk_PV              := LREAL#0.0;                
            MC_MoveVelocityDirection_PV         := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#CurrentDirection;        
            MC_TorqueControlExecute_PV			:= FALSE;
            MC_TorqueControlErrorID				:= WORD#0;
            MC_TorqueControlCycle				:= ULINT#0;
            MC_TorqueControlContinuousUpdate_SV := FALSE;
            MC_TorqueControlTorque_PV           := LREAL#0.0;            
            MC_TorqueControlTorqueRamp_PV       := LREAL#0.0;            
            MC_TorqueControlPositionLimit_PV    := LREAL#0.0;            
            MC_TorqueControlVelocity_PV         := LREAL#0.0;            
            MC_TorqueControlAcceleration_PV     := LREAL#0.0;            
            MC_TorqueControlDeceleration_PV     := LREAL#0.0;                        
            MC_TorqueControlJerk_PV             := LREAL#0.0;             
            MC_TorqueControlDirection_PV        := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#CurrentDirection;        
            MC_SetPositionExecute_PV			:= FALSE;
            MC_SetPositionErrorID				:= WORD#0;
            MC_SetPositionCycle					:= ULINT#0;					
            MC_SetPositionActualPosition        := LINT#0;
            MC_ReadParameterEnable_PV           := FALSE;
            MC_ReadParameterErrorID             := WORD#0;
            MC_ReadParameterCycle			    := ULINT#0;
            MC_ReadParameterValue			    := LINT#0;
            MC_ReadParameterValid			    := FALSE;
            MC_ReadRealParameterEnable_PV       := FALSE;
            MC_ReadRealParameterErrorID         := WORD#0;
            MC_ReadRealParameterCycle			:= ULINT#0;
            MC_ReadRealParameterValue			:= REAL#0.0;
            MC_ReadRealParameterValid			:= FALSE;
            MC_ReadBoolParameterEnable_PV       := FALSE;
            MC_ReadBoolParameterErrorID         := WORD#0;
            MC_ReadBoolParameterCycle			:= ULINT#0;
            MC_ReadBoolParameterValue			:= FALSE;
            MC_ReadBoolParameterValid			:= FALSE;
            MC_WriteParameterExecute_PV         := FALSE;
            MC_WriteParameterErrorID            := WORD#0;
            MC_WriteParameterCycle			    := ULINT#0;
            MC_WriteRealParameterExecute_PV     := FALSE;
            MC_WriteRealParameterErrorID        := WORD#0;
            MC_WriteRealParameterCycle			:= ULINT#0;
            MC_WriteBoolParameterExecute_PV     := FALSE;
            MC_WriteBoolParameterErrorID        := WORD#0;
            MC_WriteBoolParameterCycle			:= ULINT#0;
            MC_ReadDigitalInputEnable_PV        := FALSE;
            MC_ReadDigitalInputErrorID          := WORD#0;
            MC_ReadDigitalInputCycle			:= ULINT#0;
            MC_ReadDigitalInputValue			:= FALSE;
            MC_ReadDigitalInputValid			:= FALSE;
            MC_ReadDigitalOutputEnable_PV       := FALSE;
            MC_ReadDigitalOutputErrorID         := WORD#0;
            MC_ReadDigitalOutputCycle			:= ULINT#0;
            MC_ReadDigitalOutputValue			:= FALSE;
            MC_ReadDigitalOutputValid			:= FALSE;
            MC_WriteDigitalOutputExecute_PV     := FALSE;
            MC_WriteDigitalOutputErrorID        := WORD#0;
            MC_WriteDigitalOutputCycle			:= ULINT#0;
            MC_ReadStatusEnable_PV				:= FALSE;                                                    
            MC_ReadStatusDone_PV				:= FALSE;                                                    
            MC_ReadStatusStateNumber			:= INT#0;
            MC_ReadMotionStateEnable_PV         := FALSE;
            MC_ReadMotionStateErrorID           := WORD#0;
            MC_ReadMotionStateCycle			    := ULINT#0;
            MC_ReadMotionStateValue			    := LINT#0;
            MC_ReadMotionStateValid			    := FALSE;
            MC_ReadAxisErrorEnable_PV           := FALSE;
            MC_ReadAxisErrorErrorID             := WORD#0;
            MC_ReadAxisErrorCycle			    := ULINT#0;
            MC_ReadAxisErrorValue			    := LINT#0;
            MC_ReadAxisErrorValid			    := FALSE;				
            LastMessageCode                     := ULINT#0;
            MC_ResetExecute_PV				    := FALSE;        
            MC_ResetPower_PV				    := FALSE;
            
            _AxisRefExt.Data.Cycle              := ULINT#0;
            State                               := UINT#0;
            DriveStatus.Action.Id := UINT#0;
            DriveStatus.Error.Id  := UINT#0;
            Messenger.Restore();
            TaskMessenger.Restore();

            //AxoPower_Task.Restore();
            AxoStop_Task.Restore();
            AxoHalt_Task.Restore();
            AxoHome_Task.Restore();
            AxoMoveAbsolute_Task.Restore();
            AxoMoveRelative_Task.Restore();
            AxoMoveAdditive_Task.Restore();
            AxoMoveVelocity_Task.Restore();
            AxoTorqueControl_Task.Restore();
            AxoSetPosition_Task.Restore();
            AxoSetOverride_Task.SwitchOff();
            AxoReadParameter_Task.SwitchOff();
            AxoReadRealParameter_Task.SwitchOff();
            AxoReadBoolParameter_Task.SwitchOff();
            AxoWriteParameter_Task.Restore();
            AxoWriteRealParameter_Task.Restore();
            AxoWriteBoolParameter_Task.Restore();
            AxoReadDigitalInput_Task.SwitchOff();
            AxoReadDigitalOutput_Task.SwitchOff();
            AxoWriteDigitalOutput_Task.Restore();
            AxoReadActualPosition_Task.SwitchOff();
            AxoReadActualVelocity_Task.SwitchOff();
            AxoReadActualTorque_Task.SwitchOff();
            AxoReadStatus_Task.SwitchOff();
            AxoReadMotionState_Task.SwitchOff();
            AxoReadAxisInfo_Task.SwitchOff();
            AxoReadAxisError_Task.SwitchOff();
            AxoReset_Task.Restore();
            AxoJogPositive.RemoteSwitchOn := FALSE;
            AxoJogPositive.StartMotion := FALSE;
            AxoJogPositive.StopMotion := FALSE;
            AxoJogNegative.RemoteSwitchOn := FALSE;
            AxoJogNegative.StartMotion := FALSE;
            AxoJogNegative.StopMotion := FALSE;
            Parametrization.Restore();
             
            _AxisRefExt.Telegram111_Out.STW1.activateTraversing := FALSE; 
            _AxisRefExt.Telegram111_Out.STW1.StartHoming := FALSE; 
            _AxisRefExt.Telegram111_Out.POS_STW1.MDI_MOD := FALSE; 
            _AxisRefExt.Telegram111_Out.POS_STW1.PosModulo := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.NegModulo := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.SetupMode := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.MDI_Activate := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW2.Trackingmode := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW2.jog_inc := FALSE;   
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit0 := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit1 := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit2 := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit3 := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit4 := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit5 := FALSE;
            _AxisRefExt.Telegram111_Out.POS_STW1.travBlockBit6 := FALSE;    
            _AxisRefExt.Telegram111_Out.STW2.TravelToFixStop := FALSE;
            RestoreTask.DoneWhen(TRUE);

            SUPER.Restore();
        END_METHOD
    END_CLASS
END_NAMESPACE
