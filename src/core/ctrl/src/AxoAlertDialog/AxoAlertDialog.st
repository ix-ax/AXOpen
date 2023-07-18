NAMESPACE AXOpen.Core
    
    CLASS PUBLIC AxoAlertDialog EXTENDS AxoRemoteTask IMPLEMENTS IAxoAlertDialogFormat

        VAR PUBLIC      
            _dialogType : eDialogType;
            _title : STRING;
            _message : STRING;
            _timeToBurn : UINT := UINT#5;
        END_VAR

        METHOD PUBLIC Show : IAxoAlertDialogFormat
            VAR_INPUT
                _parent : IAxoObject;
            END_VAR

            THIS.Initialize(_parent);

            
            THIS.Invoke();
            SUPER.Execute();

            _dialogType := eDialogType#Undefined;
            _title := '';
            _message := '';
            _timeToBurn := UINT#5;

            Show := THIS;

            // IF (THIS.Status = eAxoTaskState#Done) THEN
            //     THIS.Restore();      
            // END_IF;
        END_METHOD
    

        
    METHOD PUBLIC WithTitle : IAxoAlertDialogFormat
        VAR_INPUT
            inTitle : STRING;
        END_VAR
        _title := inTitle;
        WithTitle := THIS;
    END_METHOD

    METHOD PUBLIC WithMessage : IAxoAlertDialogFormat
        VAR_INPUT
            inMessage : STRING;
        END_VAR
        _message := inMessage;
        WithMessage := THIS;
    END_METHOD

    METHOD PUBLIC WithTimeToBurn : IAxoAlertDialogFormat
        VAR_INPUT
            inSeconds : UINT;
        END_VAR
        _timeToBurn := inSeconds;
        WithTimeToBurn := THIS;
    END_METHOD

    METHOD PUBLIC WithType : IAxoAlertDialogFormat
        VAR_INPUT
            inDialogType : eDialogType;
        END_VAR
        _dialogType := inDialogType;
        WithType := THIS;
    END_METHOD


END_CLASS    
END_NAMESPACE