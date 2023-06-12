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

        METHOD PUBLIC OVERRIDE FB_init : BOOL
            VAR_INPUT
                bInitRetains : BOOL;
                bInCopyCode : BOOL;
                ParentObject : IAxoObject;
            END_VAR
    
            FB_init := true;
        END_METHOD

        METHOD PUBLIC Show : IAxoDialogFormat
            /*IF _taskState = eTaskState.Ready THEN
                Answer := eDialogAnswer.NoAnswer;
            END_IF;

            _hasOK := false;
            _hasYes := false;
            _hasNo := false;
            _hasCancel := false;
            _text := '';
            _caption := '';
            _dialogType := eDialogType.Undefined;

            show := IAxoDialogFormat = this;

            IF _taskState = eTaskState.Done && _answer <> eDialogAnswer.NoAnswer THEN
                Restore();
            END_IF;*/
            ;
            Show := show;
        END_METHOD
    
    
    METHOD PUBLIC WithCaption : IAxoDialogAnswer
        VAR_INPUT
            inCaption : STRING;
        END_VAR
        
        _caption := inCaption;
        WithCaption := this;
    END_METHOD

    METHOD PUBLIC WithOk : IAxoDialogAnswer
        _hasOK := TRUE;
        WithOk := this;
    END_METHOD

    METHOD PUBLIC WithText : IAxoDialogAnswer
        VAR_INPUT
            inText : STRING;
        END_VAR

        _text := inText;
        WithText := this;
    END_METHOD

    METHOD PUBLIC WithType : IAxoDialogAnswer
        VAR_INPUT
            inDialogType : eDialogType;
        END_VAR

        _dialogType := inDialogType;
        WithType := this;
    END_METHOD

    METHOD PUBLIC WithYesNo : IAxoDialogAnswer
        _hasYes := TRUE;
        _hasNo := TRUE;
        WithYesNo := this;
    END_METHOD

    METHOD PUBLIC WithYesNoCancel : IAxoDialogAnswer
        _hasYES := TRUE;
        _hasNo := TRUE;
        _hasCancel := TRUE;
        WithYesNoCancel := this;
    END_METHOD

    METHOD PUBLIC Answer : eDialogAnswer
        Answer := _answer;
    END_METHOD
END_CLASS    
END_NAMESPACE