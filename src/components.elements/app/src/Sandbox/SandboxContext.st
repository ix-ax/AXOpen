USING AXOpen;
CLASS SandboContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;

        
        // _testDi : AXOpen.Elements.AxoDi;  
        // _testsignal : BOOL;  
        

    
        // _testDo : AXOpen.Elements.AxoDo;  
        // _testInOutSignal : BOOL;  
        // // _testDoInput : BOOL;  
        // // _testDoOut: BOOL;  


        // _testAi : AXOpen.Elements.AxoAi;  
        // _testAiInput : DINT := DINT#10;  

        _testAo : AXOpen.Elements.AxoAo;  
        _testAoOutput : DINT;
     
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        IF(_manualControl) THEN
            // _testDi.ActivateManualControl();
            // _testDo.ActivateManualControl();
            // _testAi.ActivateManualControl();
            _testAo.ActivateManualControl();
        END_IF;   
        
        
        // _testsignal := TRUE;
        // _testDi.Run(THIS, _testsignal);
     
        
        // _testDo.Run(THIS, _testInOutSignal);

        // _testAi.Run(THIS, _testAiInput);


        _testAo.Run(THIS, _testAoOutput);
    END_METHOD
END_CLASS