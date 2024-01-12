NAMESPACE AXOpen.Core
    ///<summary>
    /// AxoDialog class, which represents structure of base dialog.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoDialog EXTENDS AxoDialogBase IMPLEMENTS IAxoDialogFormat, IAxoDialogAnswer

        VAR PUBLIC      
            _text : STRING;
            _caption : STRING;
            _buttons : eDialogButtons;
            _answer : eDialogAnswer;
            _dialogType : eDialogType;
        END_VAR
        
        VAR PRIVATE
            _risingEdge : BOOL;  // not used in .net side          
            _lastCall : ULINT;
            _createPlcCycleSpace :  BOOL;
            _PlcCycleSpaceCounter : UINT;
        END_VAR    

        ///<summary>
        /// Show method, which serves for initializing remote task and invoking dialog from PLC.
        ///</summary>
        METHOD PUBLIC Show : IAxoDialogFormat
            VAR_INPUT
                _parent : IAxoObject;
            END_VAR    

            VAR_TEMP
                callCounter : ULINT;
            END_VAR   

            IF(_parent = NULL) THEN RETURN; END_IF;

            THIS.Initialize(_parent);

            IF NOT THIS.IsInitialized THEN // dialog is not observed/monitored by server
                _answer := eDialogAnswer#NoAnswer; // set default value
                ErrorDetails := 'THE REMOTE TASK IS NOT INITIALIZED';
                RETURN; // if it continue  .Execute() call ThrowWhen() and task go to ErrorState  
            END_IF;

            callCounter := THIS.GetParent().GetContext().OpenCycleCount();
            if callCounter = _lastCall then //is called in the same cycle, suppose that is a new dialog
                _answer := eDialogAnswer#NoAnswer; // must be reseted.
                RETURN; 
            END_IF;

            IF _createPlcCycleSpace THEN // create cycle space AFTER RESPONSE
                _answer := eDialogAnswer#NoAnswer; // must be set due to call for new dialog.
                _PlcCycleSpaceCounter  := _PlcCycleSpaceCounter + UINT#1; 
                IF _PlcCycleSpaceCounter > UINT#2 then // IT IS REDUNDAND
                    _createPlcCycleSpace := FALSE;
                END_IF;
                RETURN; 
            END_IF;
            
            // Restores when not called for 2+ consecutive cycles of the context.
            IF(callCounter > _lastCall + ULINT#1) THEN
                THIS.Restore();
                _answer := eDialogAnswer#NoAnswer; 
            END_IF;  
            _lastCall := callCounter;

            IF (THIS.Status = eAxoTaskState#Ready) THEN
                _closeSignal := FALSE;
            END_IF;
            
            THIS.Invoke();
            SUPER.Execute();

           
            //after task is done and some answer is provided, restore this task
            IF (THIS.Status = eAxoTaskState#Done && _answer <> eDialogAnswer#NoAnswer) THEN
                THIS.Restore();       
                _createPlcCycleSpace := true;
            END_IF;
         END_METHOD


        ///<summary>
        /// Show method with a possibility to close dialog externally by setting a signal.
        /// WARNING: This is experimental implementation of possibility to close dialogs externally. More testing need to be done.
        ///</summary>
        METHOD PUBLIC ShowWithExternalClose : IAxoDialogFormat
            VAR_INPUT
                _parent : IAxoObject;
                inOkAnswerSignal : BOOL := FALSE;
                inYesAnswerSignal : BOOL := FALSE;
                inNoAnswerSignal : BOOL := FALSE;
                inCancelAnswerSignal : BOOL := FALSE;
            END_VAR

            VAR_TEMP
                callCounter : ULINT;
                edgeDetected : BOOL;
            END_VAR

            ShowWithExternalClose := THIS;

            IF(_parent = NULL) THEN RETURN; END_IF;

            THIS.Initialize(_parent);

            IF NOT THIS.IsInitialized THEN // dialog is not observed/monitored by server
                _answer := eDialogAnswer#NoAnswer; // set default value
                ErrorDetails := 'THE REMOTE TASK IS NOT INITIALIZED';
                RETURN; // if it continue  .Execute() call ThrowWhen() and task go to ErrorState  
            END_IF;

            callCounter := THIS.GetParent().GetContext().OpenCycleCount();
            if callCounter = _lastCall then //is called in the same cycle, suppose that is a new dialog
                _answer := eDialogAnswer#NoAnswer; // must be reseted.
                RETURN; 
            END_IF;

            IF _createPlcCycleSpace THEN // create cycle space AFTER RESPONSE
                _answer := eDialogAnswer#NoAnswer; // must be set due to call for new dialog.
                _PlcCycleSpaceCounter  := _PlcCycleSpaceCounter + UINT#1; 
                IF _PlcCycleSpaceCounter > UINT#2 then // IT IS REDUNDAND
                    _createPlcCycleSpace := FALSE;
                END_IF;
                RETURN; 
            END_IF;
            
            // Restores when not called for 2+ consecutive cycles of the context.
            IF(callCounter > _lastCall + ULINT#1) THEN
                THIS.Restore();
                _answer := eDialogAnswer#NoAnswer; 
            END_IF;  
            _lastCall := callCounter;

            IF (THIS.Status = eAxoTaskState#Ready) THEN
                _closeSignal := FALSE;
            END_IF;
            
            THIS.Invoke();
            SUPER.Execute();

            // watch close signals on rising edge
            edgeDetected := ((inOkAnswerSignal XOR inYesAnswerSignal XOR inNoAnswerSignal XOR inCancelAnswerSignal) AND NOT _risingEdge);
            _risingEdge := inOkAnswerSignal XOR inYesAnswerSignal XOR inNoAnswerSignal XOR inCancelAnswerSignal;

            IF edgeDetected THEN
                _closeSignal := TRUE;
                IF inOkAnswerSignal THEN
                    _answer := eDialogAnswer#Ok;
                ELSIF	inYesAnswerSignal THEN
                    _answer := eDialogAnswer#Yes;
                ELSIF	inNoAnswerSignal THEN
                    _answer := eDialogAnswer#No;
                ELSIF	inCancelAnswerSignal THEN 
                    _answer := eDialogAnswer#Cancel;
                END_IF;

            END_IF;

            //after task is done and some answer is provided, restore this task
            IF (THIS.Status = eAxoTaskState#Done && _answer <> eDialogAnswer#NoAnswer) THEN
                THIS.Restore();       
                _createPlcCycleSpace := true;
            END_IF;
            
        END_METHOD

        ///<summary>
        /// Executes once when the task is restored.
        ///</summary>
        METHOD PROTECTED OVERRIDE OnRestore 
            SUPER.OnRestore();
            _buttons := eDialogButtons#NoButtons;
            _text := '';
            _caption := '';
            _dialogType := eDialogType#Undefined;

            _createPlcCycleSpace :=  FALSE;
            _PlcCycleSpaceCounter:=  UINT#0;
        END_METHOD

    METHOD PUBLIC WithCaption : IAxoDialogAnswer
        VAR_INPUT
            inCaption : STRING;
        END_VAR
        
        _caption := inCaption;
        WithCaption := THIS;
    END_METHOD

    METHOD PUBLIC WithOk : IAxoDialogAnswer
        _buttons := eDialogButtons#Ok;
        WithOk := THIS;
    END_METHOD

    METHOD PUBLIC WithText : IAxoDialogAnswer
        VAR_INPUT
            inText : STRING;
        END_VAR

        _text := inText;
        WithText := THIS;
    END_METHOD

    METHOD PUBLIC WithType : IAxoDialogAnswer
        VAR_INPUT
            inDialogType : eDialogType;
        END_VAR

        _dialogType := inDialogType;
        WithType := THIS;
    END_METHOD

    METHOD PUBLIC WithYesNo : IAxoDialogAnswer
        _buttons := eDialogButtons#YesNo;
        WithYesNo := THIS;
    END_METHOD

    METHOD PUBLIC WithYesNoCancel : IAxoDialogAnswer
        _buttons := eDialogButtons#YesNoCancel;
        WithYesNoCancel := THIS;
    END_METHOD


    METHOD PUBLIC Answer : eDialogAnswer
        Answer := _answer;
    END_METHOD
    
END_CLASS    
END_NAMESPACE
