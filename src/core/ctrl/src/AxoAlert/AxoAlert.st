NAMESPACE AXOpen.Core
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoAlert EXTENDS AxoRemoteTask IMPLEMENTS IAxoAlertFormat

        VAR PUBLIC      
            _alertType : eDialogType;
            _title : STRING;
            _message : STRING;
            _timeToBurn : UINT := UINT#5;
        END_VAR
        
        VAR PRIVATE
            _lastCall : ULINT;
            _createPlcCycleSpace :  BOOL;
            _PlcCycleSpaceCounter : UINT;
            _wasShow : BOOL;
        END_VAR    

        METHOD PUBLIC Show : IAxoAlertFormat
            VAR_INPUT
                _parent : IAxoObject;
            END_VAR

            VAR_TEMP
                callCounter : ULINT;
            END_VAR    

            Show := THIS;
            _wasShow := FALSE;

            IF(_parent = NULL) THEN RETURN; END_IF;

            THIS.Initialize(_parent);

            IF NOT THIS.IsInitialized THEN // dialog is not observed/monitored by server
                IF (THIS.Status <> eAxoTaskState#Ready) THEN //needed in case when dialog observation was interrupt
                    THIS.Restore(); 
                END_IF;

                ErrorDetails := 'THE REMOTE TASK IS NOT INITIALIZED';
                RETURN; // if it continue  .Execute() call ThrowWhen() and task go to ErrorState  
            END_IF;
            
            callCounter := THIS.GetParent().GetContext().OpenCycleCount();
            if callCounter = _lastCall then //is called in the same cycle, suppose that is a new dialog
                RETURN; 
            END_IF;

            IF _createPlcCycleSpace THEN // create cycle space AFTER RESPONSE
                _PlcCycleSpaceCounter  := _PlcCycleSpaceCounter + UINT#1; 
                IF _PlcCycleSpaceCounter > UINT#2 then // IT IS REDUNDAND
                    _createPlcCycleSpace := FALSE;
                    _PlcCycleSpaceCounter:=  UINT#0;
                END_IF;
                RETURN; 
            END_IF;

            IF(callCounter > _lastCall + ULINT#1) THEN
                THIS.Restore();
            END_IF;  

            _lastCall := callCounter;


            THIS.Invoke();
            SUPER.Execute();

            //after task is done restore this task and remember that has been shown
            IF (THIS.Status = eAxoTaskState#Done) THEN
                THIS.Restore();
                _wasShow := true;       
                _createPlcCycleSpace := true;
            END_IF;

        END_METHOD
    

        ///<summary>
        /// Restore AlertDialog. In special case context can be null.
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore : IAxoTaskState
            Restore := THIS;

            _alertType := eDialogType#Undefined;
            _title := '';
            _message := '';
            _timeToBurn := UINT#5;
            _PlcCycleSpaceCounter:=  UINT#0;

            IF _context_ = NULL THEN
                Status := eAxoTaskState#Ready;  //needed in case when dialog observation was interrupt
                ErrorDetails := '';
            ELSE
                SUPER.Restore(); 
            END_IF;
        END_METHOD  
        
        
    METHOD PUBLIC WithTitle : IAxoAlertFormat
        VAR_INPUT
            inTitle : STRING;
        END_VAR
        _title := inTitle;
        WithTitle := THIS;
    END_METHOD

    METHOD PUBLIC WithMessage : IAxoAlertFormat
        VAR_INPUT
            inMessage : STRING;
        END_VAR
        _message := inMessage;
        WithMessage := THIS;
    END_METHOD

    METHOD PUBLIC WithTimeToBurn : IAxoAlertFormat
        VAR_INPUT
            inSeconds : UINT;
        END_VAR
        _timeToBurn := inSeconds;
        WithTimeToBurn := THIS;
    END_METHOD

    METHOD PUBLIC WithType : IAxoAlertFormat
        VAR_INPUT
            inAlertType : eDialogType;
        END_VAR
        _alertType := inAlertType;
        WithType := THIS;
    END_METHOD

    METHOD PUBLIC IsShown : BOOL
        IsShown := _wasShow;
        

    END_METHOD


END_CLASS    
END_NAMESPACE