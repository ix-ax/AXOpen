
NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoIndraDriveAxisData
        VAR PUBLIC
            (* Commands *)
            CallAxis					:	BOOL;			//Call axis method for cyclic communication
            ReadOnlyData				:	BOOL;			//Read only data values from drive
            CallNumberCyclic			:	INT :=-1; 		//Number of method call's for cyclic communication
            WriteCommand				:	BOOL;			//Write command to drive
            PowerOnReq					:	BOOL;			//Request to power the drive on
            ResetReq					:	BOOL;			//Request to reset the drive
            HomingReq					:	BOOL;			//Request to start homing
            JogPositiveReq				:	BOOL;			//Request to jog the drive in positive direction
            JogNegativeReq				:	BOOL;			//Request to jog the drive in negative direction
            DriveStopReq				:	BOOL;			//Set Drive Stop with writing deceleration value to drive
            DriveHaltReq				:	BOOL;			//Set Drive Halt with writing deceleration value to drive
            MoveVelocityReq				:	BOOL;			//Command is velocity
            TorqueControlReq				:	BOOL;			//Command is torque
            Relative					:	BOOL; 			//Move relative to (last recommended) positioning command value
            Additive					:	BOOL; 			//Move additive to actual position; works only if relative possitioning active
            Position					:	LREAL;			//Target position for the motion  (negative or positive)
            Velocity					:	LREAL;			//Value of the maximum velocity (always positive) (not necessarily reached) [u/s].
            Acceleration				:	LREAL;			//Value of the acceleration (always positive) (increasing energy of the motor) [u/s2]
            Deceleration				:	LREAL;			//Value of the deceleration (always positive) (decreasing energy of the motor) [u/s2]
            Jerk						:	LREAL;			//Value of the jerk (always positive) [u/s3]
            Torque						:	LREAL;			//Value of the torque (always positive) 
            S_0_0144_SignalStateWord	: 	WORD;			//S-0-0144 SignalStateWord*)
            CallAxisParameterMethod		:	BOOL;			//Call axis method for parameter read/write
            EnableAcyclicCommunication	:	BOOL;			//Enable acyclic communication (for parameter read/write)
            CallNumberAcyclic			:	INT;			//Number of method call's for acyclic communication
            WriteParameter				:	BOOL;			//FALSE = read, TRUE  = write Value of selected Parameter
            SelectDataType				:	UINT;			//0= Bool, 1 = Any, 2 = REAL
            ParameterNumber				:	DINT;			//Parameter number
            WriteValueDint				:	DINT;			//DINT value to be written
            WriteValueReal				:	REAL;			//REAL value to be written
            OverrideVelocityFactor		:	LREAL := 1.0;	//LREAL value to be written
            OverrideAccelerationFactor	:	LREAL := 1.0;	//LREAL value to be written
            OverrideJerkFactor			:	LREAL := 1.0;	//LREAL value to be written
        (* States *)                                    	
            CommandWriteActive			:	BOOL; 			//Command transfer to drive is active
            SetpointReached				: 	BOOL;			//Setpoint reached
            PowerOK						:	BOOL; 			//Power OK
            HomeOK						:	BOOL;			//Drive has reached the homeposition
            ResetOK						:	BOOL; 			//Reset done
            HomingRunning				:	BOOL;			//Homing is active
            Stopped						:	BOOL; 			//Drive in stopped regularly
            Standstill					:	BOOL; 			//Drive in standstill
            InPosition					:	BOOL; 			//Drive in position
            StoppedDueError				:	BOOL; 			//Drive in stop due to error
            MessageActive				:	BOOL;			//Class 3 diagnostics (message) present
            WarningActive				:	BOOL;			//Class 2 diagnostics (warning) present
            FailureActive				:	BOOL;			//Class 1 diagnostics (failure) present
            PowerError					:	BOOL; 			//Power-Failure
            StopError					:	BOOL;			//Stopping-Failure
            ContinuousMotion			:	BOOL; 			//Continius motion
            DiscreteMotion				:	BOOL; 			//Discrete motion
            SynchronizedMotion			:	BOOL;			//Synchronized motion
            Error						:	BOOL;			//Error                          
            ErrorID						:	AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode;		//Error identification, ErrorCode
            ErrorIdent					:	AXOpen.Components.Rexroth.Drives.AxoIndraDriveErrorStruct;	//Error identification           
            ActualPosition				:	LREAL; 			//Shows actual position
            ActualVelocity				:	LREAL; 			//Shows actual velocity
            ActualTorque				:	LREAL; 			//Shows actual torque
            CheckAccessOK				:	BOOL := TRUE;	//Flag for checking valid access at Axis_Data array
            S_0_0145_SignalControlWord	:	WORD;			//S-0-0145 wSignalControlWord, **** exept bit 0 *****)

            DoneAcyclicCommunication 	:	BOOL; 			//Reading/writing of the individual parameter completed, output variables valid
            ActiveAcyclicCommunication	: 	BOOL; 			//Reading/writing of the individual parameter active, output variables invalid 
            DecimalPlaces 				:	UINT;			//Decimal places of the selected parameters                                        
            DataTypeRead				:	UINT; 			//Read data type of the selected parameters                                        
            DataLengthRead				:	UINT;			//Length of the read parameters                                               
            ReadValueDint				:	DINT;			//DINT Operating value of the individual parameter without weighting           
            ReadValueReal				:	REAL;			//REAL weighted operating value                                                 
            Error_AcyclicCommunication	:	BOOL := FALSE;  //Error                          
            ErrorID_AcyclicCommunication:   AXOpen.Components.Rexroth.Drives.eAxoIndraDriveErrorCode;		//Error identification, ErrorCode
            ErrorIdent_AcyclicCommunication:AXOpen.Components.Rexroth.Drives.AxoIndraDriveErrorStruct; 	//Error identification      

        END_VAR

    END_CLASS
    
END_NAMESPACE
