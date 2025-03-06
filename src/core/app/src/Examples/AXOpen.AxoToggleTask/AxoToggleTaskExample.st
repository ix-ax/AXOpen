USING AXOpen.Core;

NAMESPACE AxoToggleTaskExamples

    {S7.extern=ReadWrite}
    CLASS Tasks EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Toggle task 1#>"}
            _toggleTask1 :AxoToggleTask;
            {#ix-set:AttributeName = "<#Toggle task 2#>"}
            {#ix-set:AttributeStateOnDesc = "<#SwitchedOn#>"}
            {#ix-set:AttributeStateOffDesc = "<#SwitchedOff#>"}
            _toggleTask2 :AxoToggleTask;
       END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_toggleTask1);    
            _toggleTask1.Run();
            THIS.InitializeRootObject(_toggleTask2);    
            _toggleTask2.Run();
        END_METHOD
    END_CLASS    
END_NAMESPACE
