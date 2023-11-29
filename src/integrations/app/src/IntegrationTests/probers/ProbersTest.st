USING AXOpen.Core;
USING AXOpen.Probers;

NAMESPACE IntegrationTests

    
{S7.extern=ReadWrite}
CLASS ProbersTestContext EXTENDS AxoContext
    VAR PUBLIC
        ProbeWithCounterTests : ProbeWithCounterTests;
        ProbeWithEndConditionTests : ProberWithCompletedConditionTests;
    END_VAR
    METHOD PROTECTED OVERRIDE Main              
        ProbeWithCounterTests.Run(THIS);          
        ProbeWithEndConditionTests.Run(THIS);
    END_METHOD
END_CLASS

{S7.extern=ReadWrite}
CLASS ProbeWithCounterTests EXTENDS AxoProberWithCounterBase    
    VAR PUBLIC
        _didExecuteTestMethod : BOOL;
        _numberOfCalls : ULINT;
    END_VAR   

    METHOD PROTECTED OVERRIDE Test         
        _didExecuteTestMethod := TRUE;
        _numberOfCalls := _numberOfCalls + ULINT#1;
    END_METHOD    
END_CLASS

{S7.extern=ReadWrite}
CLASS ProberWithCompletedConditionTests EXTENDS AxoProberWithCompletedCondition    
    VAR PUBLIC
        _didExecuteTestMethod : BOOL;
        _numberOfCalls : ULINT;
    END_VAR   

    METHOD PROTECTED OVERRIDE Test  : BOOL  
        _didExecuteTestMethod := TRUE;
        _numberOfCalls := ULINT#123;    
        Test := TRUE;
    END_METHOD    
END_CLASS

END_NAMESPACE
