NAMESPACE AXOpen.Core
    CLASS PUBLIC AxoAlertDialog EXTENDS AxoDialogBase

        VAR PUBLIC      
            _dialogType : eDialogType;
            _title : STRING;
            _message : STRING;
            _timeToBurn : INT;
        END_VAR

        METHOD PUBLIC Show : IAxoTaskState
            VAR_INPUT
                _parent : IAxoObject;
                DialogType : eDialogType;
                Title : STRING;
                Message : STRING;
                TimeToBurn : INT;
            END_VAR

            THIS.Initialize(_parent);

            Show := THIS.Invoke();
            SUPER.Execute();

            _dialogType := DialogType;
            _title := Title;
            _message := Message;
            _timeToBurn := TimeToBurn;
        END_METHOD
    
END_CLASS    
END_NAMESPACE