USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Components.Drives;

NAMESPACE AXOpen.Components.Rexroth.Drives
    CLASS AxoIndraDriveAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC
            FieldBusIn  :   AxoIndraDriveFieldBusIn;
            FieldBusOut :   AxoIndraDriveFieldBusOut;
            ParameterIn :   AxoIndraDriveParameterIn;
            ParameterOut:   AxoIndraDriveParameterOut;
            Data        :   BYTE;
            Config      :   AxoDrive_Config;
            Status      :   AxoDrive_Status;
        END_VAR
    
    END_CLASS

    CLASS AxoIndraDriveFieldBusIn
        (******************* IndraDrive configuration  ***********************
        Master communication; Fieldbus settings:

        Profile type: * free configurable mode*
            Configuration of realtime channel:
                realtime input (configured feedback values):	    (9words)										
                        P-0-4078 Fieldbus status WORD               (2bytes)
                        S-0-0051 Position feedback 1 value          (4bytes)
                        S-0-0040 Veloccity feedback value           (4bytes)
                        S-0-0390 Diagnostig message number          (4bytes)
                        S-0-0144 Signal status  word			    (2bytes)
                        S-0-0084 Actual torque/force value          (2bytes)
                realtime output (configured command values):		(13words)									
                        P-0-4077 Fieldbus control WORD              (2bytes)
                        S-0-0282 Positioning command value          (4bytes)
                        S-0-0259 Positioning velocity value         (4bytes)
                        S-0-0260 Positioning Accelelration          (4bytes)
                        S-0-0359 Positioning Deceleration           (4bytes)
                        S-0-0145 Signal control word                (2bytes)		
                        S-0-0092 Bipolar torque/force limit value   (2bytes)
                        S-0-0193 Positioning jerk                   (4bytes)
        General settings:
                S-0-0027, Configuration list signal control word -> Number 0; Content S-0-0393
                S-0-0329, Assign list signal control word -> Number 0; Content 2
        *)
        VAR PUBLIC
            //	P_0_4078_StatusWord: WORD; (*Statusword from Drive*)
            PhaseAcknowledgeBit0		: BOOL;		//'(Phase 2,3,4) Operating mode-acknowledge_bit0'
            PhaseAcknowledgeBit1 		: BOOL;		//'(Phase 2,3,4)Operating mode-acknowledge_bit1'
            InReference 				: BOOL;		//'In-reference'
            InStandstill 				: BOOL;		//'In-standstill'
            Done_ 						: BOOL;		//'Setpoint reached'
            CommandChangeBit 			: BOOL;		//'1: command change bit'
            OperatingModeError 		    : BOOL;		//'1: operating mode-error'
            StatusSetpointProcess 		: BOOL;		//'1: status setpoint processing'
            ActualOperatingModeBit0 	: BOOL;		//'actual_operating mode_bit0'
            ActualOperatingModeBit1 	: BOOL;		//'actual_operating mode_bit1'
            SetpointAcknowledge 		: BOOL;		//'Setpoint_acknowledge'
            MessageZKL3 				: BOOL;		//'Message_ZKL3'
            WarningZKL2 				: BOOL;		//'Warning_ZKL2'
            DriveErrorZKL1 			    : BOOL;		//'Drive_Error_ZKL1'
            ReadyToOperateBit0 		    : BOOL;		//'Ready to operate_bit0'
            ReadyToOperateBit1 		    : BOOL;		//'Ready to operate_bit1'
            S_0_0051_ActualPosition     : DWORD;
            S_0_0040_ActualVelocity     : DWORD;
            S_0_0390_Diagnosis          : DWORD;
            S_0_0144_SignalStatusWord   : WORD;
            S_0_0084_ActualTorque       : WORD;
        END_VAR    
    END_CLASS

    CLASS AxoIndraDriveFieldBusOut
        (******************* IndraDrive configuration  ***********************
        Master communication; Fieldbus settings:

        Profile type: * free configurable mode*
            Configuration of realtime channel:
                realtime input (configured feedback values):	    (9words)										
                        P-0-4078 Fieldbus status WORD               (2bytes)
                        S-0-0051 Position feedback 1 value          (4bytes)
                        S-0-0040 Veloccity feedback value           (4bytes)
                        S-0-0390 Diagnostig message number          (4bytes)
                        S-0-0144 Signal status  word			    (2bytes)
                        S-0-0084 Actual torque/force value          (2bytes)
                realtime output (configured command values):		(13words)									
                        P-0-4077 Fieldbus control WORD              (2bytes)
                        S-0-0282 Positioning command value          (4bytes)
                        S-0-0259 Positioning velocity value         (4bytes)
                        S-0-0260 Positioning Accelelration          (4bytes)
                        S-0-0359 Positioning Deceleration           (4bytes)
                        S-0-0145 Signal control word                (2bytes)		
                        S-0-0092 Bipolar torque/force limit value   (2bytes)
                        S-0-0193 Positioning jerk                   (4bytes)
        General settings:
                S-0-0027, Configuration list signal control word -> Number 0; Content S-0-0393
                S-0-0329, Assign list signal control word -> Number 0; Content 2
        *)
        VAR PUBLIC
            //	P_0_4077_CommandWord: WORD;
            SetpointAcceptance 				:	BOOL;			//'setpoint acceptance'
            OperatingModeSet 				:	BOOL;			//'operating mode set'
            DriveToZeroPoint 				:	BOOL;			//'drive to zero point'
            AbsoluteRelative 				:	BOOL;			//'position absolut = 0 or relativ = 1'
            ImmediateBlockChange 			:	BOOL;			//'1 = immediate'
            ErrorDelete 					:	BOOL;			//'clear error'
            JogForward 						:	BOOL;			//'jog forward'
            JogBackward 					:	BOOL;			//'jog backward'
            SetOperatingModeBit0 			:	BOOL;			//'setpoint operating mode_bit0'
            SetOperatingModeBit1 			:	BOOL;			//'setpoint operating mode_bit1'
            Iposync 						:	BOOL;			//'only in cycl. pos. control'
            DriveHalt 						:	BOOL;			//'drive halt'
            DriveEnable 					:	BOOL;			//'drive enable'
            DriveOn 						:	BOOL;			//'drive on'
            S_0_0282_CommandPosition		: 	DWORD;
            S_0_0259_CommandVelocity		: 	DWORD;
            S_0_0260_CommandAcceleration	: 	DWORD;
            S_0_0359_CommandDecceleration	: 	DWORD;
            S_0_0145_SignalControlWord		: 	WORD;
            S_0_0092_BipolarTorqueLimit     :   WORD;
            S_0_0193_CommandJerk            :   DWORD;
        END_VAR    
    END_CLASS

    CLASS AxoIndraDriveParameterIn
        (******************* IndraDrive configuration  ***********************
        Master communication; Fieldbus settings:
        Parameter chanel 10Bytes / 5 Words I/O
        *)
        VAR PUBLIC
            Datalength      :   BYTE;   (*Statusword low byte, acyclic communication from Drive, length of  transfer data*)
            //	StatusWord_highByte: AcyclicComm_IndraDrive_IN_01V00_StatusWord_highByte; (*Statusword high byte, acyclic communication from Drive*)
            FL_0    		:   BOOL;	//'Length userdata'
            FL_1	    	:   BOOL;	//'Length userdata'
            FL_2	    	:   BOOL;	//'Length userdata'
            FL_3	    	:   BOOL;	//'Length userdata'
            ToggleBit   	:   BOOL;	//'Toggle bit'
            LastBit	        :   BOOL;	//'Last bit'
            Failure	        :   BOOL;	//'Failure while communication'
            Reserve	        :   BOOL;	//'Reserve'
            DataWord_0      :   WORD;   (*Data word 0*)
            DataWord_1      :   WORD;   (*Data word 1*)
            DataWord_2      :   WORD;   (*Data word 2*)
            DataWord_3      :   WORD;   (*Data word 3*)        
        END_VAR    
    END_CLASS
    
    CLASS AxoIndraDriveParameterOut
        (******************* IndraDrive configuration  ***********************
        Master communication; Fieldbus settings:
        Parameter chanel 10Bytes / 5 Words I/O
        *)
        VAR PUBLIC
            Datalength      :   BYTE := BYTE#04;    (*Statusword low byte, acyclic communication from Drive, length of  transfer data*)
            //	StatusWord_highByte: BYTE := 16#64; (*Statusword high byte, acyclic communication from Drive*)
            FL_0            :   BOOL;				//'Length userdata'
            FL_1            :   BOOL;				//'Length userdata'
            FL_2            :   BOOL;				//'Length userdata'
            FL_3            :   BOOL;				//'Length userdata'
            ToggleBit       :   BOOL;				//'Toggle bit'
            LastBit         :   BOOL;				//'Last bit'
            Initalisation   :   BOOL := TRUE;		//'Failure while communication'
            Reserve         :   BOOL;				//'Reserve'
            Index           :   WORD;               (*Index*)
            Subindex        :   BYTE;               (*Subindex*)
            Axis            :   BYTE;               (*Axis*)
            DataWord_0      :   WORD;               (*Data word 0, or Index*)
            DataWord_1      :   WORD;               (*Data word 1, or Subindex and AxisNo*)
        END_VAR    
    END_CLASS    
END_NAMESPACE