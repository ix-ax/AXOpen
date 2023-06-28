NAMESPACE AXOpen.Core
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
        END_VAR

        

        METHOD PUBLIC Show : IAxoDialogFormat
            VAR_INPUT
                _parent : IAxoObject;
            END_VAR    

            THIS.Initialize(_parent);

            THIS.Invoke();
            SUPER.Execute();
            IF (THIS.Status = eAxoTaskState#Ready) THEN
                _answer := eDialogAnswer#NoAnswer;
            END_IF;

            _hasOK := false;
            _hasYes := false;
            _hasNo := false;
            _hasCancel := false;
            _text := '';
            _caption := '';
            _dialogType := eDialogType#Undefined;


        
            
            Show := THIS;
            
            IF (THIS.Status = eAxoTaskState#Done && _answer <> eDialogAnswer#NoAnswer) THEN
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