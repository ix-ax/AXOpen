NAMESPACE AXOpen.Components.Elements
    /// <summary>
    /// Represents a door lock with sensor functionality.
    /// [!DANGER] THIS COMPONENT IS NOT SAFETY COMPLIANT IMPLEMENTATION OF SAFETY-RELATED FUNCTIONS EXTERNAL TO THIS COMPONENT IS NECESSARY.
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoDoorLockWithSensor 
        EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            LockActionSignal                :   AXOpen.Elements.AxoDo; 
            IsLockOpen                      :   AXOpen.Elements.AxoDi;
            IsSensorOpen                    :   AXOpen.Elements.AxoDi;
            _IsLocked                       : BOOL;   // door does not have direct feedback for lock state
        END_VAR

        /// <summary>
        /// Runs the door lock with sensor logic.
        /// </summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
                inIsLockOpen: BOOL;
                inIsSensorOpen: BOOL;
                inIsLocked: BOOL;
            END_VAR

            VAR_OUTPUT
                outLock : BOOL;
            END_VAR

            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;

            SUPER.Run(inParent);
            THIS.IsLockOpen.Run(parent := THIS, inSignal    :=  inIsLockOpen );
            THIS.IsSensorOpen.Run(parent := THIS, inSignal    :=  inIsSensorOpen );
            THIS.LockActionSignal.Run(parent := THIS, oSignal    =>  outLock );
            _IsLocked := inIsLocked;
        END_METHOD

        
        /// <summary>
        /// Locks the door.
        /// </summary>
        METHOD PUBLIC Lock : BOOL
            THIS.LockActionSignal.Set();
            Lock := IsLockOpen.IsFalse() AND IsSensorOpen.IsFalse() AND _IsLocked;
        END_METHOD

        /// <summary>
        /// Unlocks the door.
        /// </summary>
        METHOD PUBLIC UnLock : BOOL
            THIS.LockActionSignal.Reset();
            UnLock := NOT _IsLocked ;
        END_METHOD

        /// <summary>
        /// Checks if the door is closed.
        /// </summary>
        METHOD PUBLIC IsClosed : BOOL
            IsClosed := IsLockOpen.IsFalse() AND IsSensorOpen.IsFalse();
        END_METHOD

        /// <summary>
        /// Restores the door lock with sensor state.
        /// </summary>
        METHOD PUBLIC OVERRIDE Restore
            THIS.LockActionSignal.Restore();
            THIS.IsLockOpen.Restore();
            THIS.IsSensorOpen.Restore();
        END_METHOD
    
        /// <summary>
        /// Activates manual control for the door lock with sensor.
        /// </summary>
        METHOD PROTECTED OVERRIDE ManualControl
            THIS.LockActionSignal.ActivateManualControl();
            THIS.IsLockOpen.ActivateManualControl();
            THIS.IsSensorOpen.ActivateManualControl();
        END_METHOD
    END_CLASS
    END_NAMESPACE