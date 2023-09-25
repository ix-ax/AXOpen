USING AXOpen.Core;

NAMESPACE AxoToggleTaskExamples

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
            _toggleTask1.Initialize(THIS);    
            _toggleTask1.Run();
            _toggleTask2.Initialize(THIS);    
            _toggleTask2.Run();
        END_METHOD
    END_CLASS    
END_NAMESPACE
