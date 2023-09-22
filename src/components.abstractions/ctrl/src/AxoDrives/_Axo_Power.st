USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Abstractions.AxoDrives
    CLASS PUBLIC _Axo_Power EXTENDS AXOpen.Components.Abstractions.AxoDrives.AxoMotionLevelTask
        VAR PRIVATE 
            _motionTaskId   :   AXOpen.Components.Abstractions.AxoDrives.eAxoMotionTaskId := AXOpen.Components.Abstractions.AxoDrives.eAxoMotionTaskId#Axo_Power;      
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_IN_OUT
                AxisRef :   AxoAxisRef;
            END_VAR
            VAR_INPUT
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            VAR_OUTPUT
                Status          :   BOOL;                       //  Effective state of the power stage
                Busy            :   BOOL;                       //  The FB is not finished and new output values are to be expected
                Valid           :   BOOL;                       //  Valid set of outputs is available at the FB.
                Error           :   BOOL;                       //  Signals that an error has occurred within the Function Block
                ErrorID         :   WORD;                       //  Error identification
            END_VAR

            SUPER.Run(AxisRef,Enable,Busy,Valid,Error,ErrorID);

        END_METHOD

        METHOD PUBLIC OVERRIDE Cyclic
            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE StateTaskOn
            VAR_IN_OUT
                AxisRef : AxoAxisRef;
                Busy : BOOL;
                Valid : BOOL;
                Error : BOOL;
                ErrorID : WORD;
            END_VAR

            ;
        END_METHOD

        METHOD PUBLIC OVERRIDE StateTaskOff
            VAR_IN_OUT
                AxisRef : AxoAxisRef;
                Busy : BOOL;
                Valid : BOOL;
                Error : BOOL;
                ErrorID : WORD;
            END_VAR

            ;
        END_METHOD
    END_CLASS    
END_NAMESPACE