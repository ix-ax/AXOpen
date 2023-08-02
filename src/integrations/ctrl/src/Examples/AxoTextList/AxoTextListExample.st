USING AXOpen.Core;

NAMESPACE AxoTextListExample


    CLASS AxoTextListExampleContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Click to increment text list Id"}
            _incrementTask : AXOpen.Core.AxoTask;
            {#ix-set:AttributeName = "Click to reset text list Id to zero"}
            _set2zeroTask : AXOpen.Core.AxoTask;

            {#ix-set:AttributeName = "Description: |[[1]Description]|"}
            _myTextList : AXOpen.Core.AxoTextList;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _incrementTask.Initialize(THIS);    
            _set2zeroTask.Initialize(THIS);    

            IF(_incrementTask.Execute()) THEN  
                _myTextList.Id := _myTextList.Id + UINT#1;
               _incrementTask.DoneWhen(_myTextList.Id>= UINT#1000);
            END_IF;    

            IF(_set2zeroTask.Execute()) THEN  
                _incrementTask.Restore();
                _myTextList.Id := UINT#0;
                _set2zeroTask.DoneWhen(TRUE);
            END_IF;    
        END_METHOD
    END_CLASS    
END_NAMESPACE
