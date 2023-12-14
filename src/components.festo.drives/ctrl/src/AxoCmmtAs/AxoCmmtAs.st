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
    CLASS PUBLIC AxoCmmtAs EXTENDS AXOpen.Components.Drives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive

        VAR PUBLIC //Debug
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}            
            Debug   : ULINT;

            {#ix-attr:[ComponentHeader()]}            
            {#ix-set:AttributeName = "<#State#>"}
            State : UINT;
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

        VAR PUBLIC //PARAMETRIZATION
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Parametrization-Experts only")]}
            {#ix-attr:[DisplayRole("can_debug_components")]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Parametrization#>"}
            Parametrization : AxoReadWritePROFIdriveParameter;        
        END_VAR

        VAR CONSTANT
            PositionExponent		:	INT := 4;
            VelocityExponent		:	INT := 3;
            AccelerationExponent	:	INT :=	3;
            DecelerationExponent	:	INT := 3;
            JerkExponent			:	INT := 3;
            TorqueExponent			:	INT := 1;
            VelocityWindow			:	REAL := REAL#1.0;
            VelocityWindowExponent	:	INT :=3;
            TorqueWindow			:	REAL := REAL#0.5;
            TorqueWindowExponent	:	INT :=1;
        END_VAR

        VAR PRIVATE
            ScalingRead             :   BOOL := FALSE;
            PNU_11724               :   LINT;
            PNU_11725               :   LINT;
            PNU_12345               :   REAL;
            PNU_11122               :   REAL;
            PNU_810                 :   REAL;
            PNU_811                 :   REAL;
        //     _AxisRefExt :  AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
        END_VAR

        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Drive data")]}
            {#ix-set:AttributeName = "<#AxisRef#>"}
            _AxisRefExt :  AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
        END_VAR
    
        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject; 
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  WORD;               //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   WORD;                       //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR
            VAR
                _enable : BOOL;
            END_VAR
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);

            _enable := Enable AND THIS.PreExecute(refTelegram111_In,refTelegram750_In,refTelegram111_Out,refTelegram750_Out,MAP_HW_ID,Enable,EnablePositive,EnableNegative,_AxisRefExt);
            // IF NOT (THIS.PreExecute(refTelegram111_In,refTelegram750_In,refTelegram111_Out,refTelegram750_Out,MAP_HW_ID,Enable,EnablePositive,EnableNegative,_AxisRefExt)) THEN
            //     RETURN;
            // END_IF;
            SUPER.Execute(_AxisRefExt,_enable,EnablePositive,EnableNegative);
            THIS.PostExecute(refTelegram111_In,refTelegram750_In,refTelegram111_Out,refTelegram750_Out,(*MAP_HW_ID,Enable,EnablePositive,EnableNegative,*)_AxisRefExt);
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoContext; 
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  WORD;               //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   WORD;                       //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR
            VAR
                _enable : BOOL;
            END_VAR
          
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);

            _enable := Enable AND THIS.PreExecute(refTelegram111_In,refTelegram750_In,refTelegram111_Out,refTelegram750_Out,MAP_HW_ID,Enable,EnablePositive,EnableNegative,_AxisRefExt);
            // IF NOT (THIS.PreExecute(refTelegram111_In,refTelegram750_In,refTelegram111_Out,refTelegram750_Out,MAP_HW_ID,Enable,EnablePositive,EnableNegative,_AxisRefExt)) THEN
            //     RETURN;
            // END_IF;
            SUPER.Execute(_AxisRefExt,_enable,EnablePositive,EnableNegative);
            THIS.PostExecute(refTelegram111_In,refTelegram750_In,refTelegram111_Out,refTelegram750_Out,(*MAP_HW_ID,Enable,EnablePositive,EnableNegative,*)_AxisRefExt);
       END_METHOD   


        METHOD PRIVATE PreExecute : BOOL
            VAR_INPUT
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  WORD;               //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
                MAP_HW_ID           :   WORD;                       //  Hardware identifier of the module acces point submodule 
                Enable              :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR

            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsAxisReference;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#742, Enable AND NOT EnablePositive, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#743, Enable AND NOT EnableNegative, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#703,refTelegram750_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,refTelegram750_Out = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,refTelegram111_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,refTelegram111_Out = NULL, eAxoMessageCategory#ProgrammingError);

            IF refTelegram750_In = NULL THEN
                DriveStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF refTelegram750_Out = NULL THEN
                DriveStatus.Error.Id := UINT#704;
                RETURN;
            ELSIF refTelegram111_In = NULL THEN
                DriveStatus.Error.Id := UINT#705;
                RETURN;
            ELSIF refTelegram111_Out = NULL THEN
                DriveStatus.Error.Id := UINT#706;
                RETURN;
            END_IF;
            
            THIS.Open();

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                DriveStatus.Error.Id := UINT#707;
                RETURN;
            END_IF;

            // ZSW1
            _AxisReference^.Telegram111_In.ZSW1.followingErrorInTolerance             := refTelegram111_In^[0].%X0;
            _AxisReference^.Telegram111_In.ZSW1.controlRequest                        := refTelegram111_In^[0].%X1;
            _AxisReference^.Telegram111_In.ZSW1.targetPosReached                      := refTelegram111_In^[0].%X2;
            _AxisReference^.Telegram111_In.ZSW1.homePosSet                            := refTelegram111_In^[0].%X3;
            _AxisReference^.Telegram111_In.ZSW1.acknowledgeTraversingBlockActivated   := refTelegram111_In^[0].%X4;
            _AxisReference^.Telegram111_In.ZSW1.driveStopped                          := refTelegram111_In^[0].%X5;
            _AxisReference^.Telegram111_In.ZSW1.axisAccelerates                       := refTelegram111_In^[0].%X6;
            _AxisReference^.Telegram111_In.ZSW1.axisDecelerates                       := refTelegram111_In^[0].%X7;
            _AxisReference^.Telegram111_In.ZSW1.readyForSwitchOn                      := refTelegram111_In^[1].%X0;
            _AxisReference^.Telegram111_In.ZSW1.ready                                 := refTelegram111_In^[1].%X1;
            _AxisReference^.Telegram111_In.ZSW1.operationEnabled                      := refTelegram111_In^[1].%X2;
            _AxisReference^.Telegram111_In.ZSW1.faultPresent                          := refTelegram111_In^[1].%X3;
            _AxisReference^.Telegram111_In.ZSW1.noCoastingActive                      := refTelegram111_In^[1].%X4;
            _AxisReference^.Telegram111_In.ZSW1.noQuickStopActive                     := refTelegram111_In^[1].%X5;
            _AxisReference^.Telegram111_In.ZSW1.switchingOnInhibitedActive            := refTelegram111_In^[1].%X6;
            _AxisReference^.Telegram111_In.ZSW1.warningActive                         := refTelegram111_In^[1].%X7;
            //POS_ZSW1
            _AxisReference^.Telegram111_In.POS_ZSW1.%B1                               := refTelegram111_In^[2];
            _AxisReference^.Telegram111_In.POS_ZSW1.%B0                               := refTelegram111_In^[3];
            // Positioning.Outputs.EPosZSW1 := _AxisReference^.Telegram111_In.POS_ZSW1;
            //POS_ZSW2
            _AxisReference^.Telegram111_In.POS_ZSW2.%B1                               := refTelegram111_In^[4];
            _AxisReference^.Telegram111_In.POS_ZSW2.%B0                               := refTelegram111_In^[5];
            // Positioning.Outputs.EPosZSW2 := _AxisReference^.Telegram111_In.POS_ZSW2;
            // ZSW2
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit8                    := refTelegram111_In^[6].%X0;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit9                    := refTelegram111_In^[6].%X1;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit10                   := refTelegram111_In^[6].%X2;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit11                   := refTelegram111_In^[6].%X3;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit0                      := refTelegram111_In^[6].%X4;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit1                      := refTelegram111_In^[6].%X5;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit2                      := refTelegram111_In^[6].%X6;
            _AxisReference^.Telegram111_In.ZSW2.doSignOfLifeBit3                      := refTelegram111_In^[6].%X7;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit0                    := refTelegram111_In^[7].%X0;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit1                    := refTelegram111_In^[7].%X1;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit2                    := refTelegram111_In^[7].%X2;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit3                    := refTelegram111_In^[7].%X3;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit4                    := refTelegram111_In^[7].%X4;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit5                    := refTelegram111_In^[7].%X5;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit6                    := refTelegram111_In^[7].%X6;
            _AxisReference^.Telegram111_In.ZSW2.deviceSpecificBit7                    := refTelegram111_In^[7].%X7;
            //MELDW
            _AxisReference^.Telegram111_In.MELDW.%B1                                  := refTelegram111_In^[8];
            _AxisReference^.Telegram111_In.MELDW.%B0                                  := refTelegram111_In^[9];
            //XIST_A
            _AxisReference^.Telegram111_In.XIST_A.%B3                                 := refTelegram111_In^[10];
            _AxisReference^.Telegram111_In.XIST_A.%B2                                 := refTelegram111_In^[11];
            _AxisReference^.Telegram111_In.XIST_A.%B1                                 := refTelegram111_In^[12];
            _AxisReference^.Telegram111_In.XIST_A.%B0                                 := refTelegram111_In^[13];
            //NIST_B
            _AxisReference^.Telegram111_In.NIST_B.%B3                                 := refTelegram111_In^[14];
            _AxisReference^.Telegram111_In.NIST_B.%B2                                 := refTelegram111_In^[15];
            _AxisReference^.Telegram111_In.NIST_B.%B1                                 := refTelegram111_In^[16];
            _AxisReference^.Telegram111_In.NIST_B.%B0                                 := refTelegram111_In^[17];
            //Fault_Code
            _AxisReference^.Telegram111_In.Fault_Code.%B1                             := refTelegram111_In^[18];
            _AxisReference^.Telegram111_In.Fault_Code.%B0                             := refTelegram111_In^[19];
            //Warn_Code
            _AxisReference^.Telegram111_In.Warn_Code.%B1                              := refTelegram111_In^[20];
            _AxisReference^.Telegram111_In.Warn_Code.%B0                              := refTelegram111_In^[21];
            //Reserved 
            _AxisReference^.Telegram111_In.Reserved.%B1                               := refTelegram111_In^[22];
            _AxisReference^.Telegram111_In.Reserved.%B0                               := refTelegram111_In^[23];
            //M_Actual 
            _AxisReference^.Telegram750_In.M_Actual                                   := TO_INT(refTelegram750_In^);
            //MAP_HW_ID
            _AxisReference^.Data.MAP_HW_ID := MAP_HW_ID;

            Parametrization.Initialize(THIS);
            PreExecute := TRUE;
        END_METHOD

        METHOD PRIVATE PostExecute
            VAR_INPUT
                refTelegram111_In   :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the Profidrive telegram 111 of this axis
                refTelegram750_In   :   REF_TO  WORD;               //  Reference to the input data of the Profidrive telegram 750 of this axis
                refTelegram111_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 111 of this axis
                refTelegram750_Out  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the Profidrive telegram 750 of this axis
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
            //********************PARAMETRIZAION***************//          
            Parametrization.Run(THIS);
            Parametrization.Inputs.HardwareId := _AxisReference^.Data.MAP_HW_ID;            
            //*******************SCALING***********************//          
            Messenger.ActivateOnCondition(ULINT#744,NOT ScalingRead , eAxoMessageCategory#Warning);            
            IF NOT ScalingRead THEN
                IF State = UINT#0 THEN
                    State := UINT#1;
                END_IF;
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
                    ScalingConstantRequiredAcceleration := PNU_810 / 16384;
                    ScalingConstantRequiredDeceleration := PNU_811 / 16384;
                    ScalingRead := TRUE;
                    State := UINT#0;
                END_IF;                                
                RETURN;
            END_IF;
            //*************************************************//

            // THIS.UpdateStatus(_AxisRefExt);
            THIS.ActualPosition := TO_LREAL(_AxisReference^.Telegram111_In.XIST_A) * ScalingConstantActualPosition;
            THIS.ActualVelocity := TO_LREAL(_AxisReference^.Telegram111_In.NIST_B) * ScalingConstantActualVelocity;
            THIS.ActualTorque := TO_LREAL(_AxisReference^.Telegram750_In.M_Actual) * ScalingConstantActualTorque;

            IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Disabled;
            ELSIF _AxisReference^.Data.HomingRunning THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Homing;
            ELSIF _AxisReference^.Data.DiscreteMotion THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#DiscreteMotion;
            ELSIF _AxisReference^.Data.ContinuousMotion THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#ContinousMotion;
            ELSIF _AxisReference^.Data.SynchronizedMotion THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#SynchronizedMotion;
            ELSIF _AxisReference^.Data.DriveStopReq THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Stopping;
            ELSIF _AxisReference^.Data.StoppedDueError THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Errorstop;
            ELSIF _AxisReference^.Data.Standstill THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Standstill;
            END_IF;

            // THIS.UpdateOutputs(AxisRef := _AxisRefExt, refTelegram111_Out := refTelegram111_Out, refTelegram750_Out := refTelegram750_Out);
            //STW1
            refTelegram111_Out^[1].%X0 := _AxisReference^.Telegram111_Out.STW1.on_;
            refTelegram111_Out^[1].%X1 := _AxisReference^.Telegram111_Out.STW1.noCoastStop;
            refTelegram111_Out^[1].%X2 := _AxisReference^.Telegram111_Out.STW1.noQuickStop;
            refTelegram111_Out^[1].%X3 := _AxisReference^.Telegram111_Out.STW1.enableOperation;
            refTelegram111_Out^[1].%X4 := _AxisReference^.Telegram111_Out.STW1.cancelTraversing;
            refTelegram111_Out^[1].%X5 := _AxisReference^.Telegram111_Out.STW1.intermediateStop;
            refTelegram111_Out^[1].%X6 := _AxisReference^.Telegram111_Out.STW1.activateTraversing;
            refTelegram111_Out^[1].%X7 := _AxisReference^.Telegram111_Out.STW1.acknowledgeFault;
            refTelegram111_Out^[0].%X0 := _AxisReference^.Telegram111_Out.STW1.jog1;
            refTelegram111_Out^[0].%X1 := _AxisReference^.Telegram111_Out.STW1.jog2;
            refTelegram111_Out^[0].%X2 := _AxisReference^.Telegram111_Out.STW1.controlByPlc;
            refTelegram111_Out^[0].%X3 := _AxisReference^.Telegram111_Out.STW1.StartHoming;
            refTelegram111_Out^[0].%X4 := _AxisReference^.Telegram111_Out.STW1.ReleaseBrake;
            refTelegram111_Out^[0].%X5 := _AxisReference^.Telegram111_Out.STW1.ExternalBlockChange;
            refTelegram111_Out^[0].%X6 := _AxisReference^.Telegram111_Out.STW1.reserved14;
            refTelegram111_Out^[0].%X7 := _AxisReference^.Telegram111_Out.STW1.reserved15;
            //POS_STW1
            refTelegram111_Out^[3].%X0 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit0;
            refTelegram111_Out^[3].%X1 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit1;
            refTelegram111_Out^[3].%X2 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit2;
            refTelegram111_Out^[3].%X3 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit3;
            refTelegram111_Out^[3].%X4 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit4;
            refTelegram111_Out^[3].%X5 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit5;
            refTelegram111_Out^[3].%X6 := _AxisReference^.Telegram111_Out.POS_STW1.travBlockBit6;
            refTelegram111_Out^[3].%X7 := _AxisReference^.Telegram111_Out.POS_STW1.reserved7;
            refTelegram111_Out^[2].%X0 := _AxisReference^.Telegram111_Out.POS_STW1.MDI_MOD;
            refTelegram111_Out^[2].%X1 := _AxisReference^.Telegram111_Out.POS_STW1.PosModulo;
            refTelegram111_Out^[2].%X2 := _AxisReference^.Telegram111_Out.POS_STW1.NegModulo;
            refTelegram111_Out^[2].%X3 := _AxisReference^.Telegram111_Out.POS_STW1.reserved11;
            refTelegram111_Out^[2].%X4 := _AxisReference^.Telegram111_Out.POS_STW1.reserved12;
            refTelegram111_Out^[2].%X5 := _AxisReference^.Telegram111_Out.POS_STW1.reserved13;
            refTelegram111_Out^[2].%X6 := _AxisReference^.Telegram111_Out.POS_STW1.SetupMode;
            refTelegram111_Out^[2].%X7 := _AxisReference^.Telegram111_Out.POS_STW1.MDI_Activate;    
            //POS_STW2
            refTelegram111_Out^[5].%X0 := _AxisReference^.Telegram111_Out.POS_STW2.Trackingmode;
            refTelegram111_Out^[5].%X1 := _AxisReference^.Telegram111_Out.POS_STW2.SetReferencePoint;
            refTelegram111_Out^[5].%X2 := _AxisReference^.Telegram111_Out.POS_STW2.reserved2;
            refTelegram111_Out^[5].%X3 := _AxisReference^.Telegram111_Out.POS_STW2.reserved3;
            refTelegram111_Out^[5].%X4 := _AxisReference^.Telegram111_Out.POS_STW2.reserved4;
            refTelegram111_Out^[5].%X5 := _AxisReference^.Telegram111_Out.POS_STW2.jog_inc;
            refTelegram111_Out^[5].%X6 := _AxisReference^.Telegram111_Out.POS_STW2.reserved6;
            refTelegram111_Out^[5].%X7 := _AxisReference^.Telegram111_Out.POS_STW2.reserved7;
            refTelegram111_Out^[4].%X0 := _AxisReference^.Telegram111_Out.POS_STW2.FlyingRef;
            refTelegram111_Out^[4].%X1 := _AxisReference^.Telegram111_Out.POS_STW2.reserved9;
            refTelegram111_Out^[4].%X2 := _AxisReference^.Telegram111_Out.POS_STW2.SelectProbe;
            refTelegram111_Out^[4].%X3 := _AxisReference^.Telegram111_Out.POS_STW2.ProbeEdgeEval;
            refTelegram111_Out^[4].%X4 := _AxisReference^.Telegram111_Out.POS_STW2.reserved12;
            refTelegram111_Out^[4].%X5 := _AxisReference^.Telegram111_Out.POS_STW2.reserved13;
            refTelegram111_Out^[4].%X6 := _AxisReference^.Telegram111_Out.POS_STW2.SW_Limit;
            refTelegram111_Out^[4].%X7 := _AxisReference^.Telegram111_Out.POS_STW2.HW_Limit;
            //STW2
            refTelegram111_Out^[7].%X0 := _AxisReference^.Telegram111_Out.STW2.reserved0;
            refTelegram111_Out^[7].%X1 := _AxisReference^.Telegram111_Out.STW2.reserved1;
            refTelegram111_Out^[7].%X2 := _AxisReference^.Telegram111_Out.STW2.reserved2;
            refTelegram111_Out^[7].%X3 := _AxisReference^.Telegram111_Out.STW2.reserved3;
            refTelegram111_Out^[7].%X4 := _AxisReference^.Telegram111_Out.STW2.reserved4;
            refTelegram111_Out^[7].%X5 := _AxisReference^.Telegram111_Out.STW2.reserved5;
            refTelegram111_Out^[7].%X6 := _AxisReference^.Telegram111_Out.STW2.reserved6;
            refTelegram111_Out^[7].%X7 := _AxisReference^.Telegram111_Out.STW2.reserved7;
            refTelegram111_Out^[6].%X0 := _AxisReference^.Telegram111_Out.STW2.TravelToFixStop;
            refTelegram111_Out^[6].%X1 := _AxisReference^.Telegram111_Out.STW2.reserved9;
            refTelegram111_Out^[6].%X2 := _AxisReference^.Telegram111_Out.STW2.reserved10;
            refTelegram111_Out^[6].%X3 := _AxisReference^.Telegram111_Out.STW2.reserved11;
            refTelegram111_Out^[6].%X4 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit0;
            refTelegram111_Out^[6].%X5 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit1;
            refTelegram111_Out^[6].%X6 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit2;
            refTelegram111_Out^[6].%X7 := _AxisReference^.Telegram111_Out.STW2.signOfLifeBit3;   
            //Override
            refTelegram111_Out^[9] := _AxisReference^.Telegram111_Out.Override_.%B0;
            refTelegram111_Out^[8] := _AxisReference^.Telegram111_Out.Override_.%B1;
            //TargetPos
            tempDWord := TO_DWORD(_AxisReference^.Telegram111_Out.MDI_TARPOS);
            refTelegram111_Out^[13] := tempDWord.%B0;
            refTelegram111_Out^[12] := tempDWord.%B1;
            refTelegram111_Out^[11] := tempDWord.%B2;
            refTelegram111_Out^[10] := tempDWord.%B3;
            //TargetVelocity
            tempDWord := TO_DWORD(_AxisReference^.Telegram111_Out.MDI_VELOCITY);
            refTelegram111_Out^[17] := tempDWord.%B0;
            refTelegram111_Out^[16] := tempDWord.%B1;
            refTelegram111_Out^[15] := tempDWord.%B2;
            refTelegram111_Out^[14] := tempDWord.%B3;
            // ACC, DEC
            refTelegram111_Out^[19] := _AxisReference^.Telegram111_Out.MDI_ACC.%B0;
            refTelegram111_Out^[18] := _AxisReference^.Telegram111_Out.MDI_ACC.%B1;
            refTelegram111_Out^[21] := _AxisReference^.Telegram111_Out.MDI_DEC.%B0;
            refTelegram111_Out^[20] := _AxisReference^.Telegram111_Out.MDI_DEC.%B1;
            refTelegram111_Out^[23] := _AxisReference^.Telegram111_Out.reserved11.%B0;
            refTelegram111_Out^[22] := _AxisReference^.Telegram111_Out.reserved11.%B1;
            // M_ADD1, M_LIMIT_POS, M_LIMIT_NEG
            refTelegram750_Out^[1] := _AxisReference^.Telegram750_Out.M_ADD1.%B0;
            refTelegram750_Out^[0] := _AxisReference^.Telegram750_Out.M_ADD1.%B1;
            refTelegram750_Out^[3] := _AxisReference^.Telegram750_Out.M_LIMIT_POS.%B0;
            refTelegram750_Out^[2] := _AxisReference^.Telegram750_Out.M_LIMIT_POS.%B1;
            refTelegram750_Out^[5] := _AxisReference^.Telegram750_Out.M_LIMIT_NEG.%B0;
            refTelegram750_Out^[4] := _AxisReference^.Telegram750_Out.M_LIMIT_NEG.%B1;
            refTelegram750_Out^[7] := _AxisReference^.Telegram750_Out.Reserved.%B0;
            refTelegram750_Out^[6] := _AxisReference^.Telegram750_Out.Reserved.%B1;


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

            Status := FALSE;
            Error	:= FALSE;
            ErrorID :=	WORD#0;
            Valid := FALSE;
            IF Enable OR MC_PowerEnable_PV THEN
                IF Enable THEN (*	raising edge of ENABLE *)
                    _AxisReference^.Telegram111_Out.STW1.on_ := TRUE;
                END_IF;
                IF _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                    Status	:= TRUE;						(* Status OK*)
                    Valid := TRUE;
                END_IF;
                IF _AxisReference^.Telegram111_In.ZSW1.faultPresent = TRUE THEN
                    Error		:= TRUE; 						(*	Set the ERROR-Output *)
                    Valid := TRUE;
                    ErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                END_IF;
            ELSE
                _AxisReference^.Telegram111_Out.STW1.on_  := FALSE;
                _AxisReference^.Telegram111_Out.STW1.noCoastStop := TRUE;
                _AxisReference^.Telegram111_Out.STW1.noQuickStop := TRUE;
                _AxisReference^.Telegram111_Out.STW1.enableOperation := TRUE;
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE;
                _AxisReference^.Telegram111_Out.STW1.intermediateStop := TRUE;
                _AxisReference^.Telegram111_Out.STW1.controlByPlc := TRUE;
            END_IF;
            MC_PowerEnable_PV := Enable;
        END_METHOD 

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
        VAR INTERNAL
            // MC_HomeExecute_PV					:	BOOL := FALSE;		//Execute - previous value           
            // MC_HomeCallNumber					: 	INT; 				//Call number of the method MC_Stop  
            // MC_HomeFirstCall					: 	BOOL;				//First call of the method MC_Stop   	
            // MC_HomeDone_						:	BOOL; 				
            // MC_HomeActive_						:	BOOL;				
            // MC_HomeCommandAborted_				:	BOOL;				
            // MC_HomeError_						:	BOOL;				
            // MC_HomeErrorID_						:	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode; 		
            // MC_HomeState_						:	UINT;				

            MC_HomeExecute_PV					: 	BOOL;				//Execute - previous value
            MC_HomeErrorID					    : 	eAxoCmmtAsErrorCode;
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

                _ErrorID : WORD;
                _HommingMode: DINT;
                Dummy : BOOL;
                _result : IAxoTaskState;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#710,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#745, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#746, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);

            // IF Execute AND NOT MC_HomeExecute_PV THEN
            //     _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
            //     MC_StopCycle := _AxisReference^.Data.Cycle ;
            //     State := UINT#0;
            // END_IF;

            // IF Execute THEN 				
            //     IF State = UINT#0 THEN
            //         Busy := TRUE;            
            //         Active := TRUE;          
            //         MC_HomeErrorID :=AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;         
            //         State := UINT#30;
            //     END_IF;

            //     IF State = UINT#30 THEN
            //         IF Acceleration <= 0 OR Deceleration <= 0 THEN
            //             State := UINT#36;
            //         ELSE
            //             State := UINT#31;
            //         END_IF;
            //     END_IF;
            //     IF State = UINT#31 THEN
            //         Busy := TRUE;            
            //         Active := TRUE;          
            //         Parametrization.Inputs.Enable := TRUE;
            //         Parametrization.Inputs.ReadWrite   := TRUE;
            //         Parametrization.Inputs.ParameterNo := 12327;
            //         Parametrization.Inputs.Subindex    := 0;
            //         Parametrization.Inputs.AxisNo  := BYTE#1;
            //         Parametrization.Inputs.HardwareId  := _AxisReference^.Data.MAP_HW_ID;
            //         Parametrization.Inputs.ValueWriteREAL := TO_REAL(Jerk);
            //         IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
            //             State := UINT#42;
            //         END_IF;
            //         IF Parametrization.Outputs.Error THEN 
            //             State := UINT#46;
            //         END_IF;
            //     END_IF;
            //     IF State = UINT#42 THEN
            //         Busy := TRUE;            
            //         Active := TRUE;          
            //         _AxisReference^.Telegram111_Out.MDI_DEC := TO_UINT(Deceleration * ScalingConstantRequiredDeceleration);
            //         _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
            //         Parametrization.Inputs.Enable := FALSE;
            //         Parametrization.Inputs.ReadWrite   := FALSE;
            //         IF  NOT Parametrization.Outputs.Done THEN
            //             State := UINT#43;
            //         END_IF;
            //     END_IF;               
            //     IF State = UINT#43 THEN
            //         Busy := TRUE;            
            //         Active := TRUE;          
            //         IF _AxisReference^.Telegram111_In.ZSW1.driveStopped  THEN
            //             State := UINT#44;
            //         END_IF;
            //     END_IF;                           
            //     IF State = UINT#44 THEN
            //         Done := TRUE;            
            //         Active := TRUE;     
            //         MC_StopCycle := ULINT#0;     
            //     END_IF;         
            //     IF State = UINT#45 THEN
            //         CommandAborted := TRUE;            
            //     END_IF;         
            //     IF State = UINT#46 THEN
            //         _AxisReference^.Telegram111_Out.MDI_DEC := UINT#16384;
            //         _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
            //         MC_StopCycle := ULINT#0;     
            //         Error := TRUE;    
            //     END_IF;         
                
            //     IF State>=UINT#40 AND State<UINT#44 THEN
            //         IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
            //             State := UINT#45;
            //         ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
            //             MC_StopErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
            //             State := UINT#46;
            //         ELSIF _AxisReference^.Data.Cycle <> MC_StopCycle THEN
            //             _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
            //             State := UINT#45;
            //         END_IF;                  
            //     END_IF;                  
            // END_IF;

            // IF NOT Execute AND MC_StopExecute_PV THEN
            //     _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
            //     MC_StopErrorID := WORD#0;
            //     State := UINT#0;
            //     MC_StopCycle := ULINT#0;     
            // END_IF;
            // ErrorID := MC_StopErrorID;
            // MC_StopExecute_PV := Execute;


            // IF Execute AND NOT MC_HomeExecute_PV AND MC_HomeState_ = UINT#0 THEN
            //     MC_HomeState_ := UINT#10;	
            // END_IF;
            // IF MC_HomeState_ = UINT#10 THEN
            //     //S-0-0052, Reference distance of encoder 1
            //     _result := THIS.AxoWriteParameter(ParameterNumber := 52, Value := TO_DINT(Position * EXP(LN(10)* PositionExponent)),ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately, ErrorID =>_ErrorID);
            //     IF _result.IsDone() THEN
            //         MC_HomeState_ := UINT#20;	
            //     END_IF;
            //     IF _result.HasError() THEN
            //         MC_HomeError_ := TRUE;
            //         MC_HomeErrorID_ := _ErrorID;
            //     END_IF;
            // END_IF;
            // IF MC_HomeState_ = UINT#20 THEN
            //     AxoWriteParameter_Task.Restore();
            //     IF(AxoWriteParameter_Task.IsReady()) THEN
            //         MC_HomeState_ :=UINT#30;	
            //         RETURN;
            //     END_IF;	
            // END_IF;
            // IF MC_HomeState_ = UINT#30 THEN
            //     IF HommingMode = 0 THEN
            //         _HommingMode := 551;
            //     ELSE
            //         _HommingMode := HommingMode;
            //     END_IF;
            //     //S-0-0147, Homing parameter
            //     _result := THIS.AxoWriteParameter(ParameterNumber := 147, Value := _HommingMode ,ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately,ErrorID =>_ErrorID);
            //     IF _result.IsDone() THEN
            //         MC_HomeState_ := UINT#40;		
            //     END_IF;
            //     IF _result.HasError() THEN
            //         MC_HomeError_ := TRUE;
            //         MC_HomeErrorID_ := _ErrorID;
            //     END_IF;
            // END_IF;
            // IF MC_HomeState_ = UINT#40 THEN
            //     AxoWriteParameter_Task.Restore();
            //     IF(AxoWriteParameter_Task.IsReady()) THEN
            //         MC_HomeState_ := UINT#50;
            //         RETURN;
            //     END_IF;	
            // END_IF;
            // IF MC_HomeState_ = UINT#50 THEN
            //     //S-0-0041, Homing velocity
            //     _result := THIS.AxoWriteParameter(ParameterNumber := 41, Value := TO_DINT(Velocity * EXP(LN(10)*VelocityExponent)) ,ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately, ErrorID =>_ErrorID);
            //     IF _result.IsDone() THEN
            //         MC_HomeState_ :=UINT#60;	
            //     END_IF;
            //     IF _result.HasError() THEN
            //         MC_HomeError_ := TRUE;
            //         MC_HomeErrorID_ := _ErrorID;
            //     END_IF;
            // END_IF;
            // IF MC_HomeState_ = UINT#60 THEN
            //     AxoWriteParameter_Task.Restore();
            //     IF(AxoWriteParameter_Task.IsReady()) THEN
            //         MC_HomeState_ :=UINT#70;
            //         RETURN;
            //     END_IF;	
            // END_IF;
            // IF MC_HomeState_ = UINT#70 THEN
            //     //S-0-0042, Homing acceleration
            //     _result := THIS.AxoWriteParameter(ParameterNumber := 42, Value := TO_DINT(Acceleration * EXP(LN(10)*AccelerationExponent)) ,ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately, ErrorID =>_ErrorID);
            //     IF _result.IsDone() THEN
            //         MC_HomeState_ := UINT#80;	
            //     END_IF;
            //     IF _result.HasError() THEN
            //         MC_HomeError_ := TRUE;
            //         MC_HomeErrorID_ := _ErrorID;
            //     END_IF;
            // END_IF;
            // IF MC_HomeState_ = UINT#80 THEN
            //     AxoWriteParameter_Task.Restore();
            //     IF(AxoWriteParameter_Task.IsReady()) THEN
            //         MC_HomeState_ := UINT#90;
            //         RETURN;
            //     END_IF;	
            // END_IF;
        
            // IF Execute AND MC_HomeState_ < UINT#90 THEN
            //     RETURN;
            // END_IF;
            
            // (************ start of homing *****************************)
            // IF Execute OR MC_HomeExecute_PV  THEN
            //     MC_HomeFirstCall := TRUE;
            //     IF _AxisReference^.Data.CheckAccessOK	THEN
            //         IF NOT _AxisReference^.Data.PowerOK OR  _AxisReference^.Data.DriveStopReq AND MC_HomeActive_ THEN
            //             MC_HomeDone_ := FALSE;
            //             MC_HomeActive_ := FALSE;
            //             MC_HomeCommandAborted_ := TRUE;
            //             _AxisReference^.Data.HomingReq:= FALSE;
            //         END_IF;
            //         IF Execute AND NOT MC_HomeExecute_PV  THEN
            //             IF _AxisReference^.Data.PowerOK AND NOT _AxisReference^.Data.DriveStopReq THEN
            //                 _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
            //                 MC_HomeCallNumber := _AxisReference^.Data.CallNumberCyclic;
            //                 _AxisReference^.Data.WriteCommand:= TRUE;
            //                 _AxisReference^.Data.HomingReq:= TRUE;
            //                 _AxisReference^.Data.DriveStopReq:= FALSE;
            //                 _AxisReference^.Data.DriveHaltReq:= FALSE;
            //                 _AxisReference^.Data.MoveVelocityReq:= FALSE;
            //                 _AxisReference^.Data.TorqueControlReq:= FALSE;
            //                 _AxisReference^.Data.Relative:= FALSE;
            //                 _AxisReference^.Data.Additive:= FALSE;
            //                 _AxisReference^.Data.Position := Position;
            //                 _AxisReference^.Data.Velocity := Velocity;
            //                 _AxisReference^.Data.Acceleration := Acceleration;
            //                 _AxisReference^.Data.Deceleration := Deceleration;
            //             ELSE
            //                 MC_HomeError_ := TRUE;
            //                 MC_HomeErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#STATE_MACHINE_Error; 	(*State machine MC_HomeError_*)
            //             END_IF;
            //         END_IF;
            //     ELSE
            //         MC_HomeCallNumber := MC_HomeCallNumber - INT#1;
            //         MC_HomeError_ := TRUE;
            //         MC_HomeErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_Error;
            //     END_IF;
            //     IF NOT Execute AND MC_HomeExecute_PV THEN
            //         _AxisReference^.Data.HomingReq:= FALSE;
            //         MC_HomeCommandAborted_ := FALSE;
            //         MC_HomeError_ := FALSE;
            //         MC_HomeErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_Error;
            //     END_IF;
            // // ELSE
            // //     MC_HomeDone_					:= FALSE; 					
            // //     MC_HomeActive_					:= FALSE;					
            // //     MC_HomeCommandAborted_ 			:= FALSE;					
            // //     MC_HomeError_					:= FALSE;					
            // //     MC_HomeErrorID_ 				:= AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_Error;
            // //     MC_HomeState_ 					:= UINT#0;
            // END_IF;
            // (*************** detection of command finished *******************)
            // IF MC_HomeFirstCall THEN
            //     IF MC_HomeCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
            //         _AxisReference^.Data.CallAxis := TRUE;
            //         _AxisReference^.Data.ReadOnlyData := FALSE;
            //         // THIS.FieldBusCommunication(	AxisRef := _AxisReference,CommandWriteActive=> Dummy);
            //         IF NOT _AxisReference^.Data.CommandWriteActive THEN
            //              IF _AxisReference^.Data.SetpointReached THEN
            //                 MC_HomeDone_ := TRUE;
            //                 MC_HomeActive_ := FALSE;
            //                 _AxisReference^.Data.HomingReq:= FALSE;
            //             ELSE
            //                 MC_HomeActive_ := TRUE;
            //             END_IF;
            //             IF _AxisReference^.Data.Error THEN
            //                 MC_HomeDone_ 	:= FALSE;
            //                 MC_HomeActive_ 	:= FALSE;
            //                 MC_HomeError_ 	:= TRUE;
            //                 MC_HomeErrorID_ := _AxisReference^.Data.ErrorID;
            //             ELSIF _AxisReference^.Data.CallAxis THEN
            //                 MC_HomeError_ := TRUE;
            //                 MC_HomeErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
            //             END_IF;
            //         END_IF;
            //     END_IF;
            //     (************** reset of outputs *************************************)
            //     IF Execute = FALSE THEN
            //         _AxisReference^.Data.HomingReq:= FALSE;
            //         (****** reset outputs ***********)
            //         MC_HomeDone_ := FALSE;
            //         MC_HomeActive_ := FALSE;
            //         MC_HomeCommandAborted_ := FALSE;
            //         MC_HomeError_ := FALSE;
            //         MC_HomeErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            //         MC_HomeState_ := UINT#0;
            //         IF MC_HomeCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
            //             _AxisReference^.Data.CallAxis := TRUE;
            //             _AxisReference^.Data.ReadOnlyData := FALSE;
            //             // THIS.FieldBusCommunication(	AxisRef := _AxisReference,CommandWriteActive=> Dummy);
            //             IF _AxisReference^.Data.SetpointReached THEN
            //                 MC_HomeDone_ := TRUE;
            //                 MC_HomeCallNumber := MC_HomeCallNumber - INT#1; (*Reset MC_HomeCallNumber because reset MC_HomeDone_ *)
            //             END_IF;
            //         END_IF;
            //     END_IF;
            // END_IF;
            
            // MC_HomeExecute_PV 	:=	Execute;
            // Done				:=	MC_HomeDone_;		
            // Active 				:=	MC_HomeActive_;		
            // CommandAborted 		:=	MC_HomeCommandAborted_;
            // Error 				:=	MC_HomeError_;				
            // ErrorID 			:=	MC_HomeErrorID_;
            // Busy				:=	MC_HomeActive_ AND NOT Done AND NOT Error;	
            
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        ///</summary>
        VAR INTERNAL
            MC_StopExecute_PV					: 	BOOL;				//Execute - previous value
            MC_StopErrorID					    : 	eAxoCmmtAsErrorCode;
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

            IF Execute AND NOT MC_StopExecute_PV THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_StopCycle := _AxisReference^.Data.Cycle ;
                State := UINT#0;
            END_IF;

            IF Execute THEN 				
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_StopErrorID :=AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;         
                    State := UINT#40;
                END_IF;

                IF State = UINT#40 THEN
                    IF Deceleration <= 0 OR Jerk <= 0 THEN
                        State := UINT#46;
                    ELSE
                        State := UINT#41;
                    END_IF;
                END_IF;
                IF State = UINT#41 THEN
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
                        State := UINT#42;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        State := UINT#46;
                    END_IF;
                END_IF;
                IF State = UINT#42 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Telegram111_Out.MDI_DEC := TO_UINT(Deceleration * ScalingConstantRequiredDeceleration);
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#43;
                    END_IF;
                END_IF;               
                IF State = UINT#43 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Telegram111_In.ZSW1.driveStopped  THEN
                        State := UINT#44;
                    END_IF;
                END_IF;                           
                IF State = UINT#44 THEN
                    Done := TRUE;            
                    Active := TRUE;     
                    MC_StopCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#45 THEN
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#46 THEN
                    _AxisReference^.Telegram111_Out.MDI_DEC := UINT#16384;
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    MC_StopCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#40 AND State<UINT#44 THEN
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#45;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        MC_StopErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        State := UINT#46;
                    ELSIF _AxisReference^.Data.Cycle <> MC_StopCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        State := UINT#45;
                    END_IF;                  
                END_IF;                  
            END_IF;

            IF NOT Execute AND MC_StopExecute_PV THEN
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                MC_StopErrorID := WORD#0;
                State := UINT#0;
                MC_StopCycle := ULINT#0;     
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
            MC_HaltErrorID					    : 	eAxoCmmtAsErrorCode;
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

            Messenger.ActivateOnCondition(ULINT#745, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#746, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

            IF Execute AND NOT MC_HaltExecute_PV THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_HaltCycle := _AxisReference^.Data.Cycle ;
                State := UINT#0;
            END_IF;

            IF Execute THEN 				
                IF State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_HaltErrorID :=AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;         
                    State := UINT#50;
                END_IF;

                IF State = UINT#50 THEN
                    IF Deceleration <= 0 OR Jerk <= 0 THEN
                        State := UINT#56;
                    ELSE
                        State := UINT#51;
                    END_IF;
                END_IF;
                IF State = UINT#51 THEN
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
                        State := UINT#52;
                    END_IF;
                    IF Parametrization.Outputs.Error THEN 
                        State := UINT#56;
                    END_IF;
                END_IF;
                IF State = UINT#52 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Telegram111_Out.MDI_DEC := TO_UINT(Deceleration * ScalingConstantRequiredDeceleration);
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    Parametrization.Inputs.Enable := FALSE;
                    Parametrization.Inputs.ReadWrite   := FALSE;
                    IF  NOT Parametrization.Outputs.Done THEN
                        State := UINT#53;
                    END_IF;
                END_IF;               
                IF State = UINT#53 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Telegram111_In.ZSW1.driveStopped  THEN
                        State := UINT#54;
                    END_IF;
                END_IF;                           
                IF State = UINT#54 THEN
                    Done := TRUE;            
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                    MC_HaltCycle := ULINT#0;     
                END_IF;         
                IF State = UINT#55 THEN
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                    CommandAborted := TRUE;            
                END_IF;         
                IF State = UINT#56 THEN
                    _AxisReference^.Telegram111_Out.MDI_DEC := UINT#16384;
                    _AxisReference^.Telegram111_Out.STW1.cancelTraversing := FALSE; 
                    MC_HaltCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF State>=UINT#50 AND State<UINT#54 THEN
                    IF NOT _AxisReference^.Telegram111_In.ZSW1.operationEnabled THEN
                        State := UINT#55;
                    ELSIF _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        MC_HaltErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                        State := UINT#56;
                    // ELSIF _AxisReference^.Data.Cycle <> MC_HaltCycle THEN
                    //     _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                    //     State := UINT#55;
                    END_IF;                  
                END_IF;                  
            END_IF;

            IF NOT Execute AND MC_HaltExecute_PV THEN
                _AxisReference^.Telegram111_Out.STW1.cancelTraversing := TRUE; 
                MC_HaltErrorID := WORD#0;
                State := UINT#0;
                MC_HaltCycle := ULINT#0;     
            END_IF;
            ErrorID := MC_HaltErrorID;
            MC_HaltExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
        VAR INTERNAL
            MC_MoveAbsoluteExecute_PV			: 	BOOL := FALSE;		//Execute - previous value           
            MC_MoveAbsoluteDone_PV				:	BOOL := FALSE;		//Done - previous value              
            MC_MoveAbsoluteCallNumber			: 	INT; 				//Call number of the method MC_MoveAbsolute  
            MC_MoveAbsoluteFirstCall			: 	BOOL;				//First call of the method MC_MoveAbsolute   
            MC_MoveAbsoluteDone_				:	BOOL;
            MC_MoveAbsoluteActive_				:	BOOL;
            MC_MoveAbsoluteCommandAborted_		:	BOOL;
            MC_MoveAbsoluteError_				:   BOOL;
            MC_MoveAbsoluteErrorID_				:   eAxoCmmtAsErrorCode;				
            MC_MoveAbsoluteContinuousUpdate_PV  :   BOOL;
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

            IF Execute OR (NOT Execute AND MC_MoveAbsoluteExecute_PV) THEN (*detection of falling edge execute*)
                MC_MoveAbsoluteFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    IF Execute AND NOT MC_MoveAbsoluteExecute_PV THEN (*	raising edge of EXECUTE *)
                        MC_MoveAbsoluteContinuousUpdate_PV := ContinuousUpdate;
                        _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                        MC_MoveAbsoluteCallNumber := _AxisReference^.Data.CallNumberCyclic;
                        _AxisReference^.Data.WriteCommand:= TRUE;
                        _AxisReference^.Data.HomingReq:= FALSE;
            (*			Axis.Data.DriveStopReq:= FALSE;*)
                        _AxisReference^.Data.DriveHaltReq := FALSE;		
                        _AxisReference^.Data.MoveVelocityReq:= FALSE;				
                        _AxisReference^.Data.TorqueControlReq:= FALSE;
                        _AxisReference^.Data.Relative:= FALSE;
                        _AxisReference^.Data.Additive:= FALSE;
                        _AxisReference^.Data.Position := Position;
                        _AxisReference^.Data.Velocity := Velocity;
                        _AxisReference^.Data.Acceleration := Acceleration;
                        _AxisReference^.Data.Deceleration := Deceleration;
                        _AxisReference^.Data.Jerk:= Jerk;
                        MC_MoveAbsoluteDone_ := FALSE;
                        MC_MoveAbsoluteActive_ := TRUE;
                        MC_MoveAbsoluteError_ := FALSE;
                        MC_MoveAbsoluteErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                ELSE
                    MC_MoveAbsoluteCallNumber := MC_MoveAbsoluteCallNumber - INT#1;
                    MC_MoveAbsoluteError_ := TRUE;
                    MC_MoveAbsoluteErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            (************** reset of outputs *************************************)
            IF Execute = FALSE THEN
                MC_MoveAbsoluteCommandAborted_ := FALSE;
                MC_MoveAbsoluteDone_ := FALSE;
                MC_MoveAbsoluteError_ := FALSE;
                MC_MoveAbsoluteErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            END_IF;
            (*************** detection of command finished *******************)
            IF MC_MoveAbsoluteFirstCall THEN
                IF MC_MoveAbsoluteCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                    MC_MoveAbsoluteActive_ := TRUE;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                    // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                    IF NOT _AxisReference^.Data.CommandWriteActive THEN
                        MC_MoveAbsoluteActive_ := TRUE;
                        IF MC_MoveAbsoluteContinuousUpdate_PV AND 
                            (_AxisReference^.Data.Position <> Position OR
                            _AxisReference^.Data.Velocity <> Velocity OR
                            _AxisReference^.Data.Acceleration <> Acceleration OR
                            _AxisReference^.Data.Deceleration <> Deceleration OR
                            _AxisReference^.Data.Jerk <> Jerk ) THEN
                            _AxisReference^.Data.Position := Position;
                            _AxisReference^.Data.Velocity := Velocity;
                            _AxisReference^.Data.Acceleration := Acceleration;
                            _AxisReference^.Data.Deceleration := Deceleration;
                            _AxisReference^.Data.Jerk:= Jerk;	
                            _AxisReference^.Data.WriteCommand := TRUE;
                            _AxisReference^.Data.CallAxis := TRUE;
                            _AxisReference^.Data.ReadOnlyData := FALSE;
                            // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                            RETURN;
                        END_IF;
    
                        IF _AxisReference^.Data.SetpointReached THEN
                            MC_MoveAbsoluteDone_ := TRUE;
                            MC_MoveAbsoluteActive_ := FALSE;
                            MC_MoveAbsoluteCallNumber := MC_MoveAbsoluteCallNumber - INT#1; (*Reset MC_MoveAbsoluteCallNumber because reset Done *)
                        END_IF;
                    END_IF;
                    IF _AxisReference^.Data.Error THEN
                        MC_MoveAbsoluteCallNumber := MC_MoveAbsoluteCallNumber - INT#1;
                        MC_MoveAbsoluteActive_ := FALSE;
                        MC_MoveAbsoluteError_ := TRUE;
                        MC_MoveAbsoluteErrorID_ := _AxisReference^.Data.ErrorID;
                    ELSIF _AxisReference^.Data.CallAxis THEN
                        MC_MoveAbsoluteCallNumber := MC_MoveAbsoluteCallNumber - INT#1;
                        MC_MoveAbsoluteActive_ := FALSE;
                        MC_MoveAbsoluteError_ := TRUE;
                        MC_MoveAbsoluteErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                    END_IF;
                ELSE
                    (*************** detection of command aborted ********************)
                    IF MC_MoveAbsoluteActive_ THEN
                        MC_MoveAbsoluteCommandAborted_ := TRUE;
                    END_IF;
                    MC_MoveAbsoluteActive_ := FALSE;
                END_IF;
            END_IF;
            
            IF NOT ContinuousUpdate THEN
                MC_MoveAbsoluteContinuousUpdate_PV := FALSE;
            END_IF;
            MC_MoveAbsoluteExecute_PV := Execute;
            
            Done			:=	MC_MoveAbsoluteDone_;	
            Busy			:=	Execute AND NOT Done AND NOT Error;			        
            Active			:=	MC_MoveAbsoluteActive_;				      
            CommandAborted	:=	MC_MoveAbsoluteCommandAborted_;		
            Error			:=	MC_MoveAbsoluteError_;				       
            ErrorID			:=	MC_MoveAbsoluteErrorID_;				     

        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL
            MC_MoveRelativeExecute_PV			: 	BOOL := FALSE;		//Execute - previous value                      
            MC_MoveRelativeDone_PV				:	BOOL := FALSE;		//Done - previous value                         
            MC_MoveRelativeCallNumber			: 	INT; 				//Call number of the method MC_MoveRelative     
            MC_MoveRelativeFirstCall			: 	BOOL;				//First call of the method MC_MoveRelative  	  
            MC_MoveRelativeDone_				:	BOOL;
            MC_MoveRelativeActive_				:	BOOL;
            MC_MoveRelativeCommandAborted_		:	BOOL;
            MC_MoveRelativeError_				:   BOOL;
            MC_MoveRelativeErrorID_				:   eAxoCmmtAsErrorCode;
            MC_MoveRelativeContinuousUpdate_PV  :   BOOL;
            MC_MoveRelativeDistance_PV          :   LREAL;
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

            IF Execute OR (NOT Execute AND MC_MoveRelativeExecute_PV) THEN (*detection of falling edge execute*)
                MC_MoveRelativeFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    IF Execute AND NOT MC_MoveRelativeExecute_PV THEN (*	raising edge of EXECUTE *)
                        MC_MoveRelativeDistance_PV := Distance;
                        MC_MoveRelativeContinuousUpdate_PV := ContinuousUpdate;
                        _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                        MC_MoveRelativeCallNumber := _AxisReference^.Data.CallNumberCyclic;
                        _AxisReference^.Data.WriteCommand:= TRUE;
                        _AxisReference^.Data.HomingReq:= FALSE;
            (*			Axis.Data.DriveStopReq:= FALSE;*)
                        _AxisReference^.Data.DriveHaltReq := FALSE;		
                        _AxisReference^.Data.MoveVelocityReq:= FALSE;				
                        _AxisReference^.Data.TorqueControlReq:= FALSE;
                        _AxisReference^.Data.Relative:= TRUE;
                        _AxisReference^.Data.Additive:= TRUE;
                        _AxisReference^.Data.Position := Distance;
                        _AxisReference^.Data.Velocity := Velocity;
                        _AxisReference^.Data.Acceleration := Acceleration;
                        _AxisReference^.Data.Deceleration := Deceleration;
                        _AxisReference^.Data.Jerk:= Jerk;
                        MC_MoveRelativeDone_ := FALSE;
                        MC_MoveRelativeActive_ := TRUE;
                        MC_MoveRelativeError_ := FALSE;
                        MC_MoveRelativeErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                ELSE
                    MC_MoveRelativeCallNumber := MC_MoveRelativeCallNumber - INT#1;
                    MC_MoveRelativeError_ := TRUE;
                    MC_MoveRelativeErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            (************** reset of outputs *************************************)
            IF Execute = FALSE THEN
                MC_MoveRelativeCommandAborted_ := FALSE;
                MC_MoveRelativeDone_ := FALSE;
                MC_MoveRelativeError_ := FALSE;
                MC_MoveRelativeErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                MC_MoveRelativeDistance_PV := 0;
            END_IF;
            (*************** detection of command finished *******************)
            IF MC_MoveRelativeFirstCall THEN
                IF MC_MoveRelativeCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                    MC_MoveRelativeActive_ := TRUE;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                    // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                    IF NOT _AxisReference^.Data.CommandWriteActive THEN
                        MC_MoveRelativeActive_ := TRUE;
                        IF MC_MoveRelativeContinuousUpdate_PV AND 
                            (MC_MoveRelativeDistance_PV<> Distance OR
                            _AxisReference^.Data.Velocity <> Velocity OR
                            _AxisReference^.Data.Acceleration <> Acceleration OR
                            _AxisReference^.Data.Deceleration <> Deceleration OR
                            _AxisReference^.Data.Jerk <> Jerk ) THEN
                            _AxisReference^.Data.Position := Distance-MC_MoveRelativeDistance_PV;
                            _AxisReference^.Data.Velocity := Velocity;
                            _AxisReference^.Data.Acceleration := Acceleration;
                            _AxisReference^.Data.Deceleration := Deceleration;
                            _AxisReference^.Data.Jerk:= Jerk;	
                            _AxisReference^.Data.WriteCommand := TRUE;
                            _AxisReference^.Data.CallAxis := TRUE;
                            _AxisReference^.Data.ReadOnlyData := FALSE;
                            MC_MoveRelativeDistance_PV := Distance;
                            // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                            RETURN;
                        END_IF;
    
                        IF _AxisReference^.Data.SetpointReached THEN
                            MC_MoveRelativeDone_ := TRUE;
                            MC_MoveRelativeActive_ := FALSE;
                            MC_MoveRelativeCallNumber := MC_MoveRelativeCallNumber - INT#1; (*Reset MC_MoveRelativeCallNumber because reset Done *)
                        END_IF;
                    END_IF;
                    IF _AxisReference^.Data.Error THEN
                        MC_MoveRelativeCallNumber := MC_MoveRelativeCallNumber - INT#1;
                        MC_MoveRelativeActive_ := FALSE;
                        MC_MoveRelativeError_ := TRUE;
                        MC_MoveRelativeErrorID_ := _AxisReference^.Data.ErrorID;
                    ELSIF _AxisReference^.Data.CallAxis THEN
                        MC_MoveRelativeCallNumber := MC_MoveRelativeCallNumber - INT#1;
                        MC_MoveRelativeActive_ := FALSE;
                        MC_MoveRelativeError_ := TRUE;
                        MC_MoveRelativeErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                    END_IF;
                ELSE
                    (*************** detection of command aborted ********************)
                    IF MC_MoveRelativeActive_ THEN
                        MC_MoveRelativeCommandAborted_ := TRUE;
                    END_IF;
                    MC_MoveRelativeActive_ := FALSE;
                END_IF;
            END_IF;
            
            IF NOT ContinuousUpdate THEN
                MC_MoveRelativeContinuousUpdate_PV := FALSE;
            END_IF;
            MC_MoveRelativeExecute_PV := Execute;
            
            Done			:=	MC_MoveRelativeDone_;	
            Busy			:=	Execute AND NOT Done AND NOT Error;			        
            Active			:=	MC_MoveRelativeActive_;				      
            CommandAborted	:=	MC_MoveRelativeCommandAborted_;		
            Error			:=	MC_MoveRelativeError_;				       
            ErrorID			:=	MC_MoveRelativeErrorID_;				     
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL
            MC_MoveAdditiveExecute_PV			: 	BOOL := FALSE;		//Execute - previous value              
            MC_MoveAdditiveDone_PV				:	BOOL := FALSE;		//Done - previous value                 
            MC_MoveAdditiveCallNumber			: 	INT; 				//Call number of the method MC_MoveAdditive    
            MC_MoveAdditiveFirstCall			: 	BOOL;				//First call of the method MC_MoveAdditive  
            MC_MoveAdditiveDone_				:	BOOL;
            MC_MoveAdditiveActive_				:	BOOL;
            MC_MoveAdditiveCommandAborted_		:	BOOL;
            MC_MoveAdditiveError_				:	BOOL;
            MC_MoveAdditiveErrorID_				:	eAxoCmmtAsErrorCode;	
            MC_MoveAdditiveContinuousUpdate_PV  :   BOOL;	
            MC_MoveAdditiveDistance_PV          :   LREAL;
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

            IF Execute OR (NOT Execute AND MC_MoveAdditiveExecute_PV) THEN (*detection of falling edge execute*)
                MC_MoveAdditiveFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    IF Execute AND NOT MC_MoveAdditiveExecute_PV THEN (*	raising edge of EXECUTE *)
                        MC_MoveAdditiveDistance_PV := Distance;
                        MC_MoveAdditiveContinuousUpdate_PV := ContinuousUpdate;
                        _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                        MC_MoveAdditiveCallNumber := _AxisReference^.Data.CallNumberCyclic;
                        _AxisReference^.Data.WriteCommand:= TRUE;
                        _AxisReference^.Data.HomingReq:= FALSE;
            (*			Axis.Data.DriveStopReq:= FALSE;*)
                        _AxisReference^.Data.DriveHaltReq := FALSE;		
                        _AxisReference^.Data.MoveVelocityReq:= FALSE;				
                        _AxisReference^.Data.TorqueControlReq:= FALSE;
                        _AxisReference^.Data.Relative:= TRUE;
                        _AxisReference^.Data.Additive:= FALSE;
                        _AxisReference^.Data.Position := Distance;
                        _AxisReference^.Data.Velocity := Velocity;
                        _AxisReference^.Data.Acceleration := Acceleration;
                        _AxisReference^.Data.Deceleration := Deceleration;
                        _AxisReference^.Data.Jerk:= Jerk;
                        MC_MoveAdditiveDone_ := FALSE;
                        MC_MoveAdditiveActive_ := TRUE;
                        MC_MoveAdditiveError_ := FALSE;
                        MC_MoveAdditiveErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                ELSE
                    MC_MoveAdditiveCallNumber := MC_MoveAdditiveCallNumber - INT#1;
                    MC_MoveAdditiveError_ := TRUE;
                    MC_MoveAdditiveErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            (************** reset of outputs *************************************)
            IF Execute = FALSE THEN
                MC_MoveAdditiveCommandAborted_ := FALSE;
                MC_MoveAdditiveDone_ := FALSE;
                MC_MoveAdditiveError_ := FALSE;
                MC_MoveAdditiveErrorID_ :=	AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                MC_MoveAdditiveDistance_PV := 0;
            END_IF;
            (*************** detection of command finished *******************)
            IF MC_MoveAdditiveFirstCall THEN
                IF MC_MoveAdditiveCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                    MC_MoveAdditiveActive_ := TRUE;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                    // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                    IF NOT _AxisReference^.Data.CommandWriteActive THEN
                        MC_MoveAdditiveActive_ := TRUE;
                        IF MC_MoveAdditiveContinuousUpdate_PV AND 
                            (MC_MoveAdditiveDistance_PV<> Distance OR
                            _AxisReference^.Data.Velocity <> Velocity OR
                            _AxisReference^.Data.Acceleration <> Acceleration OR
                            _AxisReference^.Data.Deceleration <> Deceleration OR
                            _AxisReference^.Data.Jerk <> Jerk ) THEN
                            _AxisReference^.Data.Position := Distance-MC_MoveAdditiveDistance_PV;
                            _AxisReference^.Data.Velocity := Velocity;
                            _AxisReference^.Data.Acceleration := Acceleration;
                            _AxisReference^.Data.Deceleration := Deceleration;
                            _AxisReference^.Data.Jerk:= Jerk;	
                            _AxisReference^.Data.WriteCommand := TRUE;
                            _AxisReference^.Data.CallAxis := TRUE;
                            _AxisReference^.Data.ReadOnlyData := FALSE;
                            MC_MoveAdditiveDistance_PV := Distance;
                            // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                            RETURN;
                        END_IF;
    
                        IF _AxisReference^.Data.SetpointReached THEN
                            MC_MoveAdditiveDone_ := TRUE;
                            MC_MoveAdditiveActive_ := FALSE;
                            MC_MoveAdditiveCallNumber := MC_MoveAdditiveCallNumber - INT#1; (*Reset MC_MoveAdditiveCallNumber because reset Done *)
                        END_IF;
                    END_IF;
                    IF _AxisReference^.Data.Error THEN
                        MC_MoveAdditiveCallNumber := MC_MoveAdditiveCallNumber - INT#1;
                        MC_MoveAdditiveActive_ := FALSE;
                        MC_MoveAdditiveError_ := TRUE;
                        MC_MoveAdditiveErrorID_ := _AxisReference^.Data.ErrorID;
                    ELSIF _AxisReference^.Data.CallAxis THEN
                        MC_MoveAdditiveCallNumber := MC_MoveAdditiveCallNumber - INT#1;
                        MC_MoveAdditiveActive_ := FALSE;
                        MC_MoveAdditiveError_ := TRUE;
                        MC_MoveAdditiveErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                    END_IF;
                ELSE
                    (*************** detection of command aborted ********************)
                    IF MC_MoveAdditiveActive_ THEN
                        MC_MoveAdditiveCommandAborted_ := TRUE;
                    END_IF;
                    MC_MoveAdditiveActive_ := FALSE;
                END_IF;
            END_IF;
            
            IF NOT ContinuousUpdate THEN
                MC_MoveAdditiveContinuousUpdate_PV := FALSE;
            END_IF;
            MC_MoveAdditiveExecute_PV := Execute;
            
            Done			:=	MC_MoveAdditiveDone_;	
            Busy			:=	Execute AND NOT Done AND NOT Error;			        
            Active			:=	MC_MoveAdditiveActive_;				      
            CommandAborted	:=	MC_MoveAdditiveCommandAborted_;		
            Error			:=	MC_MoveAdditiveError_;				       
            ErrorID			:=	MC_MoveAdditiveErrorID_;				     
        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        ///<summary>
        VAR INTERNAL
            MC_MoveVelocityExecute_PV			: 	BOOL := FALSE;		//Execute - previous value                      
            MC_MoveVelocityCallNumber			: 	INT; 				//Call number of the method MC_MoveVelocity    
            MC_MoveVelocityFirstCall			: 	BOOL;				//First call of the method MC_MoveVelocity 	   
            MC_MoveVelocityActive_				:	BOOL;
            MC_MoveVelocityCommandAborted_		:	BOOL;
            MC_MoveVelocityError_				:   BOOL;
            MC_MoveVelocityErrorID_				:   eAxoCmmtAsErrorCode;				
            MC_MoveVelocityContinuousUpdate_PV	:   BOOL;
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
                Velocity_        :   LREAL;                     
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

            IF Execute OR (NOT Execute AND MC_MoveVelocityExecute_PV) THEN (*detection of falling edge execute*)
                MC_MoveVelocityFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Execute AND NOT MC_MoveVelocityExecute_PV THEN (*	raising edge of EXECUTE *)
                        MC_MoveVelocityContinuousUpdate_PV := ContinuousUpdate;
                        _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                        MC_MoveVelocityCallNumber := _AxisReference^.Data.CallNumberCyclic;
                        _AxisReference^.Data.WriteCommand:= TRUE;
                        _AxisReference^.Data.HomingReq:= FALSE;
            (*			Axis.Data.DriveStopReq:= FALSE;*)
                        _AxisReference^.Data.DriveHaltReq := FALSE;		
                        _AxisReference^.Data.MoveVelocityReq:= TRUE;
                        _AxisReference^.Data.TorqueControlReq:= FALSE;
                        _AxisReference^.Data.Relative:= FALSE;
                        _AxisReference^.Data.Additive:= FALSE;
                        _AxisReference^.Data.Position:= 0;
                        _AxisReference^.Data.Velocity := Velocity_;
                        _AxisReference^.Data.Acceleration := Acceleration;
                        _AxisReference^.Data.Deceleration := Deceleration;
                        _AxisReference^.Data.Jerk:= Jerk;
                        MC_MoveVelocityActive_ := TRUE;
                        MC_MoveVelocityError_ := FALSE;
                        MC_MoveVelocityErrorID_ :=	 AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                ELSE
                    MC_MoveVelocityCallNumber := MC_MoveVelocityCallNumber - INT#1;
                    MC_MoveVelocityError_ := TRUE;
                    MC_MoveVelocityErrorID_ :=  AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            (************** reset of outputs *************************************)
            IF Execute = FALSE THEN
                MC_MoveVelocityCommandAborted_ := FALSE;
                MC_MoveVelocityError_ := FALSE;
                MC_MoveVelocityErrorID_ :=	 AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            END_IF;
            (*************** detection of command finished *******************)
            IF MC_MoveVelocityFirstCall THEN
                IF MC_MoveVelocityCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                    MC_MoveVelocityActive_ := TRUE;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                    // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                    IF NOT _AxisReference^.Data.CommandWriteActive THEN
                        MC_MoveVelocityActive_ := TRUE;
                        IF MC_MoveVelocityContinuousUpdate_PV AND 
                            (_AxisReference^.Data.Velocity <> Velocity_ OR
                            _AxisReference^.Data.Acceleration <> Acceleration OR
                            _AxisReference^.Data.Deceleration <> Deceleration OR
                            _AxisReference^.Data.Jerk <> Jerk ) THEN
                            _AxisReference^.Data.Velocity := Velocity;
                            _AxisReference^.Data.Acceleration := Acceleration;
                            _AxisReference^.Data.Deceleration := Deceleration;
                            _AxisReference^.Data.Jerk:= Jerk;	
                            _AxisReference^.Data.WriteCommand := TRUE;
                            _AxisReference^.Data.CallAxis := TRUE;
                            _AxisReference^.Data.ReadOnlyData := FALSE;
                            // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                        END_IF;

                    END_IF;
                    IF _AxisReference^.Data.Error THEN
                        MC_MoveVelocityCallNumber := MC_MoveVelocityCallNumber - INT#1;
                        MC_MoveVelocityActive_ := FALSE;
                        MC_MoveVelocityError_ := TRUE;
                        MC_MoveVelocityErrorID_ := _AxisReference^.Data.ErrorID;
                    ELSIF _AxisReference^.Data.CallAxis THEN
                        MC_MoveVelocityCallNumber := MC_MoveVelocityCallNumber - INT#1;
                        MC_MoveVelocityActive_ := FALSE;
                        MC_MoveVelocityError_ := TRUE;
                        MC_MoveVelocityErrorID_ :=  AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                    END_IF;
                ELSE
                    (*************** detection of command aborted ********************)
                    IF MC_MoveVelocityActive_ THEN
                        MC_MoveVelocityCommandAborted_ := TRUE;
                    END_IF;
                    MC_MoveVelocityActive_ := FALSE;
                END_IF;
            END_IF;
            MC_MoveVelocityExecute_PV := Execute;
            
            Active			:=   MC_MoveVelocityActive_ ;		
            InVelocity		:=   Active AND _AxisReference^.Data.SetpointReached;		
            Busy 			:= 	 Active AND NOT InVelocity;	      
            CommandAborted	:=   MC_MoveVelocityCommandAborted_;	
            Error			:=   MC_MoveVelocityError_;			       
            ErrorID			:=   MC_MoveVelocityErrorID_;			     
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
        VAR INTERNAL
            MC_TorqueControlExecute_PV			: 	BOOL := FALSE;		//Execute - previous value                      
            MC_TorqueControlCallNumber			: 	INT; 				//Call number of the method MC_TorqueControl    
            MC_TorqueControlFirstCall			: 	BOOL;				//First call of the method MC_TorqueControl 	   
            MC_TorqueControlActive_				:	BOOL;
            MC_TorqueControlCommandAborted_		:	BOOL;
            MC_TorqueControlError_				:   BOOL;
            MC_TorqueControlErrorID_			:   eAxoCmmtAsErrorCode;		
            MC_TorqueControlContinuousUpdate_PV :   BOOL;			
        END_VAR
        METHOD PUBLIC OVERRIDE MC_TorqueControl
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
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
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#717,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#739,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection, eAxoMessageCategory#ProgrammingError);

            IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection THEN
                Torque_ := Torque;
            ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection THEN
                Torque_ := -1 * Torque;
            ELSE
                RETURN;
            END_IF; 

                        
            IF Execute OR (NOT Execute AND MC_TorqueControlExecute_PV) THEN (*detection of falling edge execute*)
                MC_TorqueControlFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Execute AND NOT MC_TorqueControlExecute_PV THEN (*raising edge of EXECUTE *)
                        MC_TorqueControlContinuousUpdate_PV := ContinuousUpdate;
                        _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                        MC_TorqueControlCallNumber := _AxisReference^.Data.CallNumberCyclic;
                        _AxisReference^.Data.WriteCommand:= TRUE;
                        _AxisReference^.Data.HomingReq:= FALSE;
            (*			Axis.Data.DriveStopReq:= FALSE;*)
                        _AxisReference^.Data.DriveHaltReq := FALSE;		
                        _AxisReference^.Data.MoveVelocityReq:= FALSE;
                        _AxisReference^.Data.TorqueControlReq:= TRUE;
                        _AxisReference^.Data.Relative:= FALSE;
                        _AxisReference^.Data.Additive:= FALSE;
                        _AxisReference^.Data.Position:= 0;
                        _AxisReference^.Data.Velocity := Velocity;
                        _AxisReference^.Data.Acceleration := Acceleration;
                        _AxisReference^.Data.Deceleration := Deceleration;
                        _AxisReference^.Data.Jerk:= Jerk;
                        _AxisReference^.Data.Torque:= Torque_;
                        MC_TorqueControlActive_ := TRUE;
                        MC_TorqueControlError_ := FALSE;
                        MC_TorqueControlErrorID_ :=	 AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                ELSE
                    MC_TorqueControlCallNumber := MC_TorqueControlCallNumber - INT#1;
                    MC_TorqueControlError_ := TRUE;
                    MC_TorqueControlErrorID_ :=  AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            (************** reset of outputs *************************************)
            IF Execute = FALSE THEN
                MC_TorqueControlCommandAborted_ := FALSE;
                MC_TorqueControlError_ := FALSE;
                MC_TorqueControlErrorID_ :=	 AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            END_IF;
            (*************** detection of command finished *******************)
            IF MC_TorqueControlFirstCall THEN
                IF MC_TorqueControlCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                    MC_TorqueControlActive_ := TRUE;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                    // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                    IF NOT _AxisReference^.Data.CommandWriteActive THEN
                        MC_TorqueControlActive_ := TRUE;
                        IF MC_TorqueControlContinuousUpdate_PV AND 
                            (_AxisReference^.Data.Torque <> Torque_ OR
                            // _AxisReference^.Data.TorqueRamp <> TorqueRamp OR
                            _AxisReference^.Data.Velocity <> Velocity OR
                            _AxisReference^.Data.Acceleration <> Acceleration OR
                            _AxisReference^.Data.Deceleration <> Deceleration OR
                            _AxisReference^.Data.Jerk <> Jerk ) THEN
                            _AxisReference^.Data.Torque := Torque_ ;
                            _AxisReference^.Data.Velocity := Velocity;
                            _AxisReference^.Data.Acceleration := Acceleration;
                            _AxisReference^.Data.Deceleration := Deceleration;
                            _AxisReference^.Data.Jerk:= Jerk;	
                            _AxisReference^.Data.WriteCommand := TRUE;
                            _AxisReference^.Data.CallAxis := TRUE;
                            _AxisReference^.Data.ReadOnlyData := FALSE;
                            // THIS.FieldBusCommunication(AxisRef := _AxisReference,CommandWriteActive=> Dummy);
                        END_IF;

                    END_IF;
                    IF _AxisReference^.Data.Error THEN
                        MC_TorqueControlCallNumber := MC_TorqueControlCallNumber - INT#1;
                        MC_TorqueControlActive_ := FALSE;
                        MC_TorqueControlError_ := TRUE;
                        MC_TorqueControlErrorID_ := _AxisReference^.Data.ErrorID;
                    ELSIF _AxisReference^.Data.CallAxis THEN
                        MC_TorqueControlCallNumber := MC_TorqueControlCallNumber - INT#1;
                        MC_TorqueControlActive_ := FALSE;
                        MC_TorqueControlError_ := TRUE;
                        MC_TorqueControlErrorID_ :=  AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                    END_IF;
                ELSE
                    (*************** detection of command aborted ********************)
                    IF MC_TorqueControlActive_ THEN
                        MC_TorqueControlCommandAborted_ := TRUE;
                    END_IF;
                    MC_TorqueControlActive_ := FALSE;
                END_IF;
            END_IF;
            MC_TorqueControlExecute_PV := Execute;
            
            Active			:=   MC_TorqueControlActive_;		
            InTorque		:=   Active AND _AxisReference^.Data.SetpointReached;			        
            Busy 			:= 	 Active AND NOT InTorque;	      
            CommandAborted	:=   MC_TorqueControlCommandAborted_;	
            Error			:=   MC_TorqueControlError_;			       
            ErrorID			:=   MC_TorqueControlErrorID_;			     

        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
        VAR INTERNAL
            MC_SetPositionDone_					:	BOOL; 							
            MC_SetPositionBusy_					:	BOOL; 							
            MC_SetPositionError_ 				:	BOOL; 							
            MC_SetPositionErrorID_ 				:	eAxoCmmtAsErrorCode; 							
            MC_SetPositionState_ 				:	UINT; 							
            MC_SetPositionValue_ 				:	DINT; 							
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
                _result : AXOpen.Core.IAxoTaskState;
                _ErrorID    :   eAxoCmmtAsErrorCode;
                _Valid  :   BOOL;
                _Error  :   BOOL;
                _Position   :   LREAL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#718,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Execute THEN
                IF MC_SetPositionState_ = UINT#0 THEN
                    MC_SetPositionDone_ := FALSE;
                    MC_SetPositionBusy_ := TRUE;
                    MC_SetPositionError_ := FALSE; 
                    MC_SetPositionErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    MC_SetPositionValue_ := 0;
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                END_IF;
            END_IF;	
            IF MC_SetPositionState_ = UINT#10 THEN
                IF ExecutionMode = AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately OR ExecutionMode =AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Queued AND _AxisReference^.Data.Standstill THEN
                    IF Relative THEN
                        MC_SetPositionValue_ := MC_SetPositionValue_ + TO_DINT(Position * EXP(LN(10)*PositionExponent));
                        MC_SetPositionState_ := MC_SetPositionState_ + UINT#30;	
                    ELSE	
                        MC_SetPositionValue_ := MC_SetPositionValue_ + TO_DINT(Position * EXP(LN(10)*PositionExponent));
                        MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                    END_IF;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#20 THEN
                THIS.AxoReadActualPosition(Enable := TRUE,Valid => _Valid, Error => _Error,ErrorID => _ErrorID, Position => _Position);
                IF _Error THEN
                    MC_SetPositionError_ 		:= TRUE;
                    MC_SetPositionErrorID_ 		:= _ErrorID;
                END_IF;
                IF _Valid THEN
                    MC_SetPositionValue_ := MC_SetPositionValue_ - TO_DINT((_Position ) * EXP(LN(10)*PositionExponent));
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#30 THEN
                THIS.AxoReadActualPosition(Enable := FALSE,Valid => _Valid, Error => _Error,ErrorID => _ErrorID, Position => _Position);
                IF NOT _Valid THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#40 THEN
                //S-0-0275, Coordinate offset value
                _result := THIS.AxoWriteParameter(ParameterNumber := 275, Value := MC_SetPositionValue_ ,ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately, ErrorID =>_ErrorID);
                IF _result.IsDone() THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                END_IF;
                IF _result.HasError() THEN
                    MC_SetPositionError_ 		:= TRUE;
                    MC_SetPositionErrorID_ 		:= _ErrorID;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#50 THEN
                AxoWriteParameter_Task.Restore();
                IF(AxoWriteParameter_Task.IsReady()) THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                    RETURN;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#60 THEN
                //S-0-0199, C3400 Shift coordinate system procedure command
                _result := THIS.AxoWriteParameter(ParameterNumber := 199, Value := 3 ,ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately, ErrorID =>_ErrorID);
                IF _result.IsDone() THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                END_IF;
                IF _result.HasError() THEN
                    MC_SetPositionError_ 		:= TRUE;
                    MC_SetPositionErrorID_ 		:= _ErrorID;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#70 THEN
                AxoWriteParameter_Task.Restore();
                IF(AxoWriteParameter_Task.IsReady()) THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                    RETURN;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#80 THEN
                //S-0-0199, C3400 Shift coordinate system procedure command
                _result := THIS.AxoWriteParameter(ParameterNumber := 199, Value := 0 ,ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately, ErrorID =>_ErrorID);
                IF _result.IsDone() THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                END_IF;
                IF _result.HasError() THEN
                    MC_SetPositionError_ 		:= TRUE;
                    MC_SetPositionErrorID_ 		:= _ErrorID;
                END_IF;
            END_IF;
            IF MC_SetPositionState_ = UINT#90 THEN
                AxoWriteParameter_Task.Restore();
                IF(AxoWriteParameter_Task.IsReady()) THEN
                    MC_SetPositionState_ := MC_SetPositionState_ + UINT#10;	
                    RETURN;
                END_IF;
            END_IF;
            
            IF MC_SetPositionState_ = UINT#100 THEN
                MC_SetPositionDone_ := TRUE;
                MC_SetPositionBusy_ := FALSE;
            END_IF;

            Done				:=	MC_SetPositionDone_;
            Busy 				:=	MC_SetPositionBusy_;
            Error 				:=	MC_SetPositionError_;
            ErrorID 			:=	MC_SetPositionErrorID_;	
            
            
            IF NOT Execute THEN
                MC_SetPositionDone_ := FALSE;
                MC_SetPositionBusy_ := FALSE;
                MC_SetPositionError_ := FALSE; 
                MC_SetPositionErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                MC_SetPositionState_ := UINT#0;
            END_IF;
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

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            IF Enable THEN
                Busy := TRUE;
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    IF VelocityFactor <= 0.0 OR  VelocityFactor > 1.0 OR AccelerationFactor <= 0.0 OR  AccelerationFactor > 1.0 OR JerkFactor <= 0.0 OR  JerkFactor > 1.0 THEN
                        Enabled	:= FALSE;
                        Busy := FALSE;
                        Error := TRUE;
                        ErrorID:= AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#INPUT_RANGE_ERROR;
                    ELSE
                        _AxisReference^.Data.CallAxis := TRUE;
                        IF _AxisReference^.Data.OverrideVelocityFactor <> VelocityFactor OR _AxisReference^.Data.OverrideAccelerationFactor <> AccelerationFactor OR  _AxisReference^.Data.OverrideJerkFactor <> JerkFactor THEN   
                            _AxisReference^.Data.OverrideVelocityFactor := VelocityFactor;  
                            _AxisReference^.Data.OverrideAccelerationFactor := AccelerationFactor;
                            _AxisReference^.Data.OverrideJerkFactor := JerkFactor;    
                            _AxisReference^.Data.WriteCommand := TRUE;
                        END_IF;; 
                        _AxisReference^.Data.ReadOnlyData := FALSE;
                        // THIS.FieldBusCommunication(AxisRef := _AxisReference, CommandWriteActive=> Dummy);
                        Enabled := TRUE;
                        Busy := FALSE;
                        Error := FALSE;
                        ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                ELSE
                    Enabled	:= FALSE;
                    Busy := FALSE;
                    Error := TRUE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            ELSE
                Enabled	:= FALSE;
                Busy := FALSE;
                Error := FALSE;
                ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;	
            END_IF;


        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        VAR INTERNAL 
            MC_ReadParameterEnable_PV			: 	BOOL := FALSE;		//Enable - previous value
            MC_ReadParameterDone_PV				:	BOOL := FALSE;		//Done - previous value
            MC_ReadParameterCallNumber			: 	INT; 				//Call number of the method MC_ReadParameter
            MC_ReadParameterNumber_PV			: 	DINT;				//ParameterNumber - previous value (stored at rising edge of the Enable) 
            MC_ReadParameterFirstCall			: 	BOOL;				//First call of the method MC_ReadParameter
            MC_ReadParameterDone_				:	BOOL;							
            MC_ReadParameterActive_				:	BOOL := FALSE;					
            MC_ReadParameterError_				:	BOOL;							
            MC_ReadParameterErrorID_			:	eAxoCmmtAsErrorCode;						
            MC_ReadParameterValue_				:	DINT;							
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
                Value           :   DINT;                       //  Value of the specified parameter in the datatype, as specified by the vendor
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

            IF Enable THEN
                MC_ReadParameterFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Enable AND NOT MC_ReadParameterEnable_PV THEN(*	raising edge of Enable *)
                        IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                            _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                            MC_ReadParameterCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                            MC_ReadParameterNumber_PV := ParameterNumber;
                            _AxisReference^.Data.WriteParameter := FALSE;
                            _AxisReference^.Data.SelectDataType := UINT#1;
                            _AxisReference^.Data.ParameterNumber := MC_ReadParameterNumber_PV;
                            MC_ReadParameterError_ := FALSE;
                            MC_ReadParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                        ELSE
                            MC_ReadParameterError_ := TRUE;
                            MC_ReadParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                        END_IF;
                    END_IF;
                ELSE
                    MC_ReadParameterCallNumber := MC_ReadParameterCallNumber - INT#1;
                    MC_ReadParameterError_ := TRUE;
                    MC_ReadParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            IF MC_ReadParameterFirstCall THEN
                IF MC_ReadParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Enable	THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                    Busy := _AxisReference^.Data.ActiveAcyclicCommunication;
                    IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                        MC_ReadParameterDone_ := TRUE;
                        MC_ReadParameterActive_ := FALSE;
                        MC_ReadParameterValue_ := _AxisReference^.Data.ReadValueDint;
                    END_IF;
                    IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                        MC_ReadParameterCallNumber := MC_ReadParameterCallNumber - INT#1;
                        MC_ReadParameterDone_ := FALSE;
                        MC_ReadParameterActive_ := FALSE;
                        MC_ReadParameterError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                        MC_ReadParameterErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    ELSIF  _AxisReference^.Data.CallAxisParameterMethod THEN
                        MC_ReadParameterCallNumber := MC_ReadParameterCallNumber - INT#1;
                        MC_ReadParameterDone_ := FALSE;
                        MC_ReadParameterActive_ := FALSE;
                        MC_ReadParameterError_ := TRUE;
                        MC_ReadParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    END_IF;
                ELSIF Enable AND MC_ReadParameterEnable_PV AND MC_ReadParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_ReadParameterDone_ := FALSE;
                    MC_ReadParameterActive_ := FALSE;
                    MC_ReadParameterValue_ := DINT#0;
                    MC_ReadParameterError_ := FALSE;
                    MC_ReadParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSIF NOT Enable AND MC_ReadParameterEnable_PV THEN
                    MC_ReadParameterDone_ := FALSE;
                    MC_ReadParameterActive_ := FALSE;
                    MC_ReadParameterValue_ := DINT#0;
                    MC_ReadParameterError_ := FALSE;
                    MC_ReadParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    _AxisReference^.Data.ActiveAcyclicCommunication := FALSE;
                    _AxisReference^.Data.DoneAcyclicCommunication := FALSE;
                END_IF;
            END_IF;
            MC_ReadParameterEnable_PV := Enable;
            
            Valid			:= 	MC_ReadParameterDone_;				           
            Busy			:= 	MC_ReadParameterActive_;				  
            Error			:= 	MC_ReadParameterError_;				          
            ErrorID			:= 	MC_ReadParameterErrorID_;				    
            IF Valid THEN
                Value			:= 	MC_ReadParameterValue_;
            ELSE
                Value			:= 	0;
            END_IF;					          
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype REAL.
        ///<summary>
        VAR INTERNAL
            MC_ReadRealParameterEnable_PV		: 	BOOL := FALSE;		//Enable - previous value                                                
            MC_ReadRealParameterDone_PV			:	BOOL := FALSE;		//Done - previous value                                                  
            MC_ReadRealParameterCallNumber		: 	INT; 				//Call number of the method MC_ReadRealParameter                             
            MC_ReadRealParameterNumber_PV		: 	DINT;				//ParameterNumber - previous value (stored at rising edge of the Enable) 
            MC_ReadRealParameterFirstCall		: 	BOOL;				//First call of the method MC_ReadRealParameter                              
            MC_ReadRealParameterDone_			:	BOOL;							
            MC_ReadRealParameterActive_			:	BOOL := FALSE;					
            MC_ReadRealParameterError_			:	BOOL;							
            MC_ReadRealParameterErrorID_		:	eAxoCmmtAsErrorCode;						
            MC_ReadRealParameterValue_			:	REAL;							
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

            IF Enable THEN
                MC_ReadRealParameterFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Enable AND NOT MC_ReadRealParameterEnable_PV THEN(*	raising edge of Enable *)
                        IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                            _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                            MC_ReadRealParameterCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                            MC_ReadRealParameterNumber_PV := ParameterNumber;
                            _AxisReference^.Data.WriteParameter := FALSE;
                            _AxisReference^.Data.SelectDataType := UINT#2;
                            _AxisReference^.Data.ParameterNumber := MC_ReadRealParameterNumber_PV;
                            MC_ReadRealParameterError_ := FALSE;
                            MC_ReadRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                        ELSE
                            MC_ReadRealParameterError_ := TRUE;
                            MC_ReadRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                        END_IF;
                    END_IF;
                ELSE
                    MC_ReadRealParameterCallNumber := MC_ReadRealParameterCallNumber - INT#1;
                    MC_ReadRealParameterError_ := TRUE;
                    MC_ReadRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            IF MC_ReadRealParameterFirstCall THEN
                IF MC_ReadRealParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Enable	THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                    Busy := _AxisReference^.Data.ActiveAcyclicCommunication;
                    IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                        MC_ReadRealParameterDone_ := TRUE;
                        MC_ReadRealParameterActive_ := FALSE;
                        MC_ReadRealParameterValue_ := _AxisReference^.Data.ReadValueReal;
                    END_IF;
                    IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                        MC_ReadRealParameterCallNumber := MC_ReadRealParameterCallNumber - INT#1;
                        MC_ReadRealParameterDone_ := FALSE;
                        MC_ReadRealParameterActive_ := FALSE;
                        MC_ReadRealParameterError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                        MC_ReadRealParameterErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    ELSIF  _AxisReference^.Data.CallAxisParameterMethod THEN
                        MC_ReadRealParameterCallNumber := MC_ReadRealParameterCallNumber - INT#1;
                        MC_ReadRealParameterDone_ := FALSE;
                        MC_ReadRealParameterActive_ := FALSE;
                        MC_ReadRealParameterError_ := TRUE;
                        MC_ReadRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    END_IF;
                ELSIF Enable AND MC_ReadRealParameterEnable_PV AND MC_ReadRealParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_ReadRealParameterDone_ := FALSE;
                    MC_ReadRealParameterActive_ := FALSE;
                    MC_ReadRealParameterValue_ := 0;
                    MC_ReadRealParameterError_ := FALSE;
                    MC_ReadRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSIF NOT Enable AND MC_ReadRealParameterEnable_PV THEN
                    MC_ReadRealParameterDone_ := FALSE;
                    MC_ReadRealParameterActive_ := FALSE;
                    MC_ReadRealParameterValue_ := 0;
                    MC_ReadRealParameterError_ := FALSE;
                    MC_ReadRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    _AxisReference^.Data.ActiveAcyclicCommunication := FALSE;
                    _AxisReference^.Data.DoneAcyclicCommunication := FALSE;
                END_IF;
            END_IF;
            MC_ReadRealParameterEnable_PV := Enable;
            
            Valid			:= 	MC_ReadRealParameterDone_;				           
            Busy			:= 	MC_ReadRealParameterActive_;				  
            Error			:= 	MC_ReadRealParameterError_;				          
            ErrorID			:= 	MC_ReadRealParameterErrorID_;				    
            IF Valid THEN
                Value			:= 	MC_ReadRealParameterValue_;
            ELSE
                Value			:= 	0;
            END_IF;					          
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        ///<summary>
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

        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter.
        ///<summary>
        VAR INTERNAL
            MC_WriteParameterExecute_PV			: 	BOOL := FALSE;		//Execute - previous value                         
            MC_WriteParameterDone_PV			:	BOOL := FALSE;		//Done - previous value                           
            MC_WriteParameterCallNumber			: 	DINT; 				//Call number of the method MC_WriteParameter  
            MC_WriteParameterFirstCall			: 	BOOL;				//First call of the method MC_WriteParameter 
            MC_WriteParameterDone_				:	BOOL;				
            MC_WriteParameterActive_			:	BOOL := FALSE;		
            MC_WriteParameterError_				:	BOOL;				
            MC_WriteParameterErrorID_			:	eAxoCmmtAsErrorCode;			
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   DINT;                       //  New value of the specified parameter
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

            IF Execute THEN
                MC_WriteParameterFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Execute AND NOT MC_WriteParameterExecute_PV THEN(*	raising edge of Execute *)
                        IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                            _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                            MC_WriteParameterCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                            _AxisReference^.Data.WriteParameter := TRUE;
                            _AxisReference^.Data.SelectDataType := UINT#1;
                            _AxisReference^.Data.ParameterNumber := ParameterNumber;
                            _AxisReference^.Data.WriteValueDint := Value;
                            MC_WriteParameterError_ := FALSE;
                            MC_WriteParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                        ELSE
                            MC_WriteParameterError_ := TRUE;
                            MC_WriteParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                        END_IF;
                    END_IF;
                ELSE
                    MC_WriteParameterCallNumber := MC_WriteParameterCallNumber - INT#1;
                    MC_WriteParameterError_ := TRUE;
                    MC_WriteParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            IF MC_WriteParameterFirstCall THEN
                IF MC_WriteParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Execute THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                    // THIS.AcyclicCommunicationCall(AxisRef := _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_WriteParameterActive_ := _AxisReference^.Data.ActiveAcyclicCommunication;
                    IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                        MC_WriteParameterCallNumber := MC_WriteParameterCallNumber - INT#1;
                        MC_WriteParameterDone_ := TRUE;
                        MC_WriteParameterActive_ := FALSE;
                    END_IF;
                    IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                        MC_WriteParameterCallNumber := MC_WriteParameterCallNumber - INT#1;
                        MC_WriteParameterDone_ := FALSE;
                        MC_WriteParameterActive_ := FALSE;
                        MC_WriteParameterError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                        MC_WriteParameterErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef := _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    ELSIF _AxisReference^.Data.CallAxisParameterMethod THEN
                        MC_WriteParameterCallNumber := MC_WriteParameterCallNumber - INT#1;
                        MC_WriteParameterDone_ := FALSE;
                        MC_WriteParameterActive_ := FALSE;
                        MC_WriteParameterError_ := TRUE;
                        MC_WriteParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    END_IF;
                ELSIF NOT Execute AND NOT MC_WriteParameterExecute_PV AND MC_WriteParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    // THIS.AcyclicCommunicationCall(AxisRef := _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_WriteParameterDone_ := FALSE;
                    MC_WriteParameterActive_ := FALSE;
                    MC_WriteParameterError_ := FALSE;
                    MC_WriteParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSIF NOT Execute AND MC_WriteParameterExecute_PV THEN
                    MC_WriteParameterDone_ := FALSE;
                    MC_WriteParameterActive_ := FALSE;
                    MC_WriteParameterError_ := FALSE;
                    MC_WriteParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                END_IF;
            END_IF;
            MC_WriteParameterExecute_PV := Execute;
            
            Done		:= MC_WriteParameterDone_;			
            Busy 		:= MC_WriteParameterActive_;		
            Error 		:= MC_WriteParameterError_;				
            ErrorID 	:= MC_WriteParameterErrorID_;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type Real.
        ///<summary>
        VAR INTERNAL
            MC_WriteRealParameterExecute_PV		: 	BOOL := FALSE;		//Execute - previous value                                               
            MC_WriteRealParameterDone_PV		:	BOOL := FALSE;		//Done - previous value                                                  
            MC_WriteRealParameterCallNumber		: 	INT; 				//Call number of the method MC_WriteRealParameter                            
            MC_WriteRealParameterFirstCall		: 	BOOL;				//First call of the method MC_WriteRealParameter                             
            MC_WriteRealParameterDone_			:	BOOL;				
            MC_WriteRealParameterActive_		:	BOOL := FALSE;		
            MC_WriteRealParameterError_			:	BOOL;				
            MC_WriteRealParameterErrorID_		:	eAxoCmmtAsErrorCode;			
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

            IF Execute THEN
                MC_WriteRealParameterFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Execute AND NOT MC_WriteRealParameterExecute_PV THEN (*	raising edge of Execute *)
                        IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                            _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                            MC_WriteRealParameterCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                            _AxisReference^.Data.WriteParameter := TRUE;
                            _AxisReference^.Data.SelectDataType := UINT#2;
                            _AxisReference^.Data.ParameterNumber := ParameterNumber;
                            _AxisReference^.Data.WriteValueReal := Value;
                            MC_WriteRealParameterError_ := FALSE;
                            MC_WriteRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                        ELSE
                            MC_WriteRealParameterError_ := TRUE;
                            MC_WriteRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                        END_IF;
                    END_IF;
                ELSE
                    MC_WriteRealParameterCallNumber := MC_WriteRealParameterCallNumber - INT#1;
                    MC_WriteRealParameterError_ := TRUE;
                    MC_WriteRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            IF MC_WriteRealParameterFirstCall THEN
                IF MC_WriteRealParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Execute THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                    // THIS.AcyclicCommunicationCall(AxisRef := _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_WriteRealParameterActive_ := _AxisReference^.Data.ActiveAcyclicCommunication;
                    IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                        MC_WriteRealParameterCallNumber := MC_WriteRealParameterCallNumber - INT#1;
                        MC_WriteRealParameterDone_ := TRUE;
                        MC_WriteRealParameterActive_ := FALSE;
                    END_IF;
                    IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                        MC_WriteRealParameterCallNumber := MC_WriteRealParameterCallNumber - INT#1;
                        MC_WriteRealParameterDone_ := FALSE;
                        MC_WriteRealParameterActive_ := FALSE;
                        MC_WriteRealParameterError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                        MC_WriteRealParameterErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef := _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    ELSIF  _AxisReference^.Data.CallAxisParameterMethod THEN
                        MC_WriteRealParameterCallNumber := MC_WriteRealParameterCallNumber - INT#1;
                        MC_WriteRealParameterDone_ := FALSE;
                        MC_WriteRealParameterActive_ := FALSE;
                        MC_WriteRealParameterError_ := TRUE;
                        MC_WriteRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    END_IF;
                ELSIF NOT Execute AND MC_WriteRealParameterExecute_PV AND MC_WriteRealParameterCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    // THIS.AcyclicCommunicationCall(AxisRef := _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_WriteRealParameterDone_ := FALSE;
                    MC_WriteRealParameterActive_ := FALSE;
                    MC_WriteRealParameterError_ := FALSE;
                    MC_WriteRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSIF NOT Execute AND MC_WriteRealParameterExecute_PV THEN
                    MC_WriteRealParameterDone_ := FALSE;
                    MC_WriteRealParameterActive_ := FALSE;
                    MC_WriteRealParameterError_ := FALSE;
                    MC_WriteRealParameterErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                END_IF;
            END_IF;
            MC_WriteRealParameterExecute_PV := Execute;
            
            Done			:= MC_WriteRealParameterDone_;		    
            Busy			:= MC_WriteRealParameterActive_;	   
            Error			:= MC_WriteRealParameterError_;		   
            ErrorID			:= MC_WriteRealParameterErrorID_;	  
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type BOOL.
        ///<summary>
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

        END_METHOD

        ///<summary>
        /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        /// It provides the value of the referenced input (BOOL).
        ///<summary>
        VAR INTERNAL
            MC_ReadDigitalInputEnable_PV		: 	BOOL := FALSE;		//Enable - previous value
            MC_ReadDigitalInputDone_PV			:	BOOL := FALSE;		//Done - previous value
            MC_ReadDigitalInputCallNumber		: 	INT; 				//Call number of the method MC_ReadDigitalInput
            MC_ReadDigitalInputNumber_PV		: 	DINT;				//DigitalInputNumber - previous value (stored at rising edge of the Enable) 
            MC_ReadDigitalInputFirstCall		: 	BOOL;				//First call of the method MC_ReadDigitalInput
            MC_ReadDigitalInputDone_			:	BOOL;							
            MC_ReadDigitalInputActive_			:	BOOL := FALSE;					
            MC_ReadDigitalInputError_			:	BOOL;							
            MC_ReadDigitalInputErrorID_			:	eAxoCmmtAsErrorCode;						
            MC_ReadDigitalInputValue_			:	DINT;							
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

            IF Enable THEN
                MC_ReadDigitalInputFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Enable AND NOT MC_ReadDigitalInputEnable_PV THEN(*	raising edge of Enable *)
                        IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                            _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                            MC_ReadDigitalInputCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                            MC_ReadDigitalInputNumber_PV := DINT#33071;
                            _AxisReference^.Data.WriteParameter := FALSE;
                            _AxisReference^.Data.SelectDataType := UINT#1;
                            _AxisReference^.Data.ParameterNumber := MC_ReadDigitalInputNumber_PV;
                            MC_ReadDigitalInputError_ := FALSE;
                            MC_ReadDigitalInputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                        ELSE
                            MC_ReadDigitalInputError_ := TRUE;
                            MC_ReadDigitalInputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                        END_IF;
                    END_IF;
                ELSE
                    MC_ReadDigitalInputCallNumber := MC_ReadDigitalInputCallNumber - INT#1;
                    MC_ReadDigitalInputError_ := TRUE;
                    MC_ReadDigitalInputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            IF MC_ReadDigitalInputFirstCall THEN
                IF MC_ReadDigitalInputCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Enable	THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                    Busy := _AxisReference^.Data.ActiveAcyclicCommunication;
                    IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                        MC_ReadDigitalInputDone_ := TRUE;
                        MC_ReadDigitalInputActive_ := FALSE;
                        MC_ReadDigitalInputValue_ := _AxisReference^.Data.ReadValueDint;
                    END_IF;
                    IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                        MC_ReadDigitalInputCallNumber := MC_ReadDigitalInputCallNumber - INT#1;
                        MC_ReadDigitalInputDone_ := FALSE;
                        MC_ReadDigitalInputActive_ := FALSE;
                        MC_ReadDigitalInputError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                        MC_ReadDigitalInputErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    ELSIF  _AxisReference^.Data.CallAxisParameterMethod THEN
                        MC_ReadDigitalInputCallNumber := MC_ReadDigitalInputCallNumber - INT#1;
                        MC_ReadDigitalInputDone_ := FALSE;
                        MC_ReadDigitalInputActive_ := FALSE;
                        MC_ReadDigitalInputError_ := TRUE;
                        MC_ReadDigitalInputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    END_IF;
                ELSIF Enable AND MC_ReadDigitalInputEnable_PV AND MC_ReadDigitalInputCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);
                    MC_ReadDigitalInputDone_ := FALSE;
                    MC_ReadDigitalInputActive_ := FALSE;
                    MC_ReadDigitalInputValue_ := DINT#0;
                    MC_ReadDigitalInputError_ := FALSE;
                    MC_ReadDigitalInputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSIF NOT Enable AND MC_ReadDigitalInputEnable_PV THEN
                    MC_ReadDigitalInputDone_ := FALSE;
                    MC_ReadDigitalInputActive_ := FALSE;
                    MC_ReadDigitalInputValue_ := DINT#0;
                    MC_ReadDigitalInputError_ := FALSE;
                    MC_ReadDigitalInputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    _AxisReference^.Data.ActiveAcyclicCommunication := FALSE;
                    _AxisReference^.Data.DoneAcyclicCommunication := FALSE;
                END_IF;
            END_IF;
            MC_ReadDigitalInputEnable_PV := Enable;
            
            Valid			:= 	MC_ReadDigitalInputDone_;				           
            Busy			:= 	MC_ReadDigitalInputActive_;				  
            Error			:= 	MC_ReadDigitalInputError_;				          
            ErrorID			:= 	MC_ReadDigitalInputErrorID_;	
            			    
            IF Valid THEN
                IF InputNumber >=0 AND InputNumber <=15 THEN
                    Value			:= 	System.BitAccess.GetBit(TO_DWORD(MC_ReadDigitalInputValue_),TO_USINT(InputNumber));
                END_IF;
            ELSE
                Value			:= 	FALSE;
            END_IF;			          
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
        VAR INTERNAL
            MC_ReadDigitalOutputEnable_PV		: 	BOOL := FALSE;		//Enable - previous value
            MC_ReadDigitalOutputDone_PV			:	BOOL := FALSE;		//Done - previous value
            MC_ReadDigitalOutputCallNumber		: 	INT; 				//Call number of the method MC_ReadDigitalOutput
            MC_ReadDigitalOutputNumber_PV		: 	DINT;				//DigitalIOutputNumber - previous value (stored at rising edge of the Enable) 
            MC_ReadDigitalOutputFirstCall		: 	BOOL;				//First call of the method MC_ReadDigitalOutput
            MC_ReadDigitalOutputDone_			:	BOOL;							
            MC_ReadDigitalOutputActive_			:	BOOL := FALSE;					
            MC_ReadDigitalOutputError_			:	BOOL;							
            MC_ReadDigitalOutputErrorID_		:	eAxoCmmtAsErrorCode;						
            MC_ReadDigitalOutputValue_			:	DINT;							
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

            IF Enable THEN
                MC_ReadDigitalOutputFirstCall := TRUE;
                IF _AxisReference^.Data.CheckAccessOK THEN
                    IF Enable AND NOT MC_ReadDigitalOutputEnable_PV THEN(*	raising edge of Enable *)
                        IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                            _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                            MC_ReadDigitalOutputCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                            MC_ReadDigitalOutputNumber_PV := DINT#33072; (*P-0-0304, Digital outputs, output image device*)
                            _AxisReference^.Data.WriteParameter := FALSE;
                            _AxisReference^.Data.SelectDataType := UINT#1;
                            _AxisReference^.Data.ParameterNumber := MC_ReadDigitalOutputNumber_PV;
                            MC_ReadDigitalOutputError_ := FALSE;
                            MC_ReadDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                        ELSE
                            MC_ReadDigitalOutputError_ := TRUE;
                            MC_ReadDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                        END_IF;
                    END_IF;
                ELSE
                    MC_ReadDigitalOutputCallNumber := MC_ReadDigitalOutputCallNumber - INT#1;
                    MC_ReadDigitalOutputError_ := TRUE;
                    MC_ReadDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            IF MC_ReadDigitalOutputFirstCall THEN
                IF MC_ReadDigitalOutputCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Enable	THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                    Busy := _AxisReference^.Data.ActiveAcyclicCommunication;
                    IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                        MC_ReadDigitalOutputDone_ := TRUE;
                        MC_ReadDigitalOutputActive_ := FALSE;
                        MC_ReadDigitalOutputValue_ := _AxisReference^.Data.ReadValueDint;
                    END_IF;
                    IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                        MC_ReadDigitalOutputCallNumber := MC_ReadDigitalOutputCallNumber - INT#1;
                        MC_ReadDigitalOutputDone_ := FALSE;
                        MC_ReadDigitalOutputActive_ := FALSE;
                        MC_ReadDigitalOutputError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                        MC_ReadDigitalOutputErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                    ELSIF  _AxisReference^.Data.CallAxisParameterMethod THEN
                        MC_ReadDigitalOutputCallNumber := MC_ReadDigitalOutputCallNumber - INT#1;
                        MC_ReadDigitalOutputDone_ := FALSE;
                        MC_ReadDigitalOutputActive_ := FALSE;
                        MC_ReadDigitalOutputError_ := TRUE;
                        MC_ReadDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    END_IF;
                ELSIF Enable AND MC_ReadDigitalOutputEnable_PV AND MC_ReadDigitalOutputCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                    _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                    _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                    // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                    MC_ReadDigitalOutputDone_ := FALSE;
                    MC_ReadDigitalOutputActive_ := FALSE;
                    MC_ReadDigitalOutputValue_ := 0;
                    MC_ReadDigitalOutputError_ := FALSE;
                    MC_ReadDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSIF NOT Enable AND MC_ReadDigitalOutputEnable_PV THEN
                    MC_ReadDigitalOutputDone_ := FALSE;
                    MC_ReadDigitalOutputActive_ := FALSE;
                    MC_ReadDigitalOutputValue_ := 0;
                    MC_ReadDigitalOutputError_ := FALSE;
                    MC_ReadDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    _AxisReference^.Data.ActiveAcyclicCommunication := FALSE;
                    _AxisReference^.Data.DoneAcyclicCommunication := FALSE;
                END_IF;
            END_IF;
            MC_ReadDigitalOutputEnable_PV := Enable;
            
            Valid			:= 	MC_ReadDigitalOutputDone_;				           
            Busy			:= 	MC_ReadDigitalOutputActive_;				  
            Error			:= 	MC_ReadDigitalOutputError_;				          
            ErrorID			:= 	MC_ReadDigitalOutputErrorID_;				    
            IF Valid THEN
                IF OutputNumber >=0 AND OutputNumber <=15 THEN
                    Value			:= 	System.BitAccess.GetBit(TO_WORD(MC_ReadDigitalOutputValue_),TO_USINT(OutputNumber));
                END_IF;
            ELSE
                Value			:= 	FALSE;
            END_IF;					          
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        VAR INTERNAL
            MC_WriteDigitalOutputExecute_PV			: 	BOOL := FALSE;		//Execute - previous value                         
            MC_WriteDigitalOutputDone_PV			:	BOOL := FALSE;		//Done - previous value                           
            MC_WriteDigitalOutputCallNumber			: 	INT; 				//Call number of the method MC_WriteDigitalOutput  
            MC_WriteDigitalOutputFirstCall			: 	BOOL;				//First call of the method MC_WriteDigitalOutput 
            MC_WriteDigitalOutputDone_				:	BOOL;				
            MC_WriteDigitalOutputActive_			:	BOOL := FALSE;		
            MC_WriteDigitalOutputError_				:	BOOL;				
            MC_WriteDigitalOutputErrorID_			:	eAxoCmmtAsErrorCode;			
            MC_WriteDigitalOutputState_				:	UINT;		
            MC_WriteDigitalOutputValueRead_ 		:	DINT;		
            MC_WriteDigitalOutputValueToWrite_		:	DINT;		
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

            IF Execute THEN
                IF MC_WriteDigitalOutputState_ = UINT#0 THEN
                    AxoReadParameter_ParameterNumber := DINT#33072;
                    THIS.AxoReadParameter(Enable := TRUE, ParameterNumber := DINT#33072, Valid => Valid_, Error => Error_, ErrorID => ErrorID_,Value =>MC_WriteDigitalOutputValueRead_ );
                    IF Error_ THEN
                        Error := TRUE;
                        ErrorID := ErrorID_;
                    END_IF;
                    IF Valid_ THEN
                        IF OutputNumber >= 0 AND OutputNumber <= 15 THEN
                            MC_WriteDigitalOutputValueToWrite_ := MC_WriteDigitalOutputValueRead_;
                            MC_WriteDigitalOutputValueToWrite_	:= TO_DINT(System.BitAccess.SetBit(TO_DWORD(MC_WriteDigitalOutputValueToWrite_),TO_USINT(OutputNumber),Value));
                            MC_WriteDigitalOutputState_ := MC_WriteDigitalOutputState_ + UINT#10;	
                        ELSE
                            MC_WriteDigitalOutputError_ := TRUE;
                            MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#INPUT_RANGE_ERROR;
                        END_IF;
                    END_IF;
                END_IF;
                IF MC_WriteDigitalOutputState_ = UINT#10 THEN
                    THIS.AxoReadParameter(Enable := FALSE, ParameterNumber := DINT#33072, Valid => Valid_, Error => Error_, ErrorID => ErrorID_,Value =>MC_WriteDigitalOutputValueRead_ );
                    IF NOT Valid_ THEN
                        MC_WriteDigitalOutputState_ := MC_WriteDigitalOutputState_ + UINT#10;	
                        RETURN;
                    END_IF;
                END_IF;
                IF MC_WriteDigitalOutputState_ >= UINT#20 THEN
                    MC_WriteDigitalOutputFirstCall := TRUE;
                    IF _AxisReference^.Data.CheckAccessOK THEN
                        IF Execute AND NOT MC_WriteDigitalOutputExecute_PV THEN(*	raising edge of Execute *)
                            IF NOT _AxisReference^.Data.ActiveAcyclicCommunication THEN
                                _AxisReference^.Data.CallNumberAcyclic := _AxisReference^.Data.CallNumberAcyclic + INT#2;
                                MC_WriteDigitalOutputCallNumber := _AxisReference^.Data.CallNumberAcyclic;
                                _AxisReference^.Data.WriteParameter := TRUE;
                                _AxisReference^.Data.SelectDataType := UINT#1;
                                _AxisReference^.Data.ParameterNumber := DINT#33072; (*P-0-0304, Digital outputs, output image device*)
                                _AxisReference^.Data.WriteValueDint := MC_WriteDigitalOutputValueToWrite_;
                                MC_WriteDigitalOutputError_ := FALSE;
                                MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                            ELSE
                                MC_WriteDigitalOutputError_ := TRUE;
                                MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#ACCESS_ERROR;
                            END_IF;
                        END_IF;
                    ELSE
                        MC_WriteDigitalOutputCallNumber := MC_WriteDigitalOutputCallNumber - INT#1;
                        MC_WriteDigitalOutputError_ := TRUE;
                        MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                    END_IF;
                END_IF;
            ELSE
                MC_WriteDigitalOutputState_     :=  UINT#0;
                MC_WriteDigitalOutputDone_      :=  FALSE;		
                MC_WriteDigitalOutputActive_    :=  FALSE;	
                MC_WriteDigitalOutputError_     :=  FALSE;		
                MC_WriteDigitalOutputErrorID_   :=  WORD#0;
                MC_WriteDigitalOutputExecute_PV :=  FALSE;
            END_IF;
            IF MC_WriteDigitalOutputFirstCall THEN
                IF MC_WriteDigitalOutputState_ >= UINT#20 THEN
                    IF MC_WriteDigitalOutputCallNumber = _AxisReference^.Data.CallNumberAcyclic AND Execute THEN
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := TRUE;
                        // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                        MC_WriteDigitalOutputActive_ := _AxisReference^.Data.ActiveAcyclicCommunication;
                        IF _AxisReference^.Data.DoneAcyclicCommunication THEN
                            MC_WriteDigitalOutputCallNumber := MC_WriteDigitalOutputCallNumber -INT#1;
                            MC_WriteDigitalOutputDone_ := TRUE;
                            MC_WriteDigitalOutputActive_ := FALSE;
                        END_IF;
                        IF _AxisReference^.Data.Error_AcyclicCommunication THEN
                            MC_WriteDigitalOutputCallNumber := MC_WriteDigitalOutputCallNumber -INT#1;
                            MC_WriteDigitalOutputDone_ := FALSE;
                            MC_WriteDigitalOutputActive_ := FALSE;
                            MC_WriteDigitalOutputError_ := _AxisReference^.Data.Error_AcyclicCommunication;
                            MC_WriteDigitalOutputErrorID_ := _AxisReference^.Data.ErrorID_AcyclicCommunication;
                            _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                            _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                            // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                        ELSIF _AxisReference^.Data.CallAxisParameterMethod THEN
                            MC_WriteDigitalOutputCallNumber := MC_WriteDigitalOutputCallNumber -INT#1;
                            MC_WriteDigitalOutputDone_ := FALSE;
                            MC_WriteDigitalOutputActive_ := FALSE;
                            MC_WriteDigitalOutputError_ := TRUE;
                            MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                            _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        END_IF;
                    ELSIF NOT Execute AND NOT MC_WriteDigitalOutputExecute_PV AND MC_WriteDigitalOutputCallNumber = _AxisReference^.Data.CallNumberAcyclic THEN
                        _AxisReference^.Data.CallAxisParameterMethod := TRUE;
                        _AxisReference^.Data.EnableAcyclicCommunication := FALSE;
                        // THIS.AcyclicCommunicationCall(AxisRef :=  _AxisReference , DPV1ParameterNumber := TRUE, Active => Dummy);		
                        MC_WriteDigitalOutputDone_ := FALSE;
                        MC_WriteDigitalOutputActive_ := FALSE;
                        MC_WriteDigitalOutputError_ := FALSE;
                        MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    ELSIF NOT Execute AND MC_WriteDigitalOutputExecute_PV THEN
                        MC_WriteDigitalOutputDone_ := FALSE;
                        MC_WriteDigitalOutputActive_ := FALSE;
                        MC_WriteDigitalOutputError_ := FALSE;
                        MC_WriteDigitalOutputErrorID_ := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                    END_IF;
                END_IF;
            END_IF;
            IF MC_WriteDigitalOutputState_ >= UINT#20 THEN
                MC_WriteDigitalOutputExecute_PV := Execute;
            END_IF;;
            
            Done		:= MC_WriteDigitalOutputDone_;			
            Busy 		:= MC_WriteDigitalOutputActive_;		
            Error 		:= MC_WriteDigitalOutputError_;				
            ErrorID 	:= MC_WriteDigitalOutputErrorID_;
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
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := TRUE;
                    // THIS.FieldBusCommunication(AxisRef := _AxisReference, CommandWriteActive=> Dummy);
                    Position := _AxisReference^.Data.ActualPosition;
                    Valid := TRUE;
                    Busy := FALSE;
                    Error := FALSE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSE
                    Position := 0;
                    Error := TRUE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            ELSE
                Valid := FALSE;
                Busy := FALSE;
                Error := FALSE;
                ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                Position := 0;
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
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := TRUE;
                    // THIS.FieldBusCommunication(AxisRef:= _AxisReference,CommandWriteActive=> Dummy);
                    Velocity := _AxisReference^.Data.ActualVelocity;
                    Valid := TRUE;
                    Busy := FALSE;
                    Error := FALSE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSE
                    Velocity := 0;
                    Error := TRUE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            ELSE
                Valid := FALSE;
                Busy := FALSE;
                Error := FALSE;
                ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                Velocity := 0;
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
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := TRUE;
                    // THIS.FieldBusCommunication(AxisRef:= _AxisReference,CommandWriteActive=> Dummy);
                    Torque := _AxisReference^.Data.ActualTorque;
                    Valid := TRUE;
                    Busy := FALSE;
                    Error := FALSE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSE
                    Torque := 0;
                    Error := TRUE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            ELSE
                Valid := FALSE;
                Busy := FALSE;
                Error := FALSE;
                ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                Torque := 0;
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
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                ErrorStop       :   BOOL;                       //  See state diagram
                Disabled        :   BOOL;                       //  See state diagram
                Stopping        :   BOOL;                       //  See state diagram
                Homing          :   BOOL;                       //  See state diagram
                Standstill      :   BOOL;                       //  See state diagram
                DiscreteMotion  :   BOOL;                       //  See state diagram
                ContinuousMotion:   BOOL;                       //  See state diagram
                SynchronizedMotion: BOOL;                       //  See state diagram
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
                IF _AxisReference^.Data.CheckAccessOK THEN
                    Valid := TRUE;
                    Busy := FALSE;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := TRUE;
                    // THIS.FieldBusCommunication(AxisRef:= _AxisReference,CommandWriteActive=> Dummy);
                    Errorstop := _AxisReference^.Data.StoppedDueError;
                    Stopping := _AxisReference^.Data.DriveStopReq;
                    StandStill := _AxisReference^.Data.Standstill;
                    DiscreteMotion := _AxisReference^.Data.DiscreteMotion;
                    ContinuousMotion:= _AxisReference^.Data.ContinuousMotion;
                    SynchronizedMotion := _AxisReference^.Data.SynchronizedMotion;
                    Homing := _AxisReference^.Data.HomingRunning;
                    // InPosition := _AxisReference^.Data.InPosition;
                    Error := FALSE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
                ELSE
                    Error := TRUE;
                    ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
                END_IF;
            ELSIF MC_ReadStatusEnable_PV THEN
                Errorstop				:= FALSE;
                Stopping				:= FALSE;
                StandStill				:= FALSE;
                DiscreteMotion		:= FALSE;
                ContinuousMotion	:= FALSE;
                SynchronizedMotion	:= FALSE;
                Homing				:= FALSE;
                // InPosition				:= FALSE;
                Valid := FALSE;
                Error := FALSE;
                ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            END_IF;
            MC_ReadStatusEnable_PV := Enable;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        ///<summary>
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

        END_METHOD

        ///<summary>
        /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        /// and certain status information.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadAxisInfo
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                HomeAbsSwitch   :   BOOL;                       //  Digital home switch input is active
                LimitSwitchPos  :   BOOL;                       //  Positive hardware end switch is active
                LimitSwitchNeg  :   BOOL;                       //  Negative hardware end switch is active
                Simulation      :   BOOL;                       //  Axis is in simulation mode (e.g. motor is simulated)
                CommunicationReady: BOOL;                       //  “Network” is initialized and ready for communication
                ReadyForPowerOn :   BOOL;                       //  Drive is ready to be enabled (power on)
                PowerOn         :   BOOL;                       //  If TRUE shows that the power stage is switched ON
                IsHomed         :   BOOL;                       //  The absolute reference position is known for the axis (axis is homed)
                AxisWarning     :   BOOL;                       //  Warning(s) on the axis is present
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

        END_METHOD

        VAR INTERNAL
            LastMessageCode :   ULINT;
        END_VAR
        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        ///<summary>
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

            // IF Enable THEN
            //     IF _AxisReference^.Data.CheckAccessOK	THEN
            //         _AxisReference^.Data.CallAxis := TRUE;
            //         _AxisReference^.Data.ReadOnlyData := TRUE;
            //         THIS.FieldBusCommunication(AxisRef := _AxisReference, CommandWriteActive=> Dummy);
            //         AxisErrorID := _AxisReference^.FieldBus_In.S_0_0390_Diagnosis AND DWORD#16#000FFFFF;
            //         Valid := TRUE;
            //         Busy := FALSE;
            //         Error := FALSE;
            //         ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            //         IF(AxisErrorID >= DWORD#16#000A0000 AND AxisErrorID <= DWORD#16#000AFFFF) THEN
            //             _category   :=  eAxoMessageCategory#Info;
            //         ELSIF(AxisErrorID >= DWORD#16#000C0000 AND AxisErrorID <= DWORD#16#000CFFFF) THEN
            //             _category   :=  eAxoMessageCategory#Notification;
            //         ELSIF(AxisErrorID >= DWORD#16#000E0000 AND AxisErrorID <= DWORD#16#000EFFFF) THEN
            //             _category   :=  eAxoMessageCategory#Warning;
            //         ELSIF(AxisErrorID >= DWORD#16#000F0000 AND AxisErrorID <= DWORD#16#000FFFFF) THEN
            //             _category   :=  eAxoMessageCategory#Error;
            //         END_IF;
            //     ELSE
            //         AxisErrorID := DWORD#0;
            //         Error := TRUE;
            //         ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#RESOURCE_ERROR;
            //     END_IF;
            // ELSE
            //     Valid := FALSE;
            //     Busy := FALSE;
            //     Error := FALSE;
            //     ErrorID := AXOpen.Components.Festo.Drives.eAxoCmmtAsErrorCode#NONE_ERROR;
            //     AxisErrorID := DWORD#0;
            // END_IF;

            Messenger.ActivateOnCondition(LastMessageCode,Enable AND Valid AND LastMessageCode = TO_ULINT(AxisErrorID), _category);
            IF NOT Messenger.IsActive THEN
                LastMessageCode := TO_ULINT(AxisErrorID);
            END_IF;
        END_METHOD

        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
        VAR INTERNAL
            MC_ResetExecute_PV					: 	BOOL := FALSE;		//Execute - previous value           
            // MC_ResetDone_PV						:	BOOL := FALSE;		//Done - previous value              
            // MC_ResetBusy_PV						:	BOOL := FALSE;		//Busy - previous value              
            // MC_ResetFirstCall					: 	BOOL;				//First call of the method MC_Reset  
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
                State := UINT#300;
            END_IF;

            IF Execute THEN
                IF State = UINT#300 THEN
                    Busy := TRUE;
                    _AxisReference^.Telegram111_Out.STW1.acknowledgeFault := TRUE;
                    State := UINT#301;
                END_IF;
                IF State = UINT#301 THEN
                    Busy := TRUE;
                    IF  NOT _AxisReference^.Telegram111_In.ZSW1.faultPresent THEN
                        State := UINT#302;
                    END_IF;
                    IF  _AxisReference^.Telegram111_In.ZSW1.faultPresent  AND THIS.AxoReset_Task.Duration >=T#2S THEN
                        State := UINT#303;
                    END_IF;
                END_IF;
                IF State = UINT#302 THEN
                    _AxisReference^.Telegram111_Out.STW1.acknowledgeFault := FALSE;
                    Done := TRUE;
                END_IF;
                IF State = UINT#303 THEN
                    _AxisReference^.Telegram111_Out.STW1.acknowledgeFault := FALSE;
                    Error := TRUE;
                    ErrorID := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
                END_IF;
            END_IF;

            IF NOT Execute AND MC_ResetExecute_PV THEN
                State := UINT#0;
            END_IF;

            MC_ResetExecute_PV := Execute;
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore
            State := UINT#0;
            SUPER.Restore();
        END_METHOD
    END_CLASS
END_NAMESPACE
