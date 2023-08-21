USING AXOpen;
CLASS SandboContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _testCyclinder : AXOpen.Pneumatics.Cylinder;    
        
        
        _testDi : AXOpen.Elements.AxoDi;  
        _testsignal : BOOL;  
        _testOutSignal : BOOL;  


        _testDo : AXOpen.Elements.AxoDo;  
        _testDoInput : BOOL;  
        _testDoOut: BOOL;  


        _testAi : AXOpen.Elements.AxoAi;  
        _testAiInput : DINT := DINT#10;  

        _testAo : AXOpen.Elements.AxoAo;  
        _testAoOutput : DINT := DINT#10;  
        // _testDoOut: BOOL;  
    END_VAR

    VAR PRIVATE
        _homeSensor : BOOL;
        _workSensor : BOOL;
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        IF(_manualControl) THEN
            _testCyclinder.ActivateManualControl();
            _testDi.ActivateManualControl();
            _testDo.ActivateManualControl();
            _testAi.ActivateManualControl();
            _testAo.ActivateManualControl();
        END_IF;   


        _testCyclinder.Run(THIS, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);
       
        
        
        _testsignal := TRUE;
        _testDi.AxoDiSignal(THIS, _testsignal);
     
        
        _testDo.AxoDoSignal(THIS, _testDoInput);

    

        IF _testDoInput THEN
            _testOutSignal := TRUE;
        ELSE
            _testOutSignal := FALSE;
        END_IF;

        _testAiInput := DINT#10;
       
        _testAi.AxoAiSignal(THIS, _testAiInput);


        _testAo.AxoAoSignal(THIS, _testAoOutput);
    END_METHOD
END_CLASS