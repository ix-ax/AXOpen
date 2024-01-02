USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abstractions.Drives
    INTERFACE PUBLIC IAxoDrive
        METHOD AxoStop : AXOpen.Core.IAxoTaskState
            VAR_INPUT
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
        END_METHOD
        METHOD AxoHalt  :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
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
        END_METHOD
        METHOD AxoHome  :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
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
        END_METHOD
        METHOD AxoMoveAbsolute :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Position        :   LREAL;                      //  Commanded ‘Position’ for the motion (in technical unit [u]) (negative or positive)                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded position finally reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD
        METHOD AxoMoveRelative :   AXOpen.Core.IAxoTaskState 
            VAR_INPUT
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
        END_METHOD
        METHOD AxoMoveAdditive :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
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
        END_METHOD
        METHOD AxoMoveVelocity :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Velocity        :   LREAL;                      //  Value of the maximum velocity [u/s]. Can be a signed value.
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   eAxoDriveDirection;         //  Enum type (1-of-3 values: PositiveDirection, NegativeDirection, and CurrentDirection. Note: shortest way not applicable)
            END_VAR
            VAR_OUTPUT
                InVelocity      :   BOOL;                       // Commanded velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD
        METHOD AxoTorqueControl:   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
                PositionLimit   :   LREAL;                      //  Position limit                            
                Velocity        :   LREAL;                      //  Absolute value of the maximum velocity.
                Acceleration    :   LREAL;                      //  Value of the maximum acceleration (acceleration is applicable with same sign of torque and velocity)
                Deceleration    :   LREAL;                      //  Value of the maximum deceleration (deceleration is applicable with opposite signs of torque and velocity)
                Jerk            :   LREAL;                      //  Value of the maximum jerk
                Direction       :   eAxoDriveDirection;         //  Enum type (1 of 2 values: PositiveDirection, NegativeDirection or CurrentDirection). Specifies the direction of the torque. (Note: Torque input can be signed value).            
            END_VAR
            VAR_OUTPUT
                InTorque        :   BOOL;                       //  Setpoint value of torque or force equals the commandedvalue
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Active          :   BOOL;                       //  Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       //  ‘Command’ is aborted by another command
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
        END_METHOD
        METHOD AxoSetPosition   :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                Position        :   LREAL;                       //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
                Relative        :   BOOL;                       //  ‘Relative’ distance if True, ‘Absolute’ position if False (= Default)
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Position’ has new value
                Error           :   BOOL;                       //  Signals that an error has occurred within the FunctionBlock
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
        END_METHOD
        METHOD AxoSetOverride   : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
                VelFactor       :   LREAL;                      //  New override factor for the velocity
                AccFactor       :   LREAL;                      //  New override factor for the acceleration/deceleration
                JerkFactor      :   LREAL;                      //  New override factor for the jer            
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the FumethodnctionBlock
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
        END_METHOD
        METHOD AxoReadParameter : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoReadRealParameter : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoReadBoolParameter : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoWriteParameter :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   LINT;                       //  New value of the specified parameter
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method 
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD
        METHOD AxoWriteRealParameter :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD
        METHOD AxoWriteBoolParameter :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD
        METHOD AxoReadDigitalInput : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoReadDigitalOutput : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoWriteDigitalOutput :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
                Value           :   BOOL;                       //  The value of the selected output signal
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Writing of the output signal value is done
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD
        METHOD AxoReadActualPosition : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Position        :   LREAL;                       //  New absolute position (in axis’ unit [u])
            END_VAR
        END_METHOD
        METHOD AxoReadActualVelocity : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Velocity        :   LREAL;                       //  The value of the actual velocity (in axis’ unit [u/s])
            END_VAR
        END_METHOD
        METHOD AxoReadActualTorque : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Torque          :   LREAL;                       //  The value of the actual torque or force (in technical units)
            END_VAR
        END_METHOD
        METHOD AxoReadStatus : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoReadMotionState : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                Source          :   eAxoSource;                 //  Defines the source of the relevant data: CommandedValue;SetValue, ActualValue.
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
        END_METHOD
        METHOD AxoReadAxisInfo : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
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
        END_METHOD
        METHOD AxoReadAxisError : AXOpen.Core.IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                AxisErrorID     :   DWORD;                      //  The value of the axis error. These values are vendor specific
            END_VAR
        END_METHOD
        METHOD AxoReset :   AXOpen.Core.IAxoTaskState
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Standstill’ or ‘Disabled’ state is reached
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD
    END_INTERFACE    
END_NAMESPACE
