USING AXOpen.Core;

NAMESPACE AXOpen.Components.Elements
    {S7.extern=ReadWrite}
    CLASS ElementsShowcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            Cu : DocumentationControllUnit;
        END_VAR
        VAR
            _rootObject : AxoObject;
        END_VAR
        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
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


        //<AxoBacklitButtonDeclaration>
        VAR PUBLIC
            _testBacklitButton : AXOpen.Components.Elements.AxoBacklitButton;
        END_VAR
        //</AxoBacklitButtonDeclaration>

        //<AxoBacklitButtonInitializationArgumentsDeclaration>
        VAR PUBLIC
            _testButtonSignal : BOOL;    // Physical button input
            _testButtonLed    : BOOL;    // LED output to button lamp
        END_VAR
        //</AxoBacklitButtonInitializationArgumentsDeclaration>


        //<AxoSignalTowerDeclaration>
        VAR PUBLIC
            _testSignalTower : AXOpen.Components.Elements.AxoSignalTower;
        END_VAR
        //</AxoSignalTowerDeclaration>

        //<AxoSignalTowerInitializationArgumentsDeclaration>
        VAR PUBLIC
            _testTowerRed    : BOOL;
            _testTowerGreen  : BOOL;
            _testTowerBlue   : BOOL;
            _testTowerYellow : BOOL;
            _testTowerHorn   : BOOL;
        END_VAR
        //</AxoSignalTowerInitializationArgumentsDeclaration>


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
            _testCarousel : AXOpen.Components.Elements.AxoRotaryIndexingTable;
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

                _testCarouselSuspend1           :   BOOL;
                _testCarouselSuspend2           :   BOOL;
                _testCarouselSuspend3           :   BOOL;
            END_VAR
        //</AxoCarouselInitializationArgumentsDeclaration>

        METHOD PUBLIC Main
            VAR_INPUT
                inParent  : IAxoObject;
            END_VAR

            SUPER.Run(inParent);

            
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

            //<AxoAiConfig>
            // Scale raw 0..27648 to engineering 0.0..100.0 (e.g., pressure in bar)
            _testAi._config.RawLow  := DINT#0;
            _testAi._config.RawHigh := DINT#27648;
            _testAi._config.RealLow  := REAL#0.0;
            _testAi._config.RealHigh := REAL#100.0;
            _testAi._config.Gain   := REAL#1.0;
            _testAi._config.Offset := REAL#0.0;
            //</AxoAiConfig>

            //<AxoAiInitialization>
            _testAi.Run(THIS, _testAiInput);
            //</AxoAiInitialization>

            //<AxoAiUsage>
            // Read the scaled value from status
            ; // _testAi._status.Scaled contains the engineering value
            //</AxoAiUsage>


            //<AxoAoManualControl>
            _testAo.ActivateManualControl();
            //</AxoAoManualControl>

            //<AxoAoConfig>
            // Unscale engineering 0.0..100.0 back to raw 0..27648
            _testAo._config.RawLow  := DINT#0;
            _testAo._config.RawHigh := DINT#27648;
            _testAo._config.RealLow  := REAL#0.0;
            _testAo._config.RealHigh := REAL#100.0;
            _testAo._config.Gain   := REAL#1.0;
            _testAo._config.Offset := REAL#0.0;
            //</AxoAoConfig>

            //<AxoAoInitialization>
            _testAo._requiredValue := REAL#50.0;  // Set output to 50% of range
            _testAo.Run(THIS, _testAoOutput);
            //</AxoAoInitialization>

            //<AxoAoUsage>
            // Read the unscaled value from status
            ; // _testAo._status.Unscaled contains the raw output value
            //</AxoAoUsage>


            //<AxoBacklitButtonManualControl>
            _testBacklitButton.ActivateManualControl();
            //</AxoBacklitButtonManualControl>

            //<AxoBacklitButtonInitialization>
            _testBacklitButton.Run(inParent  := THIS,
                                   inSignal  := _testButtonSignal,
                                   outLed    => _testButtonLed);
            //</AxoBacklitButtonInitialization>

            //<AxoBacklitButtonUsage>
            // Check button press via internal AxoDi
            IF _testBacklitButton.Button.IsTrue() THEN
                _testBacklitButton.Led.Set();  // Turn on LED when pressed
            END_IF;
            //</AxoBacklitButtonUsage>


            //<AxoSignalTowerManualControl>
            _testSignalTower.ActivateManualControl();
            //</AxoSignalTowerManualControl>

            //<AxoSignalTowerInitialization>
            _testSignalTower.Run(inParent   := THIS,
                                 outRed     => _testTowerRed,
                                 outGreen   => _testTowerGreen,
                                 outBlue    => _testTowerBlue,
                                 outYellow  => _testTowerYellow,
                                 outHorn    => _testTowerHorn);
            //</AxoSignalTowerInitialization>

            //<AxoSignalTowerUsage>
            // Control individual lights via internal AxoDo components
            _testSignalTower.Green.Set();   // Green = running OK
            //</AxoSignalTowerUsage>

            //<AxoCarouselManualControl>
            _testCarousel.ActivateManualControl();
            //</AxoCarouselManualControl>

            //<AxoCarouselInitialization>
            _testCarousel.Config.ErrorTime:=T#100S;
            _testCarousel.Config.InfoTime:=T#20S;
            _testCarousel.Config.TaskTimeout:=T#200S;
            _testCarousel.Config.Direction:=eAxoRotaryIndexingTableDirection#Cw;
            _testCarousel.Config.NumberOfPositions:=UINT#8;
            _testCarousel.Config.Offset:=UINT#2;

            _testCarousel.Run(  inParent            :=  THIS,
                                inSafetyCondition   :=  _testCarouselSafetyCondition,
                                inPosition          :=  _testCarouselInPosition,
                                inPrecisePosition   :=  _testCarouselInPrecisePosition,
                                inCodingPosition    :=  _testCarouselCodingPosition,
                                outEnableTurn       =>  _testCarouselEnableTurn,
                                outStartTurn        =>  _testCarouselStartTurn);

            _testCarousel.SuspendMovementWhile(_testCarouselSuspend1,'Movement blocked by signal _testCarouselSuspend1');
            _testCarousel.SuspendMovementWhile(_testCarouselSuspend2,'Movement blocked by signal _testCarouselSuspend2');
            _testCarousel.SuspendMovementWhile(_testCarouselSuspend3,'Movement blocked by signal _testCarouselSuspend3');

            //</AxoCarouselInitialization>
        END_METHOD
    END_CLASS
END_NAMESPACE
