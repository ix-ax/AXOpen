USING AXOpen.Core;

NAMESPACE AxoDialogExamples

    {S7.extern=ReadWrite}
    CLASS AxoDialogTest EXTENDS AxoObject
        VAR PUBLIC
            
            {#ix-set:AttributeName = "Restore dialog"}
            _restoreDialog : BOOL;

            {#ix-set:AttributeName = "Call dialog"}
            _callDialog : BOOL;

            {#ix-set:AttributeName = "Call dialog in sequnce"}
            _callDialogInSequnce : BOOL;
            {#ix-set:AttributeName = "Iteration"}
            _iterationStep : INT;
            _timeOutCounter : INT;                


            {#ix-set:AttributeName = "External Button signal - OK"}
            _externButtonSignal_ok : BOOL;
            {#ix-set:AttributeName = "External Button signal - YES"}
            _externButtonSignal_yes : BOOL;
            {#ix-set:AttributeName = "External Button signal - NO"}
            _externButtonSignal_no : BOOL;
            {#ix-set:AttributeName = "External Button signal - CANCEL"}
            _externButtonSignal_cancel : BOOL;

            Caption : STRING := 'Caption';
            Question : STRING := 'Question';

            {#ix-set:AttributeName = "Dialog Answer"}
            _answer : eDialogAnswer;
 
            {#ix-set:AttributeName = "example dialog"}
            _d : AXOpen.Core.AxoDialog;
        END_VAR    


        VAR 
        END_VAR
    
        METHOD PUBLIC Run
           VAR_INPUT
            _context : IAxoContext;
            END_VAR;

            THIS.Initialize(_context);
            
            IF(_restoreDialog) THEN
                _restoreDialog := false;
                _d.Restore();    
                _callDialog:= false;
                _callDialogInSequnce := false;
                _iterationStep := 0;
                _timeOutCounter := 0;
            END_IF;   
            
            IF(_callDialog) THEN
               _answer := _d.ShowWithExternalClose(THIS, _externButtonSignal_ok, _externButtonSignal_yes, _externButtonSignal_no, _externButtonSignal_cancel)
                                                .WithYesNoCancel()
                                                .WithType(eDialogType#Warning)
                                                .WithCaption(Caption)
                                                .WithText(Question)
                                                .Answer();
                                    
                if _answer <> eDialogAnswer#NoAnswer THEN
                    _callDialog := FALSE;
               END_IF;
            END_IF;
            

            IF _callDialogInSequnce THEN


                if  _iterationStep  = 0 then 
                    _iterationStep := _iterationStep + 1;
                end_if;


                if  _iterationStep  = 1 then 

                    if not _d.HasError() then 
                        _answer := _d.ShowWithExternalClose(THIS, _externButtonSignal_ok, _externButtonSignal_yes, _externButtonSignal_no, _externButtonSignal_cancel)
                        .WithYesNoCancel()
                        .WithType(eDialogType#Info)
                        .WithCaption( 'Iteraion 1')
                        .WithText(Question)
                        .Answer();
            
                        THIS.Watcher_Monitor();
                        if _answer <> eDialogAnswer#NoAnswer THEN
                            THIS.Watcher_Reset();
                            _iterationStep := _iterationStep + 1;
                        END_IF;

                    end_if;
                  
                end_if;

                if  _iterationStep  = 2 then 

                    if not _d.HasError() then 
                        _answer := _d.ShowWithExternalClose(THIS, _externButtonSignal_ok, _externButtonSignal_yes, _externButtonSignal_no, _externButtonSignal_cancel)
                        .WithYesNoCancel()
                        .WithType(eDialogType#Success)
                        .WithCaption('Iteraion 2')
                        .WithText(Question)
                        .Answer();
            
                        THIS.Watcher_Monitor();
                        if _answer <> eDialogAnswer#NoAnswer THEN
                            THIS.Watcher_Reset();
                            _iterationStep := _iterationStep + 1;
                        END_IF;
                    end_if;

                end_if;

                if  _iterationStep  = 3 then 
                    if not _d.HasError() then 
                        _answer := _d.ShowWithExternalClose(THIS, _externButtonSignal_ok, _externButtonSignal_yes, _externButtonSignal_no, _externButtonSignal_cancel)
                        .WithYesNoCancel()
                        .WithType(eDialogType#Warning)
                        .WithCaption('Iteraion 3')
                        .WithText(Question)
                        .Answer();
            
                        THIS.Watcher_Monitor();
                        if _answer <> eDialogAnswer#NoAnswer THEN
                            THIS.Watcher_Reset();
                            _iterationStep := _iterationStep + 1;
                        END_IF;
                    end_if;

                end_if;

                if  _iterationStep  = 4 then 
                    if not _d.HasError() then 
                        _answer := _d.ShowWithExternalClose(THIS, _externButtonSignal_ok, _externButtonSignal_yes, _externButtonSignal_no, _externButtonSignal_cancel)
                        .WithYesNoCancel()
                        .WithType(eDialogType#Danger)
                        .WithCaption('Iteraion 4')
                        .WithText(Question)
                        .Answer();
            
                        THIS.Watcher_Monitor();
                        if _answer <> eDialogAnswer#NoAnswer THEN
                            THIS.Watcher_Reset();
                            _iterationStep := _iterationStep + 1;
                        END_IF;
                    end_if;

                end_if;

                // if  _iterationStep  >= 5 then 
                //     _iterationStep := 0;
                //     _callDialogInSequnce := false;
                // end_if;
            end_if;

        END_METHOD

        METHOD PRIVATE Watcher_Monitor
            _timeOutCounter := _timeOutCounter + 1;
            if _timeOutCounter > 300 then 
                _externButtonSignal_cancel := true;
            END_IF;
        END_METHOD

        METHOD PRIVATE Watcher_Reset
            _timeOutCounter := 0;
            _externButtonSignal_cancel := false;
            _externButtonSignal_ok := false;
            _externButtonSignal_yes := false;
            _externButtonSignal_no := false;
        END_METHOD

    END_CLASS    
END_NAMESPACE
