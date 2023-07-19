USING System.EdgeDetection;
NAMESPACE AXOpen.Core
    ///<summary>
    /// AxoDialog class, which represents structure of base dialog.
    ///</summary>
    CLASS PUBLIC AxoDialog EXTENDS AxoDialogBase IMPLEMENTS IAxoDialogFormat, IAxoDialogAnswer

        VAR PUBLIC      
            _text : STRING;
            _caption : STRING;
            _hasOK : BOOL;
            _hasYes : BOOL;
            _hasNo : BOOL;
            _hasCancel : BOOL;
            _answer : eDialogAnswer;
            _dialogType : eDialogType;
            _externalCloseReq : BOOL;
            _closeSignal : BOOL;
            _risingEdge : RisingEdge;
            _edgeDetected : BOOL;
        END_VAR
        
        ///<summary>
        /// Show method, which serves for initializing remote task and invoking dialog from PLC.
        ///</summary>
        METHOD PUBLIC Show : IAxoDialogFormat
            VAR_INPUT
                _parent : IAxoObject;
            END_VAR    

            THIS.Initialize(_parent);
            //before task initialization, set _asnwer to #NoAnswer to avoid inconsitencies
            IF (THIS.Status = eAxoTaskState#Ready) THEN
                _answer := eDialogAnswer#NoAnswer;
            END_IF;

            THIS.Invoke();
            SUPER.Execute();
            _hasOK := false;
            _hasYes := false;
            _hasNo := false;
            _hasCancel := false;
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
        /// Show method, which serves for initializing remote task and invoking dialog from PLC.
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
            END_IF;

            THIS.Invoke();
            SUPER.Execute();


            _hasOK := FALSE;
            _hasYes := FALSE;
            _hasNo := FALSE;
            _hasCancel := FALSE;
            _externalCloseReq := TRUE;
            _text := '';
            _caption := '';
            _dialogType := eDialogType#Undefined;

            ShowWithExternalClose := THIS;

            //_risingEdge(signal := inOkAnswerSignal XOR inYesAnswerSignal XOR inNoAnswerSignal XOR inCancelAnswerSignal, detected => edgeDetected);
            _risingEdge(signal := inNoAnswerSignal, detected => edgeDetected);
            IF edgeDetected THEN
                _closeSignal := TRUE;
                IF inOkAnswerSignal THEN
                    _answer := eDialogAnswer#Ok;
                ELSIF	inYesAnswerSignal THEN
                    _answer:= eDialogAnswer#Yes;
                ELSIF	inNoAnswerSignal THEN
                    _answer:= eDialogAnswer#No;
                ELSIF	inCancelAnswerSignal THEN 
                    _answer:= eDialogAnswer#Cancel;END_IF;
            END_IF;

            //after task is done and some answer is provided, restore this task
            IF (THIS.Status = eAxoTaskState#Done && _answer <> eDialogAnswer#NoAnswer) THEN
                _externalCloseReq := FALSE;
                _closeSignal := FALSE;
                THIS.Restore();       
            END_IF;
            
        
            
        END_METHOD


        



    
    METHOD PUBLIC WithCaption : IAxoDialogAnswer
        VAR_INPUT
            inCaption : STRING;
        END_VAR
        
        _caption := inCaption;
        WithCaption := THIS;
    END_METHOD

    METHOD PUBLIC WithOk : IAxoDialogAnswer
        _hasOK := TRUE;
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
        _hasYes := TRUE;
        _hasNo := TRUE;
        WithYesNo := THIS;
    END_METHOD

    METHOD PUBLIC WithYesNoCancel : IAxoDialogAnswer
        _hasYES := TRUE;
        _hasNo := TRUE;
        _hasCancel := TRUE;
        WithYesNoCancel := THIS;
    END_METHOD


    METHOD PUBLIC Answer : eDialogAnswer
        Answer := _answer;
    END_METHOD
    
END_CLASS    
END_NAMESPACE