USING AXOpen.Core;

NAMESPACE AxoTextListExample


    CLASS AxoTextListExampleContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Click to increment text list Id"}
            _incrementTask : AXOpen.Core.AxoTask;
            {#ix-set:AttributeName = "Click to reset text list Id to zero"}
            _set2zeroTask : AXOpen.Core.AxoTask;
            //<AxoTextListWithLevelsDefined>
            {#ix-set:AttributeName = "Description: |[[1]TextList]|"}
            {#ix-attr:[WarningLevel(600)]}
            {#ix-attr:[ErrorLevel(700)]}
            _myTextList1 : AXOpen.Core.AxoTextList;
            //</AxoTextListWithLevelsDefined>
            //<AxoTextListWithoutPrefix>
            {#ix-set:AttributeName = "|[[1]TextList]|"}
            {#ix-attr:[WarningLevel(300)]}
            {#ix-attr:[ErrorLevel(500)]}
            _myTextList2 : AXOpen.Core.AxoTextList;
            //</AxoTextListWithoutPrefix>
            //<AxoTextListWithoutLevelsDefined>
            {#ix-set:AttributeName = "Totaly different description without error elevation: |[[1]DifferentTextList]|"}
            _myTextList3 : AXOpen.Core.AxoTextList;
            //</AxoTextListWithoutLevelsDefined>
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _incrementTask.Initialize(THIS);    
            _set2zeroTask.Initialize(THIS);    

            IF(_incrementTask.Execute()) THEN  
                _myTextList1.Id := _myTextList1.Id + UINT#1;
               _incrementTask.DoneWhen(_myTextList1.Id>= UINT#1000);
            END_IF;    

            IF(_set2zeroTask.Execute()) THEN  
                _incrementTask.Restore();
                _myTextList1.Id := UINT#0;
                _set2zeroTask.DoneWhen(TRUE);
            END_IF;    
            _myTextList2.Id := _myTextList1.Id;
            _myTextList3.Id := _myTextList1.Id;
    END_METHOD
    END_CLASS    
END_NAMESPACE
