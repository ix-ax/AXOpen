USING AXOpen.Core;

NAMESPACE AxoDialogExamples

    {S7.extern=ReadWrite}
    CLASS AxoDialogTest EXTENDS AxoObject
        VAR PUBLIC
            
            {#ix-set:AttributeName = "Restore dialog"}
            _restoreDialog : BOOL;

            {#ix-set:AttributeName = "Call dialog"}
            _callDialog : BOOL;

            {#ix-set:AttributeName = "External Button signal - OK"}
            _externButtonSignal_ok : BOOL;
            {#ix-set:AttributeName = "External Button signal - YES"}
            _externButtonSignal_yes : BOOL;
            {#ix-set:AttributeName = "External Button signal - NO"}
            _externButtonSignal_no : BOOL;
            {#ix-set:AttributeName = "External Button signal - CANCEL"}
            _externButtonSignal_cancel : BOOL;

            {#ix-set:AttributeName = "Dialog Answer"}
            _dialogAnswer : eDialogAnswer;
 
            {#ix-set:AttributeName = "example dialog"}
            _dialog : AXOpen.Core.AxoDialog;
        END_VAR    
    
        METHOD PUBLIC Run
           VAR_INPUT
            _context : IAxoContext;
            END_VAR;

            THIS.Initialize(_context);

            IF(_restoreDialog) THEN
                _dialog.Restore();    
                _restoreDialog := false;
                _callDialog:= false;
            END_IF;   
            
            IF(_callDialog) THEN
               _dialogAnswer := _dialog.ShowWithExternalClose(_parent, _externButtonSignal_ok, _externButtonSignal_yes, _externButtonSignal_no, _externButtonSignal_cancel)
                                                .WithYesNoCancel()
                                                .WithType(eDialogType#Warning)
                                                .WithCaption('What`s next?')
                                                .WithText('Decide what next?')
                                                .Answer();
                                    
                if _dialogAnswer <> eDialogAnswer#NoAnswer THEN
                    _callDialog := FALSE;
               END_IF;

            END_IF;
            
        END_METHOD
    END_CLASS    
END_NAMESPACE
