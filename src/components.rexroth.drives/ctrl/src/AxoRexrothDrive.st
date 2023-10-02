USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.AxoDrives;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoIndraDrive EXTENDS AXOpen.Components.Abstractions.AxoDrives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.AxoDrives.IAxoDrive
        VAR PUBLIC
        END_VAR

        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PROTECTED OVERRIDE UpdateInputs : BOOL
            VAR_INPUT
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
            END_VAR
            VAR_IN_OUT
                AxisRef    :   AxoAxisRef;
            END_VAR
            ;
        END_METHOD   

        ///<summary>
        /// Ensures swapping the AxisRef data structure into the hardware output data structure
        ///</summary>
        METHOD PROTECTED OVERRIDE UpdateOutputs : BOOL
            VAR_IN_OUT
                AxisRef    :   AxoAxisRef;
            END_VAR
            VAR_INPUT
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
            ;
        END_METHOD   

        ///<summary>
        /// This method controls the power stage (On or Off).
        ///</summary>
        METHOD PUBLIC OVERRIDE MC_Power 
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;
            END_VAR
            VAR_INPUT
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            END_VAR
            VAR_OUTPUT
                Status          :   BOOL;                       //  Effective state of the power stage
                Valid           :   BOOL;                       //  If true, a valid set of outputs is available at the method
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification            
            END_VAR
            ;
        END_METHOD 

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
        METHOD PUBLIC OVERRIDE MC_Home
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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
             ;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        ///</summary>
        METHOD PUBLIC OVERRIDE MC_Stop 
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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
        /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        ///</summary>
        METHOD PUBLIC OVERRIDE MC_Halt 
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Start the motion at rising edge
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
             ;
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_MoveRelative 
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Start the motion at rising edge
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
             ;
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_TorqueControl
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
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
            ;
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_SetPosition
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Start setting position in axis
                Position        :   REAL;                       //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
                Relative        :   BOOL;                       //  ‘Relative’ distance if True, ‘Absolute’ position if False (= Default)
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Position’ has new value
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadParameter
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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
            ;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadBoolParameter
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   INT;                        //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   INT;                        //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
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
            ;
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadDigitalOutput
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
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
            ;
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_WriteDigitalOutput
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
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
            ;
        END_METHOD

        ///<summary>
        /// This method returns the actual position.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualPosition 
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Position        :   REAL;                       //  New absolute position (in axis’ unit [u])
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual velocity as long as ‘Enable’ is set. ‘Valid’ is true when the 
        /// dataoutput ‘Velocity’ is valid. If ‘Enable’ is Reset, the data loses its validity, and all outputs are reset,
        /// no matter if new data is available.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualVelocity
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Velocity        :   REAL;                       //  The value of the actual velocity (in axis’ unit [u/s])
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual torque or force as long as ‘Enable’ is set. ‘Valid’ is true when the
        /// data-output ‘Torque’ is valid. If ‘Enable’ is Reset, the data loses its validity, and ‘Valid’ is also reset, 
        /// no matter if new data is available.        
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualTorque
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Torque          :   REAL;                       //  The value of the actual torque or force (in technical units)
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the state diagram of the axis
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadStatus
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
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
            ;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadMotionState
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
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
            ;
        END_METHOD

        ///<summary>
        /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        /// and certain status information.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadAxisInfo
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
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
            ;
        END_METHOD

        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadAxisError
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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
            VAR_IN_OUT
                AxisRef         :   AxoAxisRef;                 //  Reference to the axis
            END_VAR
            VAR_INPUT
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