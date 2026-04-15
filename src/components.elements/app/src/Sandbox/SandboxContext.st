USING AXOpen.Core;
USING AXOpen;
NAMESPACE AXOpen.Components.Elements
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            Cu : SandboxControllUnit;
        END_VAR
        VAR
            _rootObject : AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            Cu.Main(_rootObject);
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS SandboxControllUnit EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _manualControl : BOOL;
            
            _testDi : AXOpen.Components.Elements.AxoDi;  
            _testDiSignal : BOOL;  
        
            _testDo : AXOpen.Components.Elements.AxoDo;  
            _testDoSignal : BOOL; 

            _testAi : AXOpen.Components.Elements.AxoAi;  
            _testAiSignal : DINT := DINT#10;  

            _testAo : AXOpen.Components.Elements.AxoAo;  
            _testAoSignal : DINT;
        
        END_VAR



        METHOD PUBLIC Main
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR

            SUPER.Run(inParent);

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
END_NAMESPACE