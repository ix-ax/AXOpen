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
            _externalCloseReq : BOOL;
            _closeSignal : BOOL;
        END_VAR
        
        VAR PRIVATE
            _lastCall : ULINT;
            _risingEdge : BOOL;  // not used in .net side          
        END_VAR    

        ///<summary>
        /// Show method, which serves for initializing remote task and invoking dialog from PLC.
        ///</summary>
        METHOD PUBLIC Show : IAxoDialogFormat
            VAR_INPUT
                _parent : IAxoObject;
            END_VAR    

            VAR
                callCounter : ULINT;
            END_VAR   

            THIS.Initialize(_parent);
            //before task initialization, set _asnwer to #NoAnswer to avoid inconsitencies
            IF (THIS.Status = eAxoTaskState#Ready) THEN
                _answer := eDialogAnswer#NoAnswer;
            END_IF;
            
           // Restores when not called for 2+ consecutive cycles of the context.
           callCounter := THIS.GetParent().GetContext().OpenCycleCount();
           IF(callCounter > _lastCall + ULINT#1) THEN
               THIS.Restore();
           END_IF;                
           _lastCall := callCounter;

            THIS.Invoke();
            SUPER.Execute();
            _buttons := eDialogButtons#NoButtons;
            _text := '';
            _caption := '';
            _dialogType := eDialogType#Undefined;

            Show := THIS;
            //after task is done and some answer is provided, restore this task
            IF (THIS.Status = eAxoTaskState#Done && _answer <> eDialogAnswer#NoAnswer) THEN
                
                THIS.Restore();   
                    
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
                edgeDetected : BOOL;
            END_VAR

            THIS.Initialize(_parent);
            //before task initialization, set _asnwer to #NoAnswer to avoid inconsitencies
            IF (THIS.Status = eAxoTaskState#Ready) THEN
                _answer := eDialogAnswer#NoAnswer;
                _closeSignal := FALSE;
            END_IF;

            THIS.Invoke();
            SUPER.Execute();

            _buttons := eDialogButtons#NoButtons;

            _externalCloseReq := TRUE;
            _text := '';
            _caption := '';
            _dialogType := eDialogType#Undefined;

            ShowWithExternalClose := THIS;
            // watch close signals on rising edge
            
            //_risingEdge(signal := inOkAnswerSignal XOR inYesAnswerSignal XOR inNoAnswerSignal XOR inCancelAnswerSignal, detected => edgeDetected);

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
                _externalCloseReq := FALSE;
                //_closeSignal := FALSE;
                THIS.Restore();       
            END_IF;
            
        
            
        END_METHOD

    
        ///<summary>
        /// Executes once when the task is restored.
        ///</summary>
        METHOD PROTECTED OVERRIDE OnRestore 
                  
            
            _buttons := eDialogButtons#NoButtons;

            _externalCloseReq := TRUE;
            _text := '';
            _caption := '';
            _dialogType := eDialogType#Undefined;
            
            THIS.DoneSignature  := ULINT#0;
            THIS.StartSignature :=ULINT#0;
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
