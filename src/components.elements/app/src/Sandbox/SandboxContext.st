USING AXOpen.Core;
USING AXOpen;
{S7.extern=ReadWrite}
CLASS SandboContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        Cu : SandboxControllUnit;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        Cu.Main(THIS);
    END_METHOD
END_CLASS

{S7.extern=ReadWrite}
CLASS SandboxControllUnit EXTENDS AXOpen.Core.AxoObject
    VAR PUBLIC
        _manualControl : BOOL;
        
        _testDi : AXOpen.Elements.AxoDi;  
        _testDiSignal : BOOL;  
    
        _testDo : AXOpen.Elements.AxoDo;  
        _testDoSignal : BOOL; 

        _testAi : AXOpen.Elements.AxoAi;  
        _testAiSignal : DINT := DINT#10;  

        _testAo : AXOpen.Elements.AxoAo;  
        _testAoSignal : DINT;
     
    END_VAR

    METHOD PUBLIC Main
        VAR_INPUT
            parent : IAxoContext;
        end_var

        THIS.Initialize(parent);

        IF(_manualControl) THEN
            _testDi.ActivateManualControl();
            _testDo.ActivateManualControl();
            _testAi.ActivateManualControl();
            _testAo.ActivateManualControl();
        END_IF;   
        
        
        _testDi.Run(THIS, _testDiSignal);
        
        _testDo.Run(THIS, _testDiSignal);

        _testAi.Run(THIS, _testAiSignal);

        _testAo.Run(THIS, _testAoSignal);

    END_METHOD
END_CLASS
