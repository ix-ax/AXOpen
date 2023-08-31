CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;

        //<AxoDiDeclaration>
        //define variables  
        _testDi : AXOpen.Elements.AxoDi;  
        _testsignal : BOOL;  
        //</AxoDiDeclaration>

        //<AxoDoDeclaration>
        //define variables  
        _testDo : AXOpen.Elements.AxoDo;  
        _testInOutSignal : BOOL;  
        //</AxoDoDeclaration>

        //<AxoAiDeclaration>
        //define variables  
        _testAi : AXOpen.Elements.AxoAi;  
        _testAiInput : DINT := DINT#10;  
        //</AxoAiDeclaration>

        //<AxoAoDeclaration>
        //define variables  
        _testAo : AXOpen.Elements.AxoAo;  
        _testAoOutput : DINT;
        //</AxoAoDeclaration>
     
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        
        //<AxoDiExample>
        // set manual control
        _testDi.ActivateManualControl();
        _testsignal := TRUE;
        // run logic
        _testDi.Run(THIS, _testsignal);

        IF _testDi.IsTrue() THEN
            ;// handle signal on
        END_IF;
        //</AxoDiExample>
     
        //<AxoDoExample>
        // set manual control
        _testDo.ActivateManualControl();
        // run logic
        _testDo.Run(THIS, _testInOutSignal);
        //</AxoDoExample>

        //<AxoAiExample>
        // set manual control
        _testAi.ActivateManualControl();
        // run logic
        _testAi.Run(THIS, _testAiInput);
        //</AxoAiExample>

        //<AxoAoExample>
        // set manual control
        _testAo.ActivateManualControl();
        // run logic
        _testAo.Run(THIS, _testAoOutput);
        //</AxoAoExample>

    END_METHOD
END_CLASS