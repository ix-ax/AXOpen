USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoDriveTests.Tests
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoTestDrive EXTENDS AXOpen.Components.Drives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive
        VAR PUBLIC
        END_VAR

        METHOD PROTECTED OVERRIDE UpdateInputs : BOOL
            VAR_INPUT
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            ;
        END_METHOD   

        METHOD PROTECTED OVERRIDE UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   
            END_VAR
            ;
        END_METHOD   

        METHOD PUBLIC OVERRIDE MC_Power 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                      
            END_VAR
            VAR_OUTPUT
                Status          :   BOOL;                      
                Valid           :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
            END_VAR
            ;
        END_METHOD 

        METHOD PUBLIC OVERRIDE MC_Home
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                      
                Position        :   LREAL;                     
                HommingMode     :   INT;                       
                Velocity        :   LREAL;                     
                Acceleration    :   LREAL;                     
                Deceleration    :   LREAL;                     
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                      
                Busy            :   BOOL;                      
                Active          :   BOOL;                      
                CommandAborted  :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_Stop 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                 
                Deceleration    :   LREAL;                
                Jerk            :   LREAL;                
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                 
                Busy            :   BOOL;                 
                Active          :   BOOL;                 
                CommandAborted  :   BOOL;                      
                Error           :   BOOL;                 
                ErrorID         :   WORD;                 
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_Halt 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       
                Deceleration    :   LREAL;                      
                Jerk            :   LREAL;                      
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       
                Busy            :   BOOL;                       
                Active          :   BOOL;                       
                CommandAborted  :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_MoveAbsolute
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       
                ContinuousUpdate:   BOOL;                       
                Position        :   LREAL;                                  
                Velocity        :   LREAL;                      
                Acceleration    :   LREAL;                      
                Deceleration    :   LREAL;                        
                Jerk            :   LREAL;                      
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;       
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       
                Busy            :   BOOL;                       
                Active          :   BOOL;                       
                CommandAborted  :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_MoveRelative 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       
                ContinuousUpdate:   BOOL;                       
                Distance        :   LREAL;                      
                Velocity        :   LREAL;                      
                Acceleration    :   LREAL;                      
                Deceleration    :   LREAL;                           
                Jerk            :   LREAL;                      
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       
                Busy            :   BOOL;                       
                Active          :   BOOL;                       
                CommandAborted  :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_MoveAdditive
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       
                ContinuousUpdate:   BOOL;                       
                Distance        :   LREAL;                      
                Velocity        :   LREAL;                      
                Acceleration    :   LREAL;                      
                Deceleration    :   LREAL;                                
                Jerk            :   LREAL;                      
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       
                Busy            :   BOOL;                       
                Active          :   BOOL;                       
                CommandAborted  :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_MoveVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       
                ContinuousUpdate:   BOOL;                       
                Velocity        :   LREAL;                      
                Acceleration    :   LREAL;                      
                Deceleration    :   LREAL;                                
                Jerk            :   LREAL;                      
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
            END_VAR
            VAR_OUTPUT
                InVelocity      :   BOOL;                      
                Busy            :   BOOL;                      
                Active          :   BOOL;                      
                CommandAborted  :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
             END_VAR
             ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_TorqueControl
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
                PositionLimit   :   LREAL;                      //  Position limit.
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

        METHOD PUBLIC OVERRIDE MC_SetPosition
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                      
                Position        :   LREAL;                      
                Relative        :   BOOL;                      
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_SetOverride
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
                VelocityFactor  :   LREAL;                      
                AccelerationFactor:   LREAL;                      
                JerkFactor      :   LREAL;                      
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
            END_VAR
            ;
        END_METHOD

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
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
                ParameterNumber :   DINT;                        
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
                Value           :   REAL;                       
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
                ParameterNumber :   DINT;                        
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
                Value           :   BOOL;                       
            END_VAR
            ;
        END_METHOD

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
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_WriteRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                      
                ParameterNumber :   DINT;                       
                Value           :   REAL;                      
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                       
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_WriteBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       
                ParameterNumber :   DINT;                        
                Value           :   BOOL;                       
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                   
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadDigitalInput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
                InputNumber     :   INT;                              
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
                Value           :   BOOL;                       
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
                OutputNumber    :   INT;                                       
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
                Value           :   BOOL;                       
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_WriteDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute          :   BOOL;                       
                OutputNumber    :   INT;                                  
                Value           :   BOOL;                       
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;        
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                     
                Busy            :   BOOL;                     
                Error           :   BOOL;                     
                ErrorID         :   WORD;                     
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadActualPosition 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                      
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
                Position        :   LREAL;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadActualVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
                Velocity        :   LREAL;                       
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadActualTorque
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       
                Busy            :   BOOL;                       
                Error           :   BOOL;                       
                ErrorID         :   WORD;                       
                Torque          :   LREAL;                       
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadStatus
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                      
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
                ErrorStop       :   BOOL;                      
                Disabled        :   BOOL;                      
                Stopping        :   BOOL;                      
                Homing          :   BOOL;                      
                Standstill      :   BOOL;                      
                DiscreteMotion  :   BOOL;                      
                ContinuousMotion:   BOOL;                      
                SynchronizedMotion: BOOL;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadMotionState
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                     
                Source          :   AXOpen.Components.Abstractions.Drives.eAxoSource;                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
                ConstantVelocity:   BOOL;                      
                Accelerating    :   BOOL;                      
                Decelerating    :   BOOL;                      
                DirectionPositive:  BOOL;                      
                DirectionNegative:  BOOL;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadAxisInfo
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                      
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
                HomeAbsSwitch   :   BOOL;                      
                LimitSwitchPos  :   BOOL;                      
                LimitSwitchNeg  :   BOOL;                      
                Simulation      :   BOOL;                      
                CommunicationReady: BOOL;                      
                ReadyForPowerOn :   BOOL;                      
                PowerOn         :   BOOL;                      
                IsHomed         :   BOOL;                      
                AxisWarning     :   BOOL;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_ReadAxisError
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                      
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
                AxisErrorID     :   DWORD;                      
            END_VAR
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE MC_Reset
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                      
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                      
                Busy            :   BOOL;                      
                Error           :   BOOL;                      
                ErrorID         :   WORD;                      
            END_VAR
            ;
        END_METHOD
    
    
END_CLASS  
END_NAMESPACE
