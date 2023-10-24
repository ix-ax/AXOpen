USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Components.Drives;
USING System.Math;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoIndraDrive EXTENDS AXOpen.Components.Drives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive
        VAR PUBLIC
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
            TorqueWindow			:	REAL := REAL#0.2;
            TorqueWindowExponent	:	INT :=1;
        END_VAR

        VAR PRIVATE
            _AxisRefExt :  AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
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
                DriveStatus.Error.Id := UINT#701;
            ELSIF refFieldbus_Out = NULL THEN
                DriveStatus.Error.Id := UINT#702;
            ELSIF refParameter_In = NULL THEN
                DriveStatus.Error.Id := UINT#703;
            ELSIF refParameter_Out = NULL THEN
                DriveStatus.Error.Id := UINT#704;
            ELSE
                AreValidReferences := TRUE;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#701,refFieldbus_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,refFieldbus_Out = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,refParameter_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,refParameter_Out = NULL, eAxoMessageCategory#ProgrammingError);
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
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PROTECTED UpdateInputs : BOOL
            VAR_INPUT
                refParameter_In :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the parameter input data of the axis
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference <> NULL) THEN
                _AxisReference^.Parameter_In.Datalength                     := refParameter_In^[0];
                _AxisReference^.Parameter_In.FL_0    		                := refParameter_In^[1].%X0;
                _AxisReference^.Parameter_In.FL_1	    	                := refParameter_In^[1].%X1;
                _AxisReference^.Parameter_In.FL_2	    	                := refParameter_In^[1].%X2;
                _AxisReference^.Parameter_In.FL_3	    	                := refParameter_In^[1].%X3;
                _AxisReference^.Parameter_In.ToggleBit   	                := refParameter_In^[1].%X4;
                _AxisReference^.Parameter_In.LastBit	                    := refParameter_In^[1].%X5;
                _AxisReference^.Parameter_In.Failure	                    := refParameter_In^[1].%X6;
                _AxisReference^.Parameter_In.Reserve                        := refParameter_In^[1].%X7;
                _AxisReference^.Parameter_In.DataWord_0.%B0                 := refParameter_In^[2];
                _AxisReference^.Parameter_In.DataWord_0.%B1                 := refParameter_In^[3];
                _AxisReference^.Parameter_In.DataWord_1.%B0                 := refParameter_In^[4];
                _AxisReference^.Parameter_In.DataWord_1.%B1                 := refParameter_In^[5];
                _AxisReference^.Parameter_In.DataWord_2.%B0                 := refParameter_In^[6];
                _AxisReference^.Parameter_In.DataWord_2.%B1                 := refParameter_In^[7];
                _AxisReference^.Parameter_In.DataWord_3.%B0                 := refParameter_In^[8];
                _AxisReference^.Parameter_In.DataWord_3.%B1                 := refParameter_In^[9];

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
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B0     := refFieldbus_In^[3];  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B1     := refFieldbus_In^[2];  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B2     := refFieldbus_In^[5];  
                _AxisReference^.FieldBus_In.S_0_0051_ActualPosition.%B3     := refFieldbus_In^[4];  
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B0     := refFieldbus_In^[7]; 
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B1     := refFieldbus_In^[6]; 
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B2     := refFieldbus_In^[9]; 
                _AxisReference^.FieldBus_In.S_0_0040_ActualVelocity.%B3     := refFieldbus_In^[8]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B0          := refFieldbus_In^[11]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B1          := refFieldbus_In^[10]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B2          := refFieldbus_In^[13]; 
                _AxisReference^.FieldBus_In.S_0_0390_Diagnosis.%B3          := refFieldbus_In^[12]; 
                _AxisReference^.FieldBus_In.S_0_0144_SignalStatusWord.%B0   := refFieldbus_In^[15]; 
                _AxisReference^.FieldBus_In.S_0_0144_SignalStatusWord.%B1   := refFieldbus_In^[14]; 
                _AxisReference^.FieldBus_In.S_0_0084_ActualTorque.%B0       := refFieldbus_In^[17]; 
                _AxisReference^.FieldBus_In.S_0_0084_ActualTorque.%B1       := refFieldbus_In^[16]; 


                // _AxisRefExt.Parameter_In                                       := _AxisReference^.Parameter_In;
                // _AxisRefExt.FieldBus_In                                        := _AxisReference^.FieldBus_In;
            END_IF;
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
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
            END_VAR
            _AxisReference ?= AxisRef;
            IF(_AxisReference <> NULL) THEN
                // ;
                // _AxisReference^.Parameter_Out   := _AxisRefExt.Parameter_Out;
                // _AxisReference^.FieldBus_Out    := _AxisRefExt.FieldBus_Out;

                refParameter_Out^[0]         := _AxisReference^.Parameter_Out.Datalength;
                refParameter_Out^[1].%X0     := _AxisReference^.Parameter_Out.FL_0;
                refParameter_Out^[1].%X1     := _AxisReference^.Parameter_Out.FL_1;
                refParameter_Out^[1].%X2     := _AxisReference^.Parameter_Out.FL_2;
                refParameter_Out^[1].%X3     := _AxisReference^.Parameter_Out.FL_3;
                refParameter_Out^[1].%X4     := _AxisReference^.Parameter_Out.ToggleBit;
                refParameter_Out^[1].%X5     := _AxisReference^.Parameter_Out.LastBit;
                refParameter_Out^[1].%X6     := _AxisReference^.Parameter_Out.Initalisation;
                refParameter_Out^[1].%X7     := _AxisReference^.Parameter_Out.Reserve;
                refParameter_Out^[2]         := _AxisReference^.Parameter_Out.Index.%B0;
                refParameter_Out^[3]         := _AxisReference^.Parameter_Out.Index.%B1;
                refParameter_Out^[4]         := _AxisReference^.Parameter_Out.Subindex;
                refParameter_Out^[5]         := _AxisReference^.Parameter_Out.Axis;
                refParameter_Out^[6]         := _AxisReference^.Parameter_Out.DataWord_0.%B0;
                refParameter_Out^[7]         := _AxisReference^.Parameter_Out.DataWord_0.%B1;
                refParameter_Out^[8]         := _AxisReference^.Parameter_Out.DataWord_1.%B0;
                refParameter_Out^[9]         := _AxisReference^.Parameter_Out.DataWord_1.%B1;

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
                refFieldbus_Out^[3]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B0;
                refFieldbus_Out^[2]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B1;
                refFieldbus_Out^[5]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B2;
                refFieldbus_Out^[4]          := _AxisReference^.FieldBus_Out.S_0_0282_CommandPosition.%B3;
                refFieldbus_Out^[7]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B0;
                refFieldbus_Out^[6]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B1;
                refFieldbus_Out^[9]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B2;
                refFieldbus_Out^[8]          := _AxisReference^.FieldBus_Out.S_0_0259_CommandVelocity.%B3;
                refFieldbus_Out^[11]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B0;
                refFieldbus_Out^[10]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B1;
                refFieldbus_Out^[13]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B2;
                refFieldbus_Out^[12]         := _AxisReference^.FieldBus_Out.S_0_0260_CommandAcceleration.%B3;
                refFieldbus_Out^[15]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B0;
                refFieldbus_Out^[14]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B1;
                refFieldbus_Out^[14]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B2;
                refFieldbus_Out^[16]         := _AxisReference^.FieldBus_Out.S_0_0359_CommandDecceleration.%B3;
                refFieldbus_Out^[19]         := _AxisReference^.FieldBus_Out.S_0_0145_SignalControlWord.%B0;
                refFieldbus_Out^[18]         := _AxisReference^.FieldBus_Out.S_0_0145_SignalControlWord.%B1;
                refFieldbus_Out^[21]         := _AxisReference^.FieldBus_Out.S_0_0080_TorqueForceCommand.%B0;
                refFieldbus_Out^[20]         := _AxisReference^.FieldBus_Out.S_0_0080_TorqueForceCommand.%B1;
                refFieldbus_Out^[23]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B0;
                refFieldbus_Out^[22]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B1;
                refFieldbus_Out^[25]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B2;
                refFieldbus_Out^[24]         := _AxisReference^.FieldBus_Out.S_0_0193_CommandJerk.%B3;
    
            END_IF;
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

        VAR INTERNAL
            AcyclicCommEnable_PV				: 	BOOL;				//Acyclic communication enable - previous value
            AcyclicCommParamNum_PV				: 	DINT;				//Acyclic communication parameter number - previous value
            AcyclicCommWriteValue				: 	DWORD;				//Acyclic communication value to be written to drive
            AcyclicCommStateCommand				: 	INT;				//Acyclic communication state command
            AcyclicCommCallNumber_PV			:	INT;				//Acyclic communication method call - previous value
            AcyclicCommDone_ 					:	BOOL; 				//Reading/writing of the individual parameter completed, output variables valid
            AcyclicCommActive_ 					: 	BOOL; 				//Reading/writing of the individual parameter active, output variables invalid 
            AcyclicCommDecimalPlaces_ 			:	UINT;				//Decimal places of the selected parameters                                        
            AcyclicCommDataTypeRead_			:	UINT; 				//Read data type of the selected parameters                                        
            AcyclicCommDataLengthRead_			:	UINT;				//Length of the read parameters                                               
            AcyclicCommReadValueDword_			:	DWORD;				//DWORD Operating value of the individual parameter without weighting           
            AcyclicCommReadValueReal_			:	REAL;				//REAL weighted operating value                                                 
            AcyclicCommError_					:	BOOL := FALSE;		//Error                                 
            AcyclicCommErrorID_					:   eAxoIndraDriveErrorCode;				//Error identification, ErrorCode       
            AcyclicCommErrorIdent_				:   AxoIndraDriveErrorStruct; 		//Error identification                  
        
        END_VAR
                    
        METHOD INTERNAL AcyclicCommunication 
            (******************* IndraDrive configuration  ***********************
            Master communication; Fieldbus settings:
            Parameter chanel 10Bytes / 5 Words I/O
            *)
            VAR_INPUT
                AxisRef					:	REF_TO AxoIndraDriveAxisReference;	//Reference to the axis
                Enable					:	BOOL;			//Enable executing of this method
                CallNumber				:	INT;			//Call number - used for detection of the change of calling this method
                Write					:	BOOL;			//FALSE  = read ; TRUE  = write Value in selected Parameter
                SelectDataType			:	UINT;			//0= Bool, 1 = Any, 2 = REAL
                DPV1ParameterNumber		:	BOOL;			//Parameter numbers according to DPV1
                ParameterNumber			:	DINT;			//Parameter number
                WriteValueReal			:	REAL;			//REAL value of the individual parameter with weighting
                WriteValueDword			:	DWORD;			//DWORD value of the individual parameter without weighting
            END_VAR
            VAR_OUTPUT
                Done 					:	BOOL; 			//Reading/writing of the individual parameter completed, output variables valid
                Active 					: 	BOOL; 			//Reading/writing of the individual parameter active, output variables invalid 
                DecimalPlaces 			:	UINT;			//Decimal places of the selected parameters                                        
                DataTypeRead			:	UINT; 			//Read data type of the selected parameters                                        
                DataLengthRead			:	UINT;			//Length of the read parameters                                               
                ReadValueDword			:	DWORD;			//DWORD Operating value of the individual parameter without weighting           
                ReadValueReal			:	REAL;			//REAL weighted operating value                                                 
                Error					:	BOOL := FALSE;	//Error                                 
                ErrorID					:   eAxoIndraDriveErrorCode;			//Error identification, ErrorCode       
                ErrorIdent				:   AxoIndraDriveErrorStruct; 	//Error identification                  
            END_VAR

            VAR CONSTANT
                SubindexAttribute		:	BYTE := BYTE#16#03;	//Subindex for attribute of selected parameter
                SubindexValue			: 	BYTE := BYTE#16#07;	//Subindex for value of selected parameter
                State_FailureOrReset	: 	INT := 0;		//Communication is reseted or in failure
                State_FetchAttribute	: 	INT := 1;		//Start communication with fetch attribute
                State_WaitAttribute		: 	INT := 2;		//Wait receiving attribute
                State_CommandReadValue	:	INT := 3;		//Write command for read value of parameter
                State_WaitReceivingValue: 	INT := 4;		//Waiting of receiving value
                State_CommandWriteValue	:	INT := 5;		//Command to write a value to parameter
                State_WaitValueWriteDone: 	INT := 6;		//Value is written to drive, set DONE
            END_VAR

            VAR
                Divisor 				: 	REAL;
            END_VAR
            AcyclicCommDone_ := FALSE;
            AcyclicCommActive_ := FALSE;
            (* set order to drive with selecting read or write*)
            
            IF Enable AND NOT AxisRef^.Parameter_In.Failure AND AxisRef^.Parameter_Out.Initalisation THEN
                IF AxisRef^.Parameter_In.ToggleBit =  AxisRef^.Parameter_Out.ToggleBit THEN
                    (*New order, fetch attribute of parameter first*)
                    IF (ParameterNumber <> AcyclicCommParamNum_PV) OR (Enable AND NOT AcyclicCommEnable_PV) OR AcyclicCommStateCommand = State_FailureOrReset THEN
                        AcyclicCommStateCommand := State_FetchAttribute;
                    ELSIF (CallNumber<> AcyclicCommCallNumber_PV) AND Write THEN
                        AcyclicCommStateCommand := State_CommandWriteValue;
                    ELSIF (CallNumber <> AcyclicCommCallNumber_PV) AND NOT Write THEN
                        AcyclicCommStateCommand:= State_CommandReadValue;
                    END_IF;
                END_IF;
            END_IF;
            IF NOT Enable AND AcyclicCommEnable_PV THEN
                // WriteValueDword := DWORD#0;
                // WriteValueReal := 0.0;
                // SelectDataType := UINT#0;
                AcyclicCommError_ := FALSE;
                AcyclicCommErrorID_ := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#NONE_ERROR;
                AcyclicCommErrorIdent_.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#NO_TABLE_USED;
                AcyclicCommErrorIdent_.Additional1 := DWORD#0;
                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                AxisRef^.Parameter_Out.ToggleBit:= AxisRef^.Parameter_In.ToggleBit;
                AcyclicCommStateCommand:= State_FailureOrReset;
            END_IF;
            IF AxisRef^.Parameter_In.ToggleBit = AxisRef^.Parameter_Out.ToggleBit AND (NOT AxisRef^.Parameter_In.Failure AND AxisRef^.Parameter_Out.Initalisation) THEN
                AcyclicCommEnable_PV := Enable;
                AcyclicCommParamNum_PV := ParameterNumber;
                AcyclicCommCallNumber_PV := CallNumber;
            END_IF;
            IF NOT AxisRef^.Parameter_In.Failure AND (AcyclicCommStateCommand > State_FailureOrReset) THEN
                AcyclicCommActive_ := TRUE;
                IF (AxisRef^.Parameter_Out.ToggleBit =  AxisRef^.Parameter_In.ToggleBit)THEN
            (************************ Fetch Attribute ****************************)
                    IF AcyclicCommStateCommand= State_WaitAttribute THEN
                        IF AxisRef^.Parameter_In.Datalength = BYTE#16#04 THEN
                            // AcyclicCommDecimalPlaces_ := SHR ((WORD#16#0F00 AND AxisRef^.Parameter_In.DataWord_0),8);
                            // AcyclicCommDataTypeRead_ :=SHR ((WORD#16#0070 AND AxisRef^.Parameter_In.DataWord_0),4);
                            // AcyclicCommDataLengthRead_:= (WORD#16#0007 AND AxisRef^.Parameter_In.DataWord_0);
                            AcyclicCommDecimalPlaces_ := TO_UINT(WORD#16#0F00 AND AxisRef^.Parameter_In.DataWord_0)/UINT#256;
                            AcyclicCommDataTypeRead_ := TO_UINT(WORD#16#0070 AND AxisRef^.Parameter_In.DataWord_0)/UINT#16;
                            AcyclicCommDataLengthRead_:= TO_UINT(WORD#16#0007 AND AxisRef^.Parameter_In.DataWord_0);
                            AxisRef^.Parameter_Out.Subindex := SubindexValue; (* Set Sub-Index for reading attribute of selected parameter *)
                            IF Write THEN
                                AcyclicCommStateCommand:= State_CommandWriteValue;
                            ELSE
                                AcyclicCommStateCommand:= State_CommandReadValue;
                            END_IF;
                        ELSE
                            AcyclicCommError_ := TRUE;
                            AcyclicCommErrorID_:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR;
                            AcyclicCommErrorIdent_.Table:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#F_RELATED_TABLE;
                            AcyclicCommErrorIdent_.Additional1:= DWORD#16#F508; (*Parameter „DATA_LENGTH“ (Possible: 1, 2 and 4 byte values). 8-byte also provided for Indradrive*)
                            AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                            AcyclicCommActive_ := FALSE;
                            AcyclicCommStateCommand:= State_FailureOrReset;
                        END_IF;
                    ELSIF AcyclicCommStateCommand= State_FetchAttribute
                    THEN
                        AxisRef^.Parameter_Out.Datalength := BYTE#16#4;
                        AxisRef^.Parameter_Out.Initalisation := TRUE;
                        AxisRef^.Parameter_Out.LastBit:= TRUE;
                        AxisRef^.Parameter_Out.ToggleBit:= NOT AxisRef^.Parameter_In.ToggleBit;
                        AxisRef^.Parameter_Out.FL_3:= FALSE; (*Data-lenght - Control-Word-LowByte*)
                        AxisRef^.Parameter_Out.FL_2 := TRUE; (*Data-lenght - Control-Word-LowByte*)
                        AxisRef^.Parameter_Out.FL_1 := FALSE; (*Data-length - Control-Word-LowByte*)
                        AxisRef^.Parameter_Out.FL_0 := FALSE; (*Data-length - Control-Word-LowByte*)
                        IF DPV1ParameterNumber THEN
                            IF  (ParameterNumber > DINT#65535) OR  (ParameterNumber < DINT#1)THEN
                                AcyclicCommError_ := TRUE;
                                AcyclicCommErrorID_:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR;
                                AcyclicCommErrorIdent_.Table:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#F_RELATED_TABLE;
                                AcyclicCommErrorIdent_.Additional1 := DWORD#16#F505; (*Parameter number < 1 or > 4095*)
                                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                                AcyclicCommActive_ := FALSE;
                                AcyclicCommStateCommand:= State_FailureOrReset;
                            ELSE
                                IF ParameterNumber > DINT#32768 THEN (*the requested parameter is P-0-xxxxx*)
                                    AxisRef^.Parameter_Out.Index:= TO_WORD( ParameterNumber - DINT#20480);
                                ELSE (*the requested parameter is S-0-xxxx*)
                                    AxisRef^.Parameter_Out.Index:= TO_WORD( ParameterNumber + DINT#8192);
                                END_IF;     
                            END_IF;
                        ELSE
                            IF  (ParameterNumber > DINT#16383) OR  (ParameterNumber < DINT#8193) THEN
                                AcyclicCommError_ := TRUE;
                                AcyclicCommErrorID_:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR;
                                AcyclicCommErrorIdent_.Table:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#F_RELATED_TABLE;
                                AcyclicCommErrorIdent_.Additional1 := DWORD#16#F505; (*Parameternummer < 1 or > 4095*)
                                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                                AcyclicCommActive_ := FALSE;
                                AcyclicCommStateCommand:= State_FailureOrReset;
                            ELSE
                                AxisRef^.Parameter_Out.Index:= TO_WORD( ParameterNumber);
                            END_IF;
                        END_IF;
                        AxisRef^.Parameter_Out.Subindex:= SubindexAttribute; (* Set Sub-Index for reading attribut of selected parameter *)
                        AxisRef^.Parameter_Out.Axis := BYTE#0;
                        AxisRef^.Parameter_Out.DataWord_0 := WORD#0;
                        AxisRef^.Parameter_Out.DataWord_1 := WORD#0;
                        AcyclicCommStateCommand:= State_WaitAttribute;
                        RETURN;
                    END_IF;
            (****************** Write Value ************************)
                    IF AcyclicCommStateCommand= State_CommandWriteValue THEN
                        (*Build write value and in case of Real-Input shift decimalpoint in order of attribute*)
                        IF SelectDataType = UINT#2 THEN
                            AcyclicCommWriteValue:= TO_DWORD(WriteValueReal * EXP(LN(10) * AcyclicCommDecimalPlaces_)) (*signed decimal*);
                        ELSE
                            AcyclicCommWriteValue:= WriteValueDword;
                        END_IF;
                        IF AcyclicCommDataLengthRead_ = UINT#2 (*4-byte value*)THEN
                            AxisRef^.Parameter_Out.ToggleBit:= NOT AxisRef^.Parameter_In.ToggleBit;
                            AxisRef^.Parameter_Out.FL_3:= TRUE; (*Data-lenght - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.FL_2 := FALSE; (*Data-lenght - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.FL_1 := FALSE; (*Data-length - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.FL_0 := FALSE; (*Data-length - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.Datalength := BYTE#8;
                            AxisRef^.Parameter_Out.DataWord_1:= TO_WORD(AcyclicCommWriteValue);
                            // AxisRef^.Parameter_Out.DataWord_0:= TO_WORD(SHR (AcyclicCommWriteValue,16));
                            AxisRef^.Parameter_Out.DataWord_0:= TO_WORD(TO_DINT(AcyclicCommWriteValue)/DINT#65536);
                            AcyclicCommStateCommand:= State_WaitValueWriteDone;
                            RETURN;
                        ELSIF AcyclicCommDataLengthRead_ = UINT#1 (*2-byte value*) THEN
                            AxisRef^.Parameter_Out.ToggleBit:= NOT AxisRef^.Parameter_In.ToggleBit;
                            AxisRef^.Parameter_Out.FL_3:= FALSE; (*Data-lenght - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.FL_2 := TRUE; (*Data-lenght - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.FL_1 := TRUE; (*Data-length - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.FL_0 := FALSE; (*Data-length - Control-Word-LowByte*)
                            AxisRef^.Parameter_Out.Datalength := BYTE#6;
                            AxisRef^.Parameter_Out.DataWord_0:= TO_WORD(AcyclicCommWriteValue);
                            AcyclicCommStateCommand:= State_WaitValueWriteDone;
                            RETURN;
                        ELSE
                            AcyclicCommError_ := TRUE;
                            AcyclicCommErrorID_:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR;
                            AcyclicCommErrorIdent_.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#F_RELATED_TABLE;
                            AcyclicCommErrorIdent_.Additional1 := DWORD#16#F508; (*Parameter „DATA_LENGTH“ (Possible: 1, 2 and 4 byte values). 8-byte also provided for Indradrive*)
                            AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                            AcyclicCommActive_ := FALSE;
                            AcyclicCommStateCommand:= State_FailureOrReset;
                        END_IF;
                    END_IF;
                    IF AcyclicCommStateCommand= State_WaitValueWriteDone THEN
                        AcyclicCommDone_ := TRUE;
                        AcyclicCommActive_ := FALSE;
                        Done 			:= AcyclicCommDone_;     
                        Active 			:= AcyclicCommActive_;    
                        DecimalPlaces 	:= AcyclicCommDecimalPlaces_;
                        DataTypeRead	:= AcyclicCommDataTypeRead_;
                        DataLengthRead	:= AcyclicCommDataLengthRead_;
                        ReadValueDword	:= AcyclicCommReadValueDword_;
                        ReadValueReal	:= AcyclicCommReadValueReal_;
                        Error			:= AcyclicCommError_;      
                        ErrorID			:= AcyclicCommErrorID_;    
                        ErrorIdent		:= AcyclicCommErrorIdent_;  
                        RETURN;
                    END_IF;
            (*************** Read Value ****************)
                    IF AcyclicCommStateCommand= State_CommandReadValue	THEN
                        AxisRef^.Parameter_Out.Datalength := BYTE#4;
                        AxisRef^.Parameter_Out.Initalisation := TRUE;
                        AxisRef^.Parameter_Out.LastBit:= TRUE;
                        AxisRef^.Parameter_Out.ToggleBit:= NOT AxisRef^.Parameter_In.ToggleBit;
                        AxisRef^.Parameter_Out.FL_3:= FALSE; (*Data-lenght - Control-Word-LowByte*)
                        AxisRef^.Parameter_Out.FL_2 := TRUE; (*Data-lenght - Control-Word-LowByte*)
                        AxisRef^.Parameter_Out.FL_1 := FALSE; (*Data-length - Control-Word-LowByte*)
                        AxisRef^.Parameter_Out.FL_0 := FALSE; (*Data-length - Control-Word-LowByte*)
                        IF DPV1ParameterNumber THEN
                            IF  (ParameterNumber > DINT#65535)OR  (ParameterNumber < DINT#1)THEN
                                AcyclicCommError_ := TRUE;
                                AcyclicCommErrorID_:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR;
                                AcyclicCommErrorIdent_.Table:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#F_RELATED_TABLE;
                                AcyclicCommErrorIdent_.Additional1 := DWORD#16#F505; (*Parameter number < 1 or > 4095*)
                                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                                AcyclicCommActive_ := FALSE;
                                AcyclicCommStateCommand:= State_FailureOrReset;
                            ELSE
                                IF ParameterNumber > DINT#32768 THEN (*the requested parameter is P-0-xxxxx*)
                                    AxisRef^.Parameter_Out.Index:= TO_WORD(ParameterNumber - DINT#20480);
                                ELSE (*the requested parameter is S-0-xxxx*)
                                    AxisRef^.Parameter_Out.Index:= TO_WORD( ParameterNumber + DINT#8192);
                                END_IF;
                            END_IF;
                        ELSE
                            IF  (ParameterNumber > DINT#16383)OR  (ParameterNumber < DINT#8193)THEN
                                AcyclicCommError_ := TRUE;
                                AcyclicCommErrorID_:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR;
                                AcyclicCommErrorIdent_.Table:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#F_RELATED_TABLE;
                                AcyclicCommErrorIdent_.Additional1 := DWORD#16#F505; (*Parameter number < 1 or > 4095*)
                                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                                AcyclicCommActive_ := FALSE;
                                AcyclicCommStateCommand:= State_FailureOrReset;
                            ELSE
                                AxisRef^.Parameter_Out.Index:= TO_WORD( ParameterNumber);
                            END_IF;
                        END_IF;
                        AxisRef^.Parameter_OUT.Subindex:= SubindexValue; (* Set Sub-Index for reading attribute of selected parameter *)
                        AxisRef^.Parameter_OUT.Axis := BYTE#0;
                        // AxisRef^.Parameter_OUT.DataWord_0 ;//:= 0; ???
                        // AxisRef^.Parameter_OUT.DataWord_1 ;//:= 0; ???
                        AcyclicCommStateCommand := State_WaitReceivingValue;
                        RETURN;
                    END_IF;
                    IF AcyclicCommStateCommand= State_WaitReceivingValue THEN
                        IF AxisRef^.Parameter_In.Datalength = BYTE#16#04 THEN
                            AcyclicCommReadValueDword_:= AxisRef^.Parameter_In.DataWord_0;
                            // AcyclicCommReadValueDword_:=	SHL(AcyclicCommReadValueDword_,16);
                            AcyclicCommReadValueDword_:= TO_DWORD(TO_DINT(AcyclicCommReadValueDword_) * DINT#65536);
                            AcyclicCommReadValueDword_:= ReadValueDword OR AxisRef^.Parameter_In.DataWord_1;
                            Divisor := EXP(LN(10)*AcyclicCommDecimalPlaces_);
                            AcyclicCommReadValueReal_ := TO_REAL(AcyclicCommReadValueDword_)/ Divisor;
                        ELSIF BYTE#16#02 = AxisRef^.Parameter_In.Datalength THEN
                            AcyclicCommReadValueDword_ := AxisRef^.Parameter_In.DataWord_0;
                            Divisor := EXP(LN(10)*AcyclicCommDecimalPlaces_);
                            AcyclicCommReadValueReal_ := TO_REAL(AcyclicCommReadValueDword_) / Divisor;
                        END_IF;
                        AxisRef^.Parameter_Out.ToggleBit:= NOT AxisRef^.Parameter_In.ToggleBit; (*Cyclic reading value from drive*)
                        AcyclicCommDone_ := TRUE;
                        AcyclicCommActive_ :=FALSE;
                    END_IF;
                END_IF;
            ELSIF AxisRef^.Parameter_In.Failure AND AxisRef^.Parameter_Out.Initalisation AND (AcyclicCommStateCommand > State_FailureOrReset) THEN
                AcyclicCommActive_ :=FALSE;
                AcyclicCommError_ := TRUE;
                AcyclicCommErrorID_ := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#DEVICE_ERROR;
                AcyclicCommErrorIdent_.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#SERCOS_TABLE;
                AcyclicCommErrorIdent_.Additional1 := AxisRef^.Parameter_In.DataWord_0;
                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
                AxisRef^.Parameter_Out.Initalisation := FALSE;
                AxisRef^.Parameter_Out.ToggleBit := FALSE;
                AcyclicCommReadValueDword_ := DWORD#0;
                AcyclicCommReadValueReal_ := 0;
                AcyclicCommStateCommand := State_FailureOrReset;
            ELSE
                (*Failure reset*)
                AxisRef^.Parameter_Out.Initalisation := NOT AxisRef^.Parameter_In.Failure;
                AcyclicCommError_ := FALSE;
                AcyclicCommErrorID_ := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#NONE_ERROR;
                AcyclicCommErrorIdent_.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#NO_TABLE_USED;
                AcyclicCommErrorIdent_.Additional1 := DWORD#0;
                AcyclicCommErrorIdent_.Additional2 := DWORD#0;
            END_IF;
            
            Done 			:= AcyclicCommDone_;     
            Active 			:= AcyclicCommActive_;    
            DecimalPlaces 	:= AcyclicCommDecimalPlaces_;
            DataTypeRead	:= AcyclicCommDataTypeRead_;
            DataLengthRead	:= AcyclicCommDataLengthRead_;
            ReadValueDword	:= AcyclicCommReadValueDword_;
            ReadValueReal	:= AcyclicCommReadValueReal_;
            Error			:= AcyclicCommError_;      
            ErrorID			:= AcyclicCommErrorID_;    
            ErrorIdent		:= AcyclicCommErrorIdent_;  
        END_METHOD

        METHOD INTERNAL AcyclicCommunicationCall
            VAR_INPUT
                AxisRef				:	REF_TO AxoIndraDriveAxisReference;	    //Reference to the axis
                DPV1ParameterNumber :	BOOL  := FALSE;				//Parameter numbers according to DPV1
            END_VAR
            VAR_OUTPUT
                Active				:	BOOL;						//Communication active
            END_VAR
                THIS.AcyclicCommunication(
                    AxisRef:= AxisRef,
                    Enable:= AxisRef^.Data.EnableAcyclicCommunication,
                    CallNumber := AxisRef^.Data.CallNumberAcyclic,
                    Write:= AxisRef^.Data.WriteParameter,
                    SelectDataType :=AxisRef^.Data.SelectDataType,
                    DPV1ParameterNumber := DPV1ParameterNumber,
                    ParameterNumber:= AxisRef^.Data.ParameterNumber,
                    WriteValueReal:= AxisRef^.Data.WriteValueReal ,
                    WriteValueDword:= AxisRef^.Data.WriteValueDword,
                    Done=>AxisRef^.Data.DoneAcyclicCommunication,
                    Active=> AxisRef^.Data.ActiveAcyclicCommunication,
                    DataLengthRead=> AxisRef^.Data.DataLengthRead,
                    DecimalPlaces=> AxisRef^.Data.DecimalPlaces,
                    DataTypeRead=> AxisRef^.Data.DataTypeRead,
                    ReadValueDword=> AxisRef^.Data.ReadValueDword,
                    ReadValueReal=> AxisRef^.Data.ReadValueReal,
                    Error=> AxisRef^.Data.Error_AcyclicCommunication ,
                    ErrorID=> AxisRef^.Data.ErrorID_AcyclicCommunication,
                    ErrorIdent=> AxisRef^.Data.ErrorIdent_AcyclicCommunication);
                    
                Active := AxisRef^.Data.EnableAcyclicCommunication;
                AxisRef^.Data.CallAxisParameterMethod := FALSE;           
        END_METHOD

        VAR INTERNAL
            CyclicCommPosition					:	DINT;				//Target position for the motion  (negative or positive)
            CyclicCommVelocity					:	DINT;				//Value of the maximum velocity (always positive) (not necessarily reached) [u/s].
            CyclicCommAcceleration				:	DINT;				//Value of the acceleration (always positive) (increasing energy of the motor) [u/s2]
            CyclicCommDeceleration				:	DINT;				//Value of the deceleration (always positive) (decreasing energy of the motor) [u/s2]
            CyclicCommTorque					:	INT;				//Value of the torque
            CyclicCommJerk						:	DINT;				//Value of the jerk
            CyclicCommVelocityWindow			:	DINT; 				//Value OF velocity window (S-0-0157); used FOR MoveVelocity
            CyclicCommTorqueWindow				:	INT;				//Value of the torque window
            CyclicCommStateMachine				:	USINT; 				//State of multiplex data transfer
            CyclicCommSetpointAcknowledge_PV	: 	BOOL;				//SetpointAcknowledge - previous value
            CyclicCommCheckBoundsAndMode		: 	BOOL;				//Check values of requestet command and mode of drive
            CyclicCommWriteCommand_PV			: 	BOOL;				//edge dedection of WriteCmd
            CyclicCommWaitSetpointAcknowledge	:	BOOL;				//SetPointAcceptance is already seted
            CyclicCommWaitSetpointReached		: 	BOOL;				//Awaiting Setpoint reached
            CyclicCommCheckMultiplexDates		: 	USINT;				//Index of multiplexed data
            CyclicCommContinuousMotion			: 	BOOL;				//Continuous motion
            CyclicCommPosVelocityWindow			:	DINT;				//Maximum velocity for generate InVelocity
            CyclicCommNegVelocityWindow			:	DINT;				//Minimum velocity for generate InVelocity
            CyclicCommPosTorqueWindow			:	INT;				//Maximum torque for generate InTorque
            CyclicCommNegTorqueWindow			:	INT;				//Minimum torque for generate InTorque
        (*direct states from Drive *)
            CyclicCommActualPosition			:	DINT :=0;			//Actual position
            CyclicCommActualVelocity			:  	DINT :=0;			//Actual velocity
            CyclicCommDiagnosis					: 	DWORD:=DWORD#0;			//Drive diagnosis
            CyclicCommActualTorque				:	INT :=0;			//Actual torque
        (*direct commands to drive*)
            CyclicCommCommandPosition			: 	DINT :=0;			//Command position of the drive
            CyclicCommCommandVelocity			: 	DINT :=1000;		//Command velocity of the drive
            CyclicCommCommandAcceleration		: 	DINT :=1000;		//Command accelleration of the drive
            CyclicCommCommandDecceleration		: 	DINT :=1000;		//Command decelleration of the drive
            CyclicCommCommandJerk				:	DINT :=1000;		//Command jerk of the drive
            CyclicCommCommandTorque				: 	INT	 :=0;			//Command torque of the drive
            CyclicCommMoveAdditive				: 	BOOL :=FALSE;		//Positioning value additive to actual position
            CyclicCommDriveStop_PV				: 	BOOL;				//Drive Stop - previous value
            CyclicCommDriveHalt_PV				: 	BOOL;				//Drive Halt - previous value
        (*Test selecting operating mode 3*)
            CyclicCommbSelDrvOpMode3_PV			:	BOOL;				//SelDrvMode3 - previous value
        END_VAR

        METHOD INTERNAL FieldBusCommunication
            (******************* Drive configuration  ***********************
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
                                    S-0-0080 Torque/force command value		    (2bytes)
                                    S-0-0193 Positioning jerk                   (4bytes)
                    General settings:
                            S-0-0027, Configuration list signal control word -> Number 0; Content S-0-0393
                            S-0-0329, Assign list signal control word -> Number 0; Content 2
                            Primary operation mode: Drive controlled positioning, encoder 1 (without axis control word)
                            Secondary operation mode: Torque/force control	
            *)
            VAR_INPUT
                AxisRef					            :	REF_TO AxoIndraDriveAxisReference;	//Reference to the axis
            END_VAR                                                 				
            VAR_OUTPUT                                              	
                CommandWriteActive					:	BOOL; 						//Command transfer to drive is active
            END_VAR
            VAR CONSTANT
                State_WaitNewCmdWrite				:	USINT := USINT#0;
                State_SelectBaModeOfDrive			: 	USINT := USINT#1;
                State_TransferMovementDataToDrive	: 	USINT := USINT#2;

                State_WaitSetPointAcceptance		:	USINT := USINT#4;
                State_WaitSetpointReached			:	USINT := USINT#5;

                State_InHomeingSequence				:	USINT := USINT#9;
                State_Select_Homing					: 	USINT := USINT#10;
                State_WaitDriveInHomePosition		: 	USINT := USINT#11;
                State_WaitInHomePosition			:	USINT := USINT#12;
            END_VAR
            //CyclicInitialisations();
            //******************************************************************************************************************
            AxisRef^.Data.PowerError 	:= AxisRef^.Fieldbus_In.DriveErrorZKL1 AND AxisRef^.Fieldbus_Out.DriveOn AND NOT AxisRef^.Fieldbus_In.PhaseAcknowledgeBit0 AND NOT AxisRef^.Fieldbus_In.PhaseAcknowledgeBit0;
            AxisRef^.Data.StoppedDueError	:= AxisRef^.Fieldbus_In.DriveErrorZKL1;
            AxisRef^.Data.DiscreteMotion := NOT AxisRef^.Fieldbus_Out.JogForward AND NOT AxisRef^.Fieldbus_Out.JogBackward AND NOT AxisRef^.Fieldbus_In.SetpointReached AND CyclicCommStateMachine = State_WaitSetPointReached;
            AxisRef^.Data.ContinuousMotion	:= AxisRef^.Fieldbus_Out.JogForward XOR AxisRef^.Fieldbus_Out.JogBackward OR AxisRef^.Data.TorqueControlReq AND Abs(AxisRef^.Data.ActualTorque) >= TorqueWindow;
            AxisRef^.Data.Standstill :=AxisRef^.Fieldbus_In.InStandstill AND NOT AxisRef^.Data.DiscreteMotion AND NOT AxisRef^.Data.ContinuousMotion;
            AxisRef^.Data.InPosition := NOT AxisRef^.Fieldbus_In.StatusSetpointProcess AND NOT AxisRef^.Data.ContinuousMotion AND AxisRef^.Fieldbus_In.SetpointReached;
            AxisRef^.Data.SynchronizedMotion	:= FALSE;
            AxisRef^.Data.HomingRunning := AxisRef^.Fieldbus_Out.DriveToZeroPoint;
            //******************************************************************************************************************
            //ReadInputs();
            //******************************************************************************************************************
                (*Reading inputs from Drive*)
                CyclicCommActualPosition	:=	TO_DINT(AxisRef^.Fieldbus_In.S_0_0051_ActualPosition);   //Check order of the bytes
                CyclicCommActualVelocity	:=	TO_DINT(AxisRef^.Fieldbus_In.S_0_0040_ActualVelocity);
                CyclicCommDiagnosis	:=	AxisRef^.Fieldbus_In.S_0_0390_Diagnosis;
                CyclicCommActualTorque	:=	TO_INT(AxisRef^.Fieldbus_In.S_0_0084_ActualTorque);
                AxisRef^.Data.S_0_0144_SignalStateWord :=	AxisRef^.Fieldbus_In.S_0_0144_SignalStatusWord;
                AxisRef^.Data.WarningActive :=	AxisRef^.Fieldbus_In.WarningZKL2;
                AxisRef^.Data.FailureActive :=	AxisRef^.Fieldbus_In.DriveErrorZKL1;
            //******************************************************************************************************************
            //ReadActualPosition();
            //******************************************************************************************************************
                (* Readout actual position*)
                AxisRef^.Data.ActualPosition :=	TO_LREAL(CyclicCommActualPosition) / EXP(LN(10)*PositionExponent);
                AxisRef^.Data.ActualVelocity :=	TO_LREAL(CyclicCommActualVelocity) / EXP(LN(10)*VelocityExponent);
                AxisRef^.Data.ActualTorque :=	TO_LREAL(CyclicCommActualTorque) / EXP(LN(10)*TorqueExponent);
                //******************************************************************************************************************
            IF NOT AxisRef^.Data.ReadOnlyData THEN
            //	DriveStop(); 
                //******************************************************************************************************************
                        AxisRef^.Data.StopError:=FALSE;
                        IF AxisRef^.Data.DriveStopReq THEN
                            IF NOT AxisRef^.Fieldbus_In.InReference THEN
                                AxisRef^.Fieldbus_Out.DriveHalt := FALSE;
                            END_IF;
                            AxisRef^.Fieldbus_Out.JogForward := TRUE;
                            AxisRef^.Fieldbus_Out.JogBackward := TRUE;
                            AxisRef^.Fieldbus_Out.DriveToZeroPoint := FALSE;
                            CyclicCommDeceleration := TO_DINT (AxisRef^.Data.Deceleration * (EXP(LN(10)*DecelerationExponent)));
                            CyclicCommCommandDecceleration := CyclicCommDeceleration;
                            AxisRef^.Data.MoveVelocityReq := FALSE;
                            AxisRef^.Data.TorqueControlReq := FALSE;
                            CyclicCommCommandTorque := 0;
                            IF 	CyclicCommDeceleration =0 THEN
                                AxisRef^.Fieldbus_Out.DriveHalt := FALSE;
                                AxisRef^.Data.StopError:=TRUE;
                                AxisRef^.Data.Error:=TRUE;
                                AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR (* No valid Deceleration - negativ or zero value for Deceleration  *);
                            END_IF;
                            (*Repair wrong drive reaction
                            AxisRef^.Fieldbus_Out.SetpointAcceptance := AxisRef^.Fieldbus_In.SetpointAcknowledge;*)
                            AxisRef^.Data.CommandWriteActive :=FALSE;
                            CyclicCommWaitSetpointAcknowledge := FALSE;
                            CyclicCommContinuousMotion := FALSE;
                            CyclicCommStateMachine := State_WaitNewCmdWrite;
                        ELSIF NOT AxisRef^.Data.DriveStopReq AND AxisRef^.Fieldbus_Out.JogForward AND AxisRef^.Fieldbus_Out.JogBackward AND AxisRef^.Fieldbus_In.S_0_0144_SignalStatusWord.%X0 THEN
                            AxisRef^.Fieldbus_Out.DriveHalt := TRUE;
                            AxisRef^.Fieldbus_Out.JogForward := FALSE;
                            AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                        END_IF;
                        IF (AxisRef^.Fieldbus_In.S_0_0144_SignalStatusWord.%X0 OR AxisRef^.Fieldbus_Out.JogForward = TRUE AND AxisRef^.Fieldbus_Out.JogBackward = TRUE OR NOT AxisRef^.Fieldbus_Out.DriveHalt) AND AxisRef^.Fieldbus_In.InStandstill THEN
                            AxisRef^.Data.Stopped := TRUE;
                        END_IF;
                        CyclicCommDriveStop_PV := AxisRef^.Data.DriveStopReq;
                //******************************************************************************************************************
            //	DriveHalt(); 
                //******************************************************************************************************************
                        AxisRef^.Data.StopError:=FALSE;
                        IF AxisRef^.Data.DriveHaltReq THEN
            //				IF NOT AxisRef^.Fieldbus_In.InReference THEN
                                AxisRef^.Fieldbus_Out.DriveHalt := FALSE;
            //				END_IF;
                            AxisRef^.Fieldbus_Out.JogForward := FALSE;
                            AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                            AxisRef^.Fieldbus_Out.DriveToZeroPoint := FALSE;
                            AxisRef^.Data.MoveVelocityReq := FALSE;
                            AxisRef^.Data.TorqueControlReq := FALSE;
                            CyclicCommDeceleration := TO_DINT (AxisRef^.Data.Deceleration * (EXP(LN(10)*DecelerationExponent)));
                            CyclicCommCommandDecceleration := CyclicCommDeceleration;
                            CyclicCommCommandTorque := 0;
                            IF 	CyclicCommDeceleration =0 THEN
                                AxisRef^.Fieldbus_Out.DriveHalt := FALSE;
                                AxisRef^.Data.StopError:=TRUE;
                                AxisRef^.Data.Error:=TRUE;
                                AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR (* No valid Deceleration - negativ or zero value for Deceleration  *);
                            END_IF;
                            (*Repair wrong drive reaction
                            AxisRef^.Fieldbus_Out.SetpointAcceptance := AxisRef^.Fieldbus_In.SetpointAcknowledge;*)
                            AxisRef^.Data.CommandWriteActive :=FALSE;
                            CyclicCommWaitSetpointAcknowledge := FALSE;
                            CyclicCommContinuousMotion := FALSE;
                            CyclicCommStateMachine := State_WaitNewCmdWrite;
                        ELSIF CyclicCommDriveHalt_PV AND NOT AxisRef^.Data.DriveHaltReq AND AxisRef^.Fieldbus_In.InStandstill  THEN
                            AxisRef^.Fieldbus_Out.DriveHalt := TRUE;
            //				AxisRef^.Fieldbus_Out.JogForward := FALSE;
            //				AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                        END_IF;
            //			IF (AxisRef^.Fieldbus_In.S_0_0144_SignalStatusWord.%X0 OR AxisRef^.Fieldbus_Out.JogForward = TRUE AND AxisRef^.Fieldbus_Out.JogBackward = TRUE OR NOT AxisRef^.Fieldbus_Out.DriveHalt) AND AxisRef^.Fieldbus_In.InStandstill THEN
            //				AxisRef^.Stopped := TRUE;
            //			END_IF
                        CyclicCommDriveHalt_PV := AxisRef^.Data.DriveHaltReq;
                //******************************************************************************************************************
                //CheckValidationOfFbInputs(); 
                //******************************************************************************************************************
                    IF AxisRef^.Data.WriteCommand THEN(*AND NOT CyclicCommWriteCommand_PV*)
                        AxisRef^.Data.WriteCommand:= FALSE;
                        AxisRef^.Data.Error:=FALSE;
                        AxisRef^.Data.ErrorID:=AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#NONE_ERROR;
                        AxisRef^.Data.SetpointReached := FALSE;
                        CyclicCommWaitSetpointReached := FALSE;
                        CyclicCommStateMachine := State_WaitNewCmdWrite;
                            IF AxisRef^.Data.PowerOK THEN
                                IF NOT AxisRef^.Data.DriveStopReq THEN
                                    AxisRef^.Fieldbus_Out.DriveHalt := TRUE;
                                    AxisRef^.Data.Stopped := FALSE;
                                    IF AxisRef^.Data.HomingReq THEN
                                        CyclicCommStateMachine := State_Select_Homing;
                                        CyclicCommPosition := TO_DINT(AxisRef^.Data.Position * (EXP(LN(10)* PositionExponent)));
                                        CyclicCommVelocity := TO_DINT(AxisRef^.Data.Velocity * AxisRef^.Data.OverrideVelocityFactor * (EXP(LN(10)* VelocityExponent)));
                                        CyclicCommAcceleration := TO_DINT(AxisRef^.Data.Acceleration * AxisRef^.Data.OverrideAccelerationFactor * (EXP(LN(10)*AccelerationExponent)));
                                        CyclicCommDeceleration := TO_DINT(AxisRef^.Data.Deceleration * AxisRef^.Data.OverrideAccelerationFactor * (EXP(LN(10)*DecelerationExponent)));
                                        CyclicCommVelocityWindow :=TO_DINT(VelocityWindow * (EXP(LN(10) * VelocityWindowExponent)));
                                        CyclicCommTorqueWindow := TO_INT (TorqueWindow * (EXP(LN(10) * TorqueWindowExponent)));
                                        CyclicCommJerk := TO_DINT (AxisRef^.Data.Jerk * AxisRef^.Data.OverrideJerkFactor * (EXP(LN(10) * JerkExponent)));
                                        CyclicCommTorque := TO_INT (AxisRef^.Data.Torque * (EXP(LN(10)*TorqueExponent)));
                                    ELSE
                                        CyclicCommPosition := TO_DINT(AxisRef^.Data.Position * (EXP(LN(10)* PositionExponent)));
                                        CyclicCommVelocity := TO_DINT(AxisRef^.Data.Velocity * AxisRef^.Data.OverrideVelocityFactor * (EXP(LN(10)* VelocityExponent)));
                                        CyclicCommAcceleration := TO_DINT(AxisRef^.Data.Acceleration * AxisRef^.Data.OverrideAccelerationFactor * (EXP(LN(10)*AccelerationExponent)));
                                        CyclicCommDeceleration := TO_DINT(AxisRef^.Data.Deceleration * AxisRef^.Data.OverrideAccelerationFactor * (EXP(LN(10)*DecelerationExponent)));
                                        CyclicCommVelocityWindow :=TO_DINT(VelocityWindow * (EXP(LN(10) * VelocityWindowExponent)));
                                        CyclicCommTorqueWindow := TO_INT (TorqueWindow * (EXP(LN(10) * TorqueWindowExponent)));
                                        CyclicCommJerk := TO_DINT (AxisRef^.Data.Jerk * AxisRef^.Data.OverrideJerkFactor * (EXP(LN(10) * JerkExponent)));
                                        CyclicCommTorque := TO_INT (AxisRef^.Data.Torque * (EXP(LN(10)*TorqueExponent)));
                                        AxisRef^.Fieldbus_Out.ErrorDelete := FALSE;
                                        AxisRef^.Fieldbus_Out.DriveToZeroPoint := FALSE;
                                        AxisRef^.Fieldbus_Out.JogForward := FALSE;
                                        AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                                        IF CyclicCommVelocity>0 OR AxisRef^.Data.MoveVelocityReq OR AxisRef^.Data.TorqueControlReq THEN
                                            IF CyclicCommAcceleration >0 THEN
                                                IF CyclicCommDeceleration>0 THEN
                                                    AxisRef^.Data.Error:=FALSE;
                                                    AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#NONE_ERROR;
                                                    AxisRef^.Data.ErrorIdent.Table:=AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#NO_TABLE_USED;
                                                    AxisRef^.Data.ErrorIdent.Additional1:=DWORD#0;
                                                    AxisRef^.Data.ErrorIdent.Additional2:=DWORD#0;
                                                    CyclicCommStateMachine := State_SelectBaModeOfDrive;
                                                ELSE
                                                    AxisRef^.Data.Error:=TRUE;
                                                    AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR (* No valid Deceleration - negativ or zero value for Deceleration  *);
                                                END_IF;
                                            ELSE
                                                AxisRef^.Data.Error:=TRUE;
                                                AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR (* No valid Acceleration - negativ  or zero value for Acceleration  *);
                                            END_IF;
                                        ELSE
                                            AxisRef^.Data.Error:=TRUE;
                                            AxisRef^.Data.ErrorID:=AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#INPUT_RANGE_ERROR (* No valid Velocity - negativ  or zero value for Velocity  *);
                                        END_IF;
                                    END_IF;
                                ELSE
                                    AxisRef^.Data.Error:=TRUE;
                                    AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#STATE_MACHINE_ERROR (* Handling; execute not posible - Stop to drive is active *);
                                END_IF;
                            ELSE
                                AxisRef^.Data.Error:=TRUE;
                                AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#STATE_MACHINE_ERROR (* Handling; execute not posible - drive not under power *);
                            END_IF;
            //			ELSE
            //				AxisRef^.Data.Error:=TRUE;
            //				AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#RESOURCE_ERROR (* No valid drive selectet in AXIS_REF - AxisNo=0 *);
            //			END_IF;
                    END_IF;
                //******************************************************************************************************************
                //SelectBaMode(); 
                //******************************************************************************************************************
                        IF CyclicCommStateMachine = State_SelectBaModeOfDrive THEN
                            IF AxisRef^.Data.TorqueControlReq THEN 
                            AxisRef^.Fieldbus_Out.SetOperatingModeBit0 := TRUE;
                            AxisRef^.Fieldbus_Out.SetOperatingModeBit1:= FALSE;
                        ELSE
                            AxisRef^.Fieldbus_Out.SetOperatingModeBit0 := FALSE;
                            AxisRef^.Fieldbus_Out.SetOperatingModeBit1:= FALSE;
                        END_IF;
                            (*Mode are OK?*)
                            IF AxisRef^.Fieldbus_In.ActualOperatingModeBit0 =AxisRef^.Fieldbus_Out.SetOperatingModeBit0  AND 
                                AxisRef^.Fieldbus_In.ActualOperatingModeBit1 =AxisRef^.Fieldbus_Out.SetOperatingModeBit1 THEN
                                IF AxisRef^.Data.MoveVelocityReq = FALSE THEN (**************** Move Position ***************)
                                    AxisRef^.Fieldbus_Out.JogForward := FALSE;
                                    AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                                END_IF;
                                CyclicCommStateMachine := State_TransferMovementDataToDrive;
                                CyclicCommCheckMultiplexDates := USINT#0;
                                AxisRef^.Data.CommandWriteActive := TRUE;
                            END_IF;
                        END_IF;
                //******************************************************************************************************************
                //WriteDataToDrive(); 
                //******************************************************************************************************************
                        IF AxisRef^.Data.CommandWriteActive AND CyclicCommStateMachine <10 THEN
                            IF CyclicCommStateMachine = State_TransferMovementDataToDrive THEN	(*Init the transfer of movement data *)
                                CyclicCommCommandPosition:= CyclicCommPosition;
                                CyclicCommCommandVelocity:= ABS (CyclicCommVelocity);
                                CyclicCommCommandAcceleration:= ABS (CyclicCommAcceleration);
                                CyclicCommCommandDecceleration:= ABS (CyclicCommDeceleration);
                                CyclicCommCommandJerk:= ABS (CyclicCommJerk);
                                CyclicCommCommandTorque:= CyclicCommTorque;
                                CyclicCommMoveAdditive := NOT  AxisRef^.Data.Additive;
                                AxisRef^.Fieldbus_Out.ImmediateBlockChange:=  TRUE (*Immedate acepting new order*);
                                AxisRef^.Fieldbus_Out.AbsoluteRelative:= AxisRef^.Data.Relative (*AbsoluteRelative, FALSE = Absolut, TRUE = relative*);
                                AxisRef^.Fieldbus_Out.DriveHalt := TRUE; (*Reset dDriveHalt by a new movemend command*)
                                IF AxisRef^.Fieldbus_In.StatusSetpointProcess =FALSE THEN
                                    IF AxisRef^.Data.MoveVelocityReq THEN(*in case of MoveVelocity use Jogging *)
                                        CyclicCommWaitSetpointReached := TRUE;			(*awaiting setpoint reached*)
                                        CyclicCommWaitSetpointAcknowledge := FALSE;
                                        CyclicCommContinuousMotion := TRUE;
                                        CyclicCommPosVelocityWindow := CyclicCommVelocity + CyclicCommVelocityWindow;
                                        CyclicCommNegVelocityWindow := CyclicCommVelocity - CyclicCommVelocityWindow;
                                        IF CyclicCommVelocity < 0 THEN (*Negative velocity requested*)
                                            AxisRef^.Fieldbus_Out.JogForward := FALSE;
                                            AxisRef^.Fieldbus_Out.JogBackward := TRUE;
                                        ELSE (*positive velocity is requested*)
                                            AxisRef^.Fieldbus_Out.JogForward := TRUE;
                                            AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                                        END_IF;
                                    ELSIF AxisRef^.Data.TorqueControlReq THEN(*in case of MoveVelocity use Jogging *)
                                        CyclicCommWaitSetpointReached := TRUE;			(*awaiting setpoint reached*)
                                        CyclicCommWaitSetpointAcknowledge := FALSE;
                                        CyclicCommContinuousMotion := TRUE;
                                        CyclicCommPosTorqueWindow := CyclicCommTorque + CyclicCommTorqueWindow;
                                        CyclicCommNegTorqueWindow := CyclicCommTorque - CyclicCommTorqueWindow;
                                    ELSE (*in case of positioning set SetpointAcceptance*)
                                        AxisRef^.Fieldbus_Out.JogForward := FALSE;
                                        AxisRef^.Fieldbus_Out.JogBackward := FALSE;
                                        CyclicCommContinuousMotion := FALSE;
                                        AxisRef^.Fieldbus_Out.SetpointAcceptance := NOT AxisRef^.Fieldbus_Out.SetpointAcceptance;
                                    END_IF;
                                    CyclicCommStateMachine := State_WaitSetpointAcceptance;
                                END_IF;
                            END_IF;
                        END_IF;
                //******************************************************************************************************************
                //WaitAcceptingCommand();
                //******************************************************************************************************************
                        IF 	( AxisRef^.Fieldbus_In.SetpointAcknowledge = AxisRef^.Fieldbus_Out.SetpointAcceptance) AND CyclicCommStateMachine = State_WaitSetpointAcceptance THEN
                            CyclicCommStateMachine := State_WaitSetPointReached;
                            AxisRef^.Data.CommandWriteActive :=FALSE; (*positioning command accepted*)
                        END_IF;
                //******************************************************************************************************************
                //WaitingSetPointReached();
                //******************************************************************************************************************
                        IF CyclicCommStateMachine =	State_WaitSetPointReached THEN
                            AxisRef^.Data.SetpointReached := FALSE;
                            IF AxisRef^.Data.MoveVelocityReq THEN
                                IF (CyclicCommActualVelocity > CyclicCommNegVelocityWindow) AND (CyclicCommActualVelocity < CyclicCommPosVelocityWindow) THEN
                                    AxisRef^.Data.SetpointReached := TRUE;
                                END_IF;
                            ELSIF AxisRef^.Data.TorqueControlReq THEN
                                IF (CyclicCommActualTorque > CyclicCommNegTorqueWindow) AND (CyclicCommActualTorque < CyclicCommPosTorqueWindow) THEN
                                    AxisRef^.Data.SetpointReached := TRUE;
                                END_IF;
                            ELSE
                                IF AxisRef^.Fieldbus_In.SetpointReached THEN
                                    AxisRef^.Data.SetpointReached := TRUE;
                                END_IF;
                            END_IF;
                        ELSE
                            AxisRef^.Data.SetpointReached := FALSE;
                        END_IF;
                //******************************************************************************************************************
                //DrivePower(); 
                //******************************************************************************************************************
                        (*******************************  Power *********************************+*)
                        IF AxisRef^.Data.PowerOnReq THEN
                            AxisRef^.Fieldbus_Out.DriveOn := TRUE;
                            AxisRef^.Fieldbus_Out.DriveEnable := TRUE;
                            IF NOT AxisRef^.Fieldbus_In.DriveErrorZKL1 AND AxisRef^.Fieldbus_In.ReadyToOperateBit0 AND AxisRef^.Fieldbus_In.ReadyToOperateBit1	THEN
                                AxisRef^.Data.PowerOK		:= TRUE;						(* Status OK*)
                            ELSE
                                AxisRef^.Data.PowerOK		:= FALSE;						(* Status not OK*)
                            END_IF;
                            IF	 AxisRef^.Fieldbus_In.DriveErrorZKL1 = TRUE	OR AxisRef^.Fieldbus_In.OperatingModeError = TRUE THEN
                                AxisRef^.Data.PowerError := TRUE; 						(*	Set the ERROR-Output *)
                                AxisRef^.Data.ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#DEVICE_ERROR;
                                AxisRef^.Data.ErrorIdent.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#INDRV_TABLE;
                                AxisRef^.Data.ErrorIdent.Additional1 := CyclicCommDiagnosis;
                            END_IF;
                        ELSE
                            IF CyclicCommStateMachine > State_WaitSetPointReached AND (NOT AxisRef^.Data.PowerOnReq AND AxisRef^.Data.PowerOK) THEN
                                AxisRef^.Data.Error:=TRUE;
                                AxisRef^.Data.ErrorID:= AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#STATE_MACHINE_ERROR (* Handling; execute not posible - drive not under power *);
                                AxisRef^.Data.ErrorIdent.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#NO_TABLE_USED;
                                AxisRef^.Data.ErrorIdent.Additional1:= DWORD#0;
                            END_IF;
                            AxisRef^.Fieldbus_Out.DriveOn := FALSE;
                            AxisRef^.Fieldbus_Out.DriveEnable := FALSE;
                            AxisRef^.Data.PowerOK	:= FALSE;						(* Status OK*)
                            AxisRef^.Fieldbus_Out.DriveHalt := FALSE;
                            AxisRef^.Fieldbus_Out.JogForward := TRUE;
                            AxisRef^.Fieldbus_Out.JogBackward := TRUE;
                        END_IF;
                //******************************************************************************************************************
                //DriveHomeing();
                //******************************************************************************************************************
                        (********************** Homeing requestet *****************************)
                        IF CyclicCommStateMachine > State_InHomeingSequence THEN
                            IF CyclicCommStateMachine = State_Select_Homing	THEN
                                IF NOT AxisRef^.Fieldbus_In.CommandChangeBit THEN
                                    IF AxisRef^.Data.HomingReq AND NOT AxisRef^.Data.DriveStopReq THEN
                                        IF NOT AxisRef^.Fieldbus_In.DriveErrorZKL1 AND NOT AxisRef^.Fieldbus_In.WarningZKL2 THEN
                                            AxisRef^.Fieldbus_Out.DriveHalt := TRUE; (*Reset dDriveHalt by a new movemend command*)
                                            AxisRef^.Fieldbus_Out.DriveToZeroPoint := TRUE;
                                            AxisRef^.Data.CommandWriteActive := FALSE; (*positioning command accepted*)
                                            CyclicCommStateMachine := State_WaitDriveInHomePosition; (*Go wait homeing*)
                                        END_IF;
                                    ELSE
                                        AxisRef^.Data.Error:=TRUE;
                                        AxisRef^.Data.ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#STATE_MACHINE_ERROR (* Handling; execute not posible - Stop to drive is active *);
                                    END_IF;
                                ELSE
                                    AxisRef^.Fieldbus_Out.ErrorDelete := FALSE;
                                    AxisRef^.Fieldbus_Out.DriveToZeroPoint := FALSE;
                                END_IF;
                            END_IF;
                            (************************************* Homeing *********************************)
                            IF CyclicCommStateMachine = State_WaitDriveInHomePosition AND NOT AxisRef^.Fieldbus_In.InReference THEN
                                CyclicCommStateMachine := State_WaitInHomePosition;
                            END_IF;
                            IF CyclicCommStateMachine = State_WaitInHomePosition AND AxisRef^.Fieldbus_In.InStandstill AND AxisRef^.Fieldbus_In.InReference THEN
                                AxisRef^.Data.SetpointReached := TRUE;
                                AxisRef^.Fieldbus_Out.DriveToZeroPoint := FALSE;
                                AxisRef^.Data.CommandWriteActive := FALSE; (*positioning command accepted*)
                            END_IF;
                        END_IF;
                //******************************************************************************************************************
                //DriveReset(); 
                //******************************************************************************************************************
                        (********************************  Error-Reset ********************************************)
                        IF AxisRef^.Data.ResetReq OR AxisRef^.Fieldbus_Out.ErrorDelete THEN
                            AxisRef^.Fieldbus_Out.ErrorDelete:= TRUE;
                            AxisRef^.Fieldbus_Out.DriveToZeroPoint:= FALSE;
                            IF NOT AxisRef^.Fieldbus_In.DriveErrorZKL1 AND NOT AxisRef^.Fieldbus_In.WarningZKL2 THEN
                                AxisRef^.Data.ResetOK := TRUE;
                                AxisRef^.Data.ResetReq := FALSE;
                                AxisRef^.Data.Error := FALSE;
                                AxisRef^.Data.ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#NONE_ERROR;
                                AxisRef^.Data.ErrorIdent.Additional1 := DWORD#0;
                                AxisRef^.Fieldbus_Out.ErrorDelete:= FALSE;
                                AxisRef^.Data.StoppedDueError := FALSE;
                            ELSE
                                AxisRef^.Data.ResetOK := FALSE;
                            END_IF;
                        ELSE
                            AxisRef^.Data.ResetOK := FALSE;
                            AxisRef^.Fieldbus_Out.ErrorDelete:= FALSE;
                        END_IF;
                //******************************************************************************************************************
                //DriveErrors(); 
                //******************************************************************************************************************
                        IF CyclicCommStateMachine > State_WaitSetPointAcceptance AND NOT AxisRef^.Data.CommandWriteActive THEN
                            IF AxisRef^.Fieldbus_In.DriveErrorZKL1 AND (DWORD#16#00F0000 < AxisRef^.Data.ErrorIdent.Additional1) THEN
                                AxisRef^.Data.Error := TRUE;
                                AxisRef^.Data.StoppedDueError := TRUE;
                                AxisRef^.Data.ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#DEVICE_ERROR;
                                AxisRef^.Data.ErrorIdent.Table := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorTable#INDRV_TABLE;
                                AxisRef^.Data.ErrorIdent.Additional1 := CyclicCommDiagnosis;
                                AxisRef^.Fieldbus_Out.DriveToZeroPoint := FALSE;
                                AxisRef^.Fieldbus_Out.ErrorDelete := FALSE;
                                CyclicCommStateMachine := State_WaitNewCmdWrite;
                            END_IF;
                        END_IF;
                //******************************************************************************************************************
                //WriteOutputs();
                //******************************************************************************************************************
                        (*Write positioning command to drive at output word 1+2*);
                        AxisRef^.Fieldbus_Out.S_0_0282_CommandPosition 	:= TO_DWORD (CyclicCommCommandPosition);
                        (*Write velocitiy command to drive at output word 3+4*);
                        AxisRef^.Fieldbus_Out.S_0_0259_CommandVelocity 	:= TO_DWORD (CyclicCommCommandVelocity);
                        (*Write acceleration command to drive at output word 5+6*);
                        AxisRef^.Fieldbus_Out.S_0_0260_CommandAcceleration 	:= TO_DWORD (CyclicCommCommandAcceleration);
                        (*Write deceleration command to drive at output word 7+8*);
                        AxisRef^.Fieldbus_Out.S_0_0359_CommandDecceleration 	:= TO_DWORD (CyclicCommCommandDecceleration);
                        (*Write torque limit command to drive at output word 10*);
                        AxisRef^.Fieldbus_Out.S_0_0080_TorqueForceCommand 	:= TO_WORD(CyclicCommCommandTorque);
                        (*Write jerk command to drive at output word 11+12*);
                        AxisRef^.Fieldbus_Out.S_0_0193_CommandJerk 	:= TO_DWORD (CyclicCommCommandJerk);
                //******************************************************************************************************************
                CommandWriteActive := AxisRef^.Data.CommandWriteActive;
                CyclicCommSetpointAcknowledge_PV := AxisRef^.Fieldbus_In.SetpointAcknowledge;
            END_IF;
            (*Write list signal control word to drive at output word 9, for user*)
            AxisRef^.Fieldbus_Out.S_0_0145_SignalControlWord := AxisRef^.Data.S_0_0145_SignalControlWord;
            (*Write list signal control word to drive at output word 9, for PLCOpen*);
            AxisRef^.Fieldbus_Out.S_0_0145_SignalControlWord.%X0 := NOT CyclicCommMoveAdditive;
            AxisRef^.Data.CallAxis := FALSE;
            AxisRef^.Data.ReadOnlyData := FALSE;

        END_METHOD

        VAR INTERNAL
            MC_PowerEnable_PV					:	BOOL := FALSE;		//Enable - previous value
        END_VAR
        
        ///<summary>
        /// This method controls the power stage (On or Off).
        ///</summary>
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
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                //TODO some message
                RETURN;
            END_IF;

            Status := FALSE;
            Error	:= FALSE;
            ErrorID :=	WORD#0;
            Valid := FALSE;
            IF Enable OR MC_PowerEnable_PV THEN
                IF _AxisReference^.Data.CheckAccessOK	THEN
                    IF Enable THEN (*	raising edge of ENABLE *)
                        _AxisReference^.Data.PowerOnReq := TRUE;
                    ELSE
                        _AxisReference^.Data.PowerOnReq := FALSE;
                        _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                    END_IF;
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                        THIS.FieldBusCommunication(AxisRef := _AxisReference,
                                                    CommandWriteActive=> Dummy);
                    IF _AxisReference^.Data.PowerOK THEN
                        Status	:= TRUE;						(* Status OK*)
                        Valid := TRUE;
                    END_IF;
                    IF _AxisReference^.Data.PowerError = TRUE THEN
                        Error		:= TRUE; 						(*	Set the ERROR-Output *)
                        Valid := TRUE;
                        ErrorID := _AxisReference^.Data.ErrorID;
                    ELSIF _AxisReference^.Data.CallAxis THEN
                        Error := TRUE;
                        Valid := TRUE;
                        ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#RESOURCE_ERROR;
                    END_IF;
                ELSE
                    Error := TRUE;
                    Valid := TRUE;
                    ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#RESOURCE_ERROR;
                END_IF;
            END_IF;
            MC_PowerEnable_PV := Enable;
        END_METHOD 

        VAR INTERNAL
            MC_HomeExecute_PV					:	BOOL := FALSE;		//Execute - previous value           
            MC_HomeCallNumber					: 	INT; 				//Call number of the method MC_Stop  
            MC_HomeFirstCall					: 	BOOL;				//First call of the method MC_Stop   	
            MC_HomeDone_						:	BOOL; 				
            MC_HomeActive_						:	BOOL;				
            MC_HomeCommandAborted_				:	BOOL;				
            MC_HomeError_						:	BOOL;				
            MC_HomeErrorID_						:	eAxoIndraDriveErrorCode; 		
            MC_HomeState_						:	UINT;				
        END_VAR
        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
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
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                //TODO some message
                RETURN;
            END_IF;

            ;
        END_METHOD

        VAR INTERNAL
            MC_StopExecute_PV					: 	BOOL;				//Execute - previous value
            MC_StopCallNumber					:	INT;				//Call number of the method MC_Stop  
            MC_StopFirstCall					: 	BOOL;				//First call of the method MC_Stop
        END_VAR

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        ///</summary>
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
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                //TODO some message
                RETURN;
            END_IF;

            Done := FALSE;
            IF Execute OR MC_StopExecute_PV THEN 								(* Execute = Stop to Drive *)
                IF Execute THEN
                    MC_StopFirstCall := TRUE;
                    IF _AxisReference^.Data.CheckAccessOK THEN
                        IF Execute AND NOT MC_StopExecute_PV THEN
                            _AxisReference^.Data.CallNumberCyclic := _AxisReference^.Data.CallNumberCyclic + INT#2;
                            MC_StopCallNumber := _AxisReference^.Data.CallNumberCyclic;
                        END_IF;
                        Active := TRUE;
                        _AxisReference^.Data.DriveStopReq := TRUE;
                        _AxisReference^.Data.Deceleration := Deceleration;
                        _AxisReference^.Data.Jerk := Jerk;
                        _AxisReference^.Data.CallAxis := TRUE;
                        _AxisReference^.Data.ReadOnlyData := FALSE;
                        _AxisReference^.Data.HomingReq:= FALSE;
                        THIS.FieldBusCommunication(AxisRef := _AxisReference,
                                                CommandWriteActive=> Dummy);
                        IF 	_AxisReference^.Data.StopError AND MC_StopCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                            Error		:= TRUE; 						(*	Set the ERROR-Output *)
                            ErrorID :=	_AxisReference^.Data.ErrorID;
                        ELSIF _AxisReference^.Data.CallAxis THEN
                            Active := FALSE;
                            Error := TRUE;
                            ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#RESOURCE_ERROR;
                        END_IF;
                    ELSE
                        MC_StopCallNumber := MC_StopCallNumber - INT#1;
                        Error := TRUE;
                        ErrorID := AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode#RESOURCE_ERROR;
                    END_IF;
                END_IF;
                IF _AxisReference^.Data.Stopped THEN
                    Done := TRUE;
                    Active := FALSE;
                END_IF;
                IF NOT Execute AND MC_StopExecute_PV THEN
                    _AxisReference^.Data.DriveStopReq := FALSE;
                END_IF;
            ELSE
                Error	:= FALSE;
                ErrorID :=	WORD#0;
            END_IF;
            IF NOT Execute AND MC_StopFirstCall AND Active THEN
                IF MC_StopCallNumber = _AxisReference^.Data.CallNumberCyclic THEN
                    _AxisReference^.Data.CallAxis := TRUE;
                    _AxisReference^.Data.ReadOnlyData := FALSE;
                        THIS.FieldBusCommunication(AxisRef:= _AxisReference,
                                                CommandWriteActive=> Dummy);
                    IF _AxisReference^.Data.Stopped THEN
                        Done := TRUE;
                        Active := FALSE;
                        MC_StopCallNumber := MC_StopCallNumber -INT#1;
                    END_IF;
                ELSE
                    Done := FALSE;
                    Active := FALSE;
                    CommandAborted := TRUE;
                END_IF;
            ELSE
                CommandAborted := FALSE;
            END_IF;
            MC_StopExecute_PV := Execute;
            Busy := Execute AND NOT Done AND NOT Error;

            ;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        ///</summary>
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
             ;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
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
             ;
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
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
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
             ;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        ///<summary>
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
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
             ;
        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        ///<summary>
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
             ;
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
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
            ;
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
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
            ;
        END_METHOD

        ///<summary>
        /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and jerk of the motion.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_SetOverride
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
                VelFactor       :   LREAL;                      //  New override factor for the velocity
                AccFactor       :   LREAL;                      //  New override factor for the acceleration/deceleration
                JerkFactor      :   LREAL;                      //  New override factor for the jer            
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
            ;
        END_METHOD

        VAR INTERNAL 
            MC_ReadParameterEnable_PV			: 	BOOL := FALSE;		//Enable - previous value
            MC_ReadParameterDone_PV				:	BOOL := FALSE;		//Done - previous value
            MC_ReadParameterCallNumber			: 	INT; 				//Call number of the method MC_ReadParameter
            MC_ReadParameterNumber_PV			: 	DINT;				//ParameterNumber - previous value (stored at rising edge of the Enable) 
            MC_ReadParameterFirstCall			: 	BOOL;				//First call of the method MC_ReadParameter
            MC_ReadParameterDone_				:	BOOL;							
            MC_ReadParameterActive_				:	BOOL := FALSE;					
            MC_ReadParameterError_				:	BOOL;							
            MC_ReadParameterErrorID_			:	eAxoIndraDriveErrorCode;						
            MC_ReadParameterValue_				:	DINT;							
        END_VAR
        
        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   INT;                        //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   REAL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisReference;
                Dummy : BOOL;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                //TODO some message
                RETURN;
            END_IF;

            ;

        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   INT;                        //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_WriteParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   INT;                        //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type BOOL.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_WriteBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   INT;                        //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        /// It provides the value of the referenced input (BOOL).
        ///<summary>
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
            ;
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
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
            ;
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_WriteDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
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
            ;
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
            ;
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
            ;
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
            ;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the state diagram of the axis
        ///<summary>
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
            ;
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
            ;
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
            ;
        END_METHOD

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
                AxisErrorID     :   WORD;                       //  The value of the axis error. These values are vendor specific
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
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
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE