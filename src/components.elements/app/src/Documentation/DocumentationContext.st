USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        Cu : DocumentationControllUnit;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        Cu.Main(THIS);
    END_METHOD
END_CLASS

{S7.extern=ReadWrite}
CLASS DocumentationControllUnit EXTENDS AXOpen.Core.AxoObject

    //<AxoDiDeclaration>
    VAR PUBLIC
        _testDi : AXOpen.Elements.AxoDi;
    END_VAR
    //</AxoDiDeclaration>

    //<AxoDiInitializationArgumentsDeclaration>
    VAR PUBLIC
        _testsignal : BOOL;
    END_VAR
    //</AxoDiInitializationArgumentsDeclaration>


    //<AxoDoDeclaration>
    VAR PUBLIC
        _testDo : AXOpen.Elements.AxoDo;
    END_VAR
    //</AxoDoDeclaration>

    //<AxoDoInitializationArgumentsDeclaration>
    VAR PUBLIC
        _testInOutSignal : BOOL;
    END_VAR
    //</AxoDoInitializationArgumentsDeclaration>


    //<AxoAiDeclaration>
    VAR PUBLIC
        _testAi : AXOpen.Elements.AxoAi;
    END_VAR
    //</AxoAiDeclaration>

    //<AxoAiInitializationArgumentsDeclaration>
    VAR PUBLIC
        _testAiInput : DINT := DINT#10;
    END_VAR
    //</AxoAiInitializationArgumentsDeclaration>


    //<AxoAoDeclaration>
    VAR PUBLIC
        _testAo : AXOpen.Elements.AxoAo;
    END_VAR
    //</AxoAoDeclaration>

    //<AxoAoInitializationArgumentsDeclaration>
    VAR PUBLIC
        _testAoOutput : DINT;
    END_VAR
    //</AxoAoInitializationArgumentsDeclaration>

    METHOD PUBLIC Main
        VAR_INPUT
            parent  : IAxoContext;
        END_VAR

        THIS.Initialize(THIS);

        
        //<AxoDiManualControl>
        _testDi.ActivateManualControl();
        //</AxoDiManualControl>

        //<AxoDiInitialization>
        _testDi.Run(THIS, _testsignal);
        //</AxoDiInitialization>

        //<AxoDiUsage>
        IF _testDi.IsTrue() THEN
            ;// handle signal on
        END_IF;
        //</AxoDiUsage>


        //<AxoDoManualControl>
        _testDo.ActivateManualControl();
        //</AxoDoManualControl>

        //<AxoDoInitialization>
        _testDo.Run(THIS, _testInOutSignal);
        //</AxoDoInitialization>

        //<AxoDoUsage>
        _testDo.Set();
        //</AxoDoUsage>


        //<AxoAiManualControl>
        _testAi.ActivateManualControl();
        //</AxoAiManualControl>

        //<AxoAiInitialization>
        _testAi.Run(THIS, _testAiInput);
        //</AxoAiInitialization>


        //<AxoAoManualControl>
        _testAo.ActivateManualControl();
        //</AxoAoManualControl>

        //<AxoAoInitialization>
        _testAo.Run(THIS, _testAoOutput);
        //</AxoAoInitialization>
    END_METHOD
END_CLASS
