USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Abstractions.AxoDrives
    CLASS PUBLIC ABSTRACT AxoMotionStateTask EXTENDS AXOpen.Core.AxoToggleTask
        VAR PUBLIC
            Messenger   :   AxoMessenger;	
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_IN_OUT
                AxisRef :   AxoAxisRef;
            END_VAR

            VAR_OUTPUT
                Busy            :   BOOL;   //  The FB is not finished and new output values are to be expected
                Valid           :   BOOL;   //  Valid set of outputs is available at the FB.
                Error           :   BOOL;   //  Signals that an error has occurred within the Function Block
                ErrorID         :   WORD;   //  Error identification
            END_VAR

            VAR 
                _Busy           :   BOOL;
                _Valid          :   BOOL;
                _Error          :   BOOL;
                _ErrorID        :   WORD;
            END_VAR

            Messenger.Serve(THIS);
            _Busy := FALSE; 
            _Valid := FALSE;
            _Error := FALSE;
            _ErrorID := WORD#0;

            IF THIS.IsSwitchedOn() THEN
                THIS.StateTaskOn(AxisRef,_Busy,_Valid,_Error,_ErrorID);
            ELSE
                THIS.StateTaskOff(AxisRef,_Busy,_Valid,_Error,_ErrorID);
            END_IF;

            Busy        := _Busy;
            Valid       := _Valid;
            Error       := _Error;
            ErrorID     := _ErrorID;
        END_METHOD

        METHOD PUBLIC ABSTRACT StateTaskOn
            VAR_IN_OUT
                AxisRef     :   AxoAxisRef;
                Busy        :   BOOL;   //  The FB is not finished and new output values are to be expected
                Valid       :   BOOL;   //  Valid set of outputs is available at the FB.
                Error       :   BOOL;   //  Signals that an error has occurred within the Function Block
                ErrorID     :   WORD;   //  Error identification
            END_VAR
        END_METHOD

        METHOD PUBLIC ABSTRACT StateTaskOff
            VAR_IN_OUT
                AxisRef     :   AxoAxisRef;
                Busy        :   BOOL;   //  The FB is not finished and new output values are to be expected
                Valid       :   BOOL;   //  Valid set of outputs is available at the FB.
                Error       :   BOOL;   //  Signals that an error has occurred within the Function Block
                ErrorID     :   WORD;   //  Error identification
            END_VAR
        END_METHOD     
    END_CLASS    
END_NAMESPACE