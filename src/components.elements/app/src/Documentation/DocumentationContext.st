USING AXOpen.Core;

NAMESPACE AXOpen.Components.Elements
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            Cu : DocumentationControllUnit;
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
    CLASS DocumentationControllUnit EXTENDS AXOpen.Core.AxoObject

        //<AxoDiDeclaration>
        VAR PUBLIC
            _testDi : AXOpen.Components.Elements.AxoDi;
        END_VAR
        //</AxoDiDeclaration>

        //<AxoDiInitializationArgumentsDeclaration>
        VAR PUBLIC
            _testsignal : BOOL;
        END_VAR
        //</AxoDiInitializationArgumentsDeclaration>


        //<AxoDoDeclaration>
        VAR PUBLIC
            _testDo : AXOpen.Components.Elements.AxoDo;
        END_VAR
        //</AxoDoDeclaration>

        //<AxoDoInitializationArgumentsDeclaration>
        VAR PUBLIC
            _testInOutSignal : BOOL;
        END_VAR
        //</AxoDoInitializationArgumentsDeclaration>


        //<AxoAiDeclaration>
        VAR PUBLIC
            _testAi : AXOpen.Components.Elements.AxoAi;
        END_VAR
        //</AxoAiDeclaration>

        //<AxoAiInitializationArgumentsDeclaration>
        VAR PUBLIC
            _testAiInput : DINT := DINT#10;
        END_VAR
        //</AxoAiInitializationArgumentsDeclaration>


        //<AxoAoDeclaration>
        VAR PUBLIC
            _testAo : AXOpen.Components.Elements.AxoAo;
        END_VAR
        //</AxoAoDeclaration>

        //<AxoAoInitializationArgumentsDeclaration>
        VAR PUBLIC
            _testAoOutput : DINT;
        END_VAR
        //</AxoAoInitializationArgumentsDeclaration>

        //<AxoCarouselDeclaration>
        VAR PUBLIC
            _testCarousel : AXOpen.Components.Elements.AxoCarousel;
        END_VAR
        //</AxoCarouselDeclaration>

        //<AxoCarouselInitializationArgumentsDeclaration>
        VAR PUBLIC
                _testCarouselSafetyCondition    :   BOOL;
            	_testCarouselInPosition         :   BOOL;
            	_testCarouselInPrecisePosition  :   BOOL;                
                _testCarouselCodingPosition     :   UINT;
                _testCarouselEnableTurn         :   BOOL;
                _testCarouselStartTurn          :   BOOL;
        END_VAR
        //</AxoCarouselInitializationArgumentsDeclaration>

        METHOD PUBLIC Main
            VAR_INPUT
                parent  : IAxoObject;
            END_VAR

            SUPER.Run(parent);

            
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

            //<AxoCarouselManualControl>
            _testCarousel.ActivateManualControl();
            //</AxoCarouselManualControl>

            //<AxoCarouselInitialization>
            _testCarousel.Config.ErrorTime:=T#10S;
            _testCarousel.Config.InfoTime:=T#2S;
            _testCarousel.Config.Direction:=eAxoCarouselDirection#Cw;
            _testCarousel.Config.NumberOfPositions:=UINT#8;
            _testCarousel.Config.Offset:=UINT#2;

            _testCarousel.Run(  parent              :=  THIS,
                                SafetyCondition     :=  _testCarouselSafetyCondition,
                                InPosition          :=  _testCarouselInPosition,
                                InPrecisePosition   :=  _testCarouselInPrecisePosition,
                                CodingPosition      :=  _testCarouselCodingPosition,
                                EnableTurn          =>  _testCarouselEnableTurn,
                                StartTurn           =>  _testCarouselStartTurn);
            //</AxoCarouselInitialization>
        END_METHOD
    END_CLASS
END_NAMESPACE
