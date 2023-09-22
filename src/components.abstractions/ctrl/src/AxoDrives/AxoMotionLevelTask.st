USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Abstractions.AxoDrives
    CLASS PUBLIC ABSTRACT AxoMotionLevelTask EXTENDS  AXOpen.Components.Abstractions.AxoDrives.AxoMotionStateTask
        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_IN_OUT
                AxisRef :   AxoAxisRef;
            END_VAR
            VAR_INPUT
                Enable  : BOOL;
            END_VAR

            VAR_OUTPUT
                Busy            :   BOOL;   //  The FB is not finished and new output values are to be expected
                Valid           :   BOOL;   //  Valid set of outputs is available at the FB.
                Error           :   BOOL;   //  Signals that an error has occurred within the Function Block
                ErrorID         :   WORD;   //  Error identification
            END_VAR


            SUPER.Run(AxisRef,Busy,Valid,Error,ErrorID);

            IF Enable THEN
                SUPER.SwitchOn();
            ELSE
                SUPER.SwitchOff();
            END_IF;

            THIS.Cyclic();

        END_METHOD
    
        METHOD PUBLIC ABSTRACT Cyclic
        END_METHOD

    END_CLASS    
END_NAMESPACE