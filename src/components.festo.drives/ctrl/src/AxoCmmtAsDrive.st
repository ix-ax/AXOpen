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
    CLASS PUBLIC AxoCmmtAsDrive EXTENDS AXOpen.Components.Drives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive
        
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
            _AxisRefExt :  AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
        END_VAR

    
        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoObject; 
                refParameter_In :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refParameter_Out:   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter output data of the axis
                refFieldbus_Out :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF NOT THIS.AreValidReferences(refParameter_In := refParameter_In, refFieldbus_In := refFieldbus_In,refParameter_Out := refParameter_Out, refFieldbus_Out := refFieldbus_Out) THEN
                RETURN;
            END_IF;
            
            THIS.Open();
            THIS.UpdateInputs(refParameter_In := refParameter_In, refFieldbus_In := refFieldbus_In,AxisRef :=_AxisRefExt);
            SUPER.Execute(_AxisRefExt,Enable,EnablePositive,EnableNegative);
            THIS.UpdateStatus(_AxisRefExt);
            THIS.UpdateOutputs(AxisRef := _AxisRefExt, refParameter_Out := refParameter_Out, refFieldbus_Out := refFieldbus_Out);
            THIS.Close(); 
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoContext; 
                refParameter_In :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refParameter_Out:   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter output data of the axis
                refFieldbus_Out :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR
           
            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;
 
            THIS.Initialize(parent);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF NOT THIS.AreValidReferences(refParameter_In := refParameter_In, refFieldbus_In := refFieldbus_In,refParameter_Out := refParameter_Out, refFieldbus_Out := refFieldbus_Out) THEN
                RETURN;
            END_IF;
            
            THIS.Open();
            THIS.UpdateInputs(refParameter_In := refParameter_In, refFieldbus_In := refFieldbus_In,AxisRef :=_AxisRefExt);
            SUPER.Execute(_AxisRefExt,Enable,EnablePositive,EnableNegative);
            THIS.UpdateStatus(_AxisRefExt);
            THIS.UpdateOutputs(AxisRef := _AxisRefExt, refParameter_Out := refParameter_Out, refFieldbus_Out := refFieldbus_Out);
            THIS.Close();            
        END_METHOD   

        METHOD PROTECTED AreValidReferences: BOOL
            VAR_INPUT
                refParameter_In      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refFieldbus_In       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refParameter_Out     :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter output data of the axis
                refFieldbus_Out      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
            AreValidReferences := FALSE;
            IF refFieldbus_In = NULL THEN
                DriveStatus.Error.Id := UINT#703;
            ELSIF refFieldbus_Out = NULL THEN
                DriveStatus.Error.Id := UINT#704;
            ELSIF refParameter_In = NULL THEN
                DriveStatus.Error.Id := UINT#705;
            ELSIF refParameter_Out = NULL THEN
                DriveStatus.Error.Id := UINT#706;
            ELSE
                AreValidReferences := TRUE;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#703,refFieldbus_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,refFieldbus_Out = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,refParameter_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,refParameter_Out = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD

        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PROTECTED OVERRIDE UpdateInputs : BOOL
            VAR_INPUT
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            ;
        END_METHOD   

        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PROTECTED UpdateInputs : BOOL
            VAR_INPUT
                refParameter_In :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference <> NULL) THEN
                _AxisReference^.Parameter_In.Datalength                     := refParameter_In^[1];
                _AxisReference^.Parameter_In.FL_0    		                := refParameter_In^[0].%X0;
                _AxisReference^.Parameter_In.FL_1	    	                := refParameter_In^[0].%X1;
                _AxisReference^.Parameter_In.FL_2	    	                := refParameter_In^[0].%X2;
                _AxisReference^.Parameter_In.FL_3	    	                := refParameter_In^[0].%X3;
                _AxisReference^.Parameter_In.ToggleBit   	                := refParameter_In^[0].%X4;
                _AxisReference^.Parameter_In.LastBit	                    := refParameter_In^[0].%X5;
                _AxisReference^.Parameter_In.Failure	                    := refParameter_In^[0].%X6;
                _AxisReference^.Parameter_In.Reserve                        := refParameter_In^[0].%X7;
                _AxisReference^.Parameter_In.DataWord_0.%B0                 := refParameter_In^[3];
                _AxisReference^.Parameter_In.DataWord_0.%B1                 := refParameter_In^[2];
                _AxisReference^.Parameter_In.DataWord_1.%B0                 := refParameter_In^[5];
                _AxisReference^.Parameter_In.DataWord_1.%B1                 := refParameter_In^[4];
                _AxisReference^.Parameter_In.DataWord_2.%B0                 := refParameter_In^[7];
                _AxisReference^.Parameter_In.DataWord_2.%B1                 := refParameter_In^[6];
                _AxisReference^.Parameter_In.DataWord_3.%B0                 := refParameter_In^[9];
                _AxisReference^.Parameter_In.DataWord_3.%B1                 := refParameter_In^[8];

                _AxisReference^.FieldBus_In.PhaseAcknowledgeBit0            := refFieldbus_In^[1].%X0;  
                _AxisReference^.FieldBus_In.PhaseAcknowledgeBit1 	        := refFieldbus_In^[1].%X1;  
                _AxisReference^.FieldBus_In.InReference 				    := refFieldbus_In^[1].%X2;  
                _AxisReference^.FieldBus_In.InStandstill 			        := refFieldbus_In^[1].%X3;  
                _AxisReference^.FieldBus_In.SetpointReached 				:= refFieldbus_In^[1].%X4;  
                _AxisReference^.FieldBus_In.CommandChangeBit 		        := refFieldbus_In^[1].%X5;  
                _AxisReference^.FieldBus_In.OperatingModeError 		        := refFieldbus_In^[1].%X6;  
                _AxisReference^.FieldBus_In.StatusSetpointProcess 	        := refFieldbus_In^[1].%X7;  
                _AxisReference^.FieldBus_In.ActualOperatingModeBit0 	    := refFieldbus_In^[0].%X0;  
                _AxisReference^.FieldBus_In.ActualOperatingModeBit1 	    := refFieldbus_In^[0].%X1;  
                _AxisReference^.FieldBus_In.SetpointAcknowledge 		    := refFieldbus_In^[0].%X2;  
                _AxisReference^.FieldBus_In.MessageZKL3 				    := refFieldbus_In^[0].%X3;  
                _AxisReference^.FieldBus_In.WarningZKL2 				    := refFieldbus_In^[0].%X4;  
                _AxisReference^.FieldBus_In.DriveErrorZKL1 			        := refFieldbus_In^[0].%X5;  
                _AxisReference^.FieldBus_In.ReadyToOperateBit0 		        := refFieldbus_In^[0].%X6;  
                _AxisReference^.FieldBus_In.ReadyToOperateBit1 		        := refFieldbus_In^[0].%X7;  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B3     := refFieldbus_In^[2];  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B2     := refFieldbus_In^[3];  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B1     := refFieldbus_In^[4];  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B0     := refFieldbus_In^[5];  
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B3     := refFieldbus_In^[6]; 
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B2     := refFieldbus_In^[7]; 
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B1     := refFieldbus_In^[8]; 
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B0     := refFieldbus_In^[9]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B3          := refFieldbus_In^[10]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B2          := refFieldbus_In^[11]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B1          := refFieldbus_In^[12]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B0          := refFieldbus_In^[13]; 
                _AxisReference^.FieldBus_In.S_0_0144_SignalStatusWord.%B1   := refFieldbus_In^[14]; 
                _AxisReference^.FieldBus_In.S_0_0144_SignalStatusWord.%B0   := refFieldbus_In^[15]; 
                _AxisReference^.FieldBus_In.S_0_0084_ActualTorque.%B1       := refFieldbus_In^[16]; 
                _AxisReference^.FieldBus_In.S_0_0084_ActualTorque.%B0       := refFieldbus_In^[17]; 
            ELSE
                DriveStatus.Error.Id := UINT#707;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD   

        ///<summary>
        /// Ensures swapping the AxisRef data structure into the hardware output data structure
        ///</summary>
        METHOD PROTECTED UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                refParameter_Out     :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter output data of the axis
                refFieldbus_Out      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
            END_VAR
            _AxisReference ?= AxisRef;
            IF(_AxisReference <> NULL) THEN
                refParameter_Out^[1]         := _AxisReference^.Parameter_Out.Datalength;
                refParameter_Out^[0].%X0     := _AxisReference^.Parameter_Out.FL_0;
                refParameter_Out^[0].%X1     := _AxisReference^.Parameter_Out.FL_1;
                refParameter_Out^[0].%X2     := _AxisReference^.Parameter_Out.FL_2;
                refParameter_Out^[0].%X3     := _AxisReference^.Parameter_Out.FL_3;
                refParameter_Out^[0].%X4     := _AxisReference^.Parameter_Out.ToggleBit;
                refParameter_Out^[0].%X5     := _AxisReference^.Parameter_Out.LastBit;
                refParameter_Out^[0].%X6     := _AxisReference^.Parameter_Out.Initalisation;
                refParameter_Out^[0].%X7     := _AxisReference^.Parameter_Out.Reserve;
                refParameter_Out^[3]         := _AxisReference^.Parameter_Out.Index.%B0;
                refParameter_Out^[2]         := _AxisReference^.Parameter_Out.Index.%B1;
                refParameter_Out^[5]         := _AxisReference^.Parameter_Out.Subindex;
                refParameter_Out^[4]         := _AxisReference^.Parameter_Out.Axis;
                refParameter_Out^[7]         := _AxisReference^.Parameter_Out.DataWord_0.%B0;
                refParameter_Out^[6]         := _AxisReference^.Parameter_Out.DataWord_0.%B1;
                refParameter_Out^[9]         := _AxisReference^.Parameter_Out.DataWord_1.%B0;
                refParameter_Out^[8]         := _AxisReference^.Parameter_Out.DataWord_1.%B1;

                refFieldbus_Out^[1].%X0      := _AxisReference^.FieldBus_Out.SetpointAcceptance;
                refFieldbus_Out^[1].%X1      := _AxisReference^.FieldBus_Out.OperatingModeSet;
                refFieldbus_Out^[1].%X2      := _AxisReference^.FieldBus_Out.DriveToZeroPoint;
                refFieldbus_Out^[1].%X3      := _AxisReference^.FieldBus_Out.AbsoluteRelative;
                refFieldbus_Out^[1].%X4      := _AxisReference^.FieldBus_Out.ImmediateBlockChange;
                refFieldbus_Out^[1].%X5      := _AxisReference^.FieldBus_Out.ErrorDelete;
                refFieldbus_Out^[1].%X6      := _AxisReference^.FieldBus_Out.JogForward;
                refFieldbus_Out^[1].%X7      := _AxisReference^.FieldBus_Out.JogBackward;
                refFieldbus_Out^[0].%X0      := _AxisReference^.FieldBus_Out.SetOperatingModeBit0;
                refFieldbus_Out^[0].%X1      := _AxisReference^.FieldBus_Out.SetOperatingModeBit1;
                refFieldbus_Out^[0].%X2      :=  FALSE;
                refFieldbus_Out^[0].%X3      :=  FALSE;
                refFieldbus_Out^[0].%X4      := _AxisReference^.FieldBus_Out.Iposync;
                refFieldbus_Out^[0].%X5      := _AxisReference^.FieldBus_Out.DriveHalt;
                refFieldbus_Out^[0].%X6      := _AxisReference^.FieldBus_Out.DriveEnable;
                refFieldbus_Out^[0].%X7      := _AxisReference^.FieldBus_Out.DriveOn;
                refFieldbus_Out^[2]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B3;
                refFieldbus_Out^[3]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B2;
                refFieldbus_Out^[4]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B1;
                refFieldbus_Out^[5]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B0;
                refFieldbus_Out^[6]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B3;
                refFieldbus_Out^[7]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B2;
                refFieldbus_Out^[8]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B1;
                refFieldbus_Out^[9]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B0;
                refFieldbus_Out^[10]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B3;
                refFieldbus_Out^[11]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B2;
                refFieldbus_Out^[12]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B1;
                refFieldbus_Out^[13]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B0;
                refFieldbus_Out^[14]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B3;
                refFieldbus_Out^[15]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B2;
                refFieldbus_Out^[16]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B1;
                refFieldbus_Out^[17]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B0;
                refFieldbus_Out^[18]         := _AxisReference^.FieldBus_Out.S_0_0145_SignalControlWord.%B1;
                refFieldbus_Out^[19]         := _AxisReference^.FieldBus_Out.S_0_0145_SignalControlWord.%B0;
                refFieldbus_Out^[20]         := _AxisReference^.FieldBus_Out.S_0_0080_TorqueForceCommand.%B1;
                refFieldbus_Out^[21]         := _AxisReference^.FieldBus_Out.S_0_0080_TorqueForceCommand.%B0;
                refFieldbus_Out^[22]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B3;
                refFieldbus_Out^[22]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B2;
                refFieldbus_Out^[24]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B1;
                refFieldbus_Out^[25]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B0;
            ELSE
                DriveStatus.Error.Id := UINT#708;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#708,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);
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

        METHOD PRIVATE UpdateStatus 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference <> NULL) THEN

                THIS.ActualPosition := _AxisReference^.Data.ActualPosition;
                THIS.ActualVelocity := _AxisReference^.Data.ActualVelocity;
                THIS.ActualTorque := _AxisReference^.Data.ActualTorque;

                IF NOT _AxisReference^.Data.PowerOK THEN
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
            ELSE
                DriveStatus.Error.Id := UINT#707;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#707,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD  

        ///<summary>
        /// This method controls the power stage (On or Off).
        ///</summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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
        END_METHOD 

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;

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

            
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        ///</summary>
        VAR INTERNAL
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#711,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            Done := FALSE;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        ///</summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#712,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

            
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
                        
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#713,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#714,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
                        
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#715,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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

        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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

                        
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
                _result : AXOpen.Core.IAxoTaskState;
                _ErrorID    :   eAxoCmmtAsDriveErrorCode;
                _Valid  :   BOOL;
                _Error  :   BOOL;
                _Position   :   LREAL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#718,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#719,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        VAR INTERNAL 

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#720,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype REAL.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#721,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#723,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type Real.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#724,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#726,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR

            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#727,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#729,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#730,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#731,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the state diagram of the axis
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#732,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#734,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        ///<summary>
        VAR INTERNAL
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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
                _category  :   AXOpen.Messaging.eAxoMessageCategory;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#735,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;

        END_METHOD

        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
        VAR INTERNAL

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
                _AxisReference :  REF_TO AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            Messenger.ActivateOnCondition(ULINT#736,_AxisReference = NULL, eAxoMessageCategory#ProgrammingError);

            IF(_AxisReference = NULL) THEN
                RETURN;
            END_IF;


            
        END_METHOD
    END_CLASS
END_NAMESPACE