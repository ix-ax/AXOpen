USING AXOpen.Core;

// Showcase examples for AXOpen.Timers — demonstrates OnDelayTimer,
// OffDelayTimer, PulseTimer, and AxoBlinker usage patterns.
NAMESPACE AXOpen.Showcase.Timers

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _timersDoc : TimersDoc;
            _automat : TimersAutomat;
            _startExample : BOOL := FALSE;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _timersDoc.Run(_rootObject);
            _automat.Execute(_rootObject);

            IF _startExample THEN
                _automat.Invoke();
            END_IF;
        END_METHOD
    END_CLASS

    // Demonstrates individual timer declarations and basic usage.
    {S7.extern=ReadWrite}
    CLASS PUBLIC TimersDoc EXTENDS AXOpen.Core.AxoObject
        //<TimerDeclarations>
        VAR PUBLIC
            _onDelayTimer : AXOpen.Timers.OnDelayTimer;
            _offDelayTimer : AXOpen.Timers.OffDelayTimer;
            _pulseTimer : AXOpen.Timers.PulseTimer;
            _blinker : AXOpen.Timers.AxoBlinker;

            _onDelayInput : BOOL;
            _offDelayInput : BOOL;
            _pulseInput : BOOL;
        END_VAR
        //</TimerDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<TimerUsage>
            // OnDelayTimer: output turns ON after the input has been TRUE
            // for the specified duration.
            _onDelayTimer.OnDelay(THIS, _onDelayInput, LTIME#2000ms);

            // OffDelayTimer: output stays ON for the specified duration
            // after the input goes FALSE.
            _offDelayTimer.OffDelay(THIS, _offDelayInput, LTIME#3000ms);

            // PulseTimer: output stays ON for the specified duration
            // after a rising edge on input.
            _pulseTimer.Pulse(THIS, _pulseInput, LTIME#1500ms);

            // AxoBlinker: output toggles with configurable on/off times.
            _blinker.Blink(THIS, TIME#500ms, TIME#500ms);
            //</TimerUsage>
        END_METHOD
    END_CLASS

    // Sequencer-based demonstration of timer operations.
    {#ix-set:AttributeName = "<#TIMERS AUTOMAT#>"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC TimersAutomat EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..50] OF AxoStep;

            _onDelayTimer : AXOpen.Timers.OnDelayTimer;
            _offDelayTimer : AXOpen.Timers.OffDelayTimer;
            _pulseTimer : AXOpen.Timers.PulseTimer;
            _blinker : AXOpen.Timers.AxoBlinker;

            _onDelayInput : BOOL;
            _offDelayInput : BOOL;
            _pulseInput : BOOL;
        END_VAR

        METHOD OVERRIDE Main

            THIS.SequenceMode := eAxoSequenceMode#Cyclic;

            IF (Steps[0].Execute(THIS, TRUE, 'Activate OnDelay timer input')) THEN
                _onDelayInput := TRUE;
                THIS.MoveNext();
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, 'Wait for OnDelay output (2s delay)')) THEN
                _onDelayTimer.OnDelay(THIS, _onDelayInput, LTIME#2000ms);
                IF _onDelayTimer.output THEN
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF (Steps[2].Execute(THIS, TRUE, 'Deactivate OnDelay input, activate OffDelay')) THEN
                _onDelayInput := FALSE;
                _offDelayInput := TRUE;
                THIS.MoveNext();
            END_IF;

            IF (Steps[3].Execute(THIS, TRUE, 'Deactivate OffDelay input, wait for timeout (3s)')) THEN
                _offDelayInput := FALSE;
                _offDelayTimer.OffDelay(THIS, _offDelayInput, LTIME#3000ms);
                IF NOT _offDelayTimer.output THEN
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF (Steps[4].Execute(THIS, TRUE, 'Trigger Pulse timer (1.5s pulse)')) THEN
                _pulseInput := TRUE;
                _pulseTimer.Pulse(THIS, _pulseInput, LTIME#1500ms);
                IF NOT _pulseTimer.output AND Steps[4].Duration > LTIME#1600ms THEN
                    _pulseInput := FALSE;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF (Steps[5].Execute(THIS, TRUE, 'Run Blinker for 5 seconds')) THEN
                _blinker.Blink(THIS, TIME#500ms, TIME#500ms);
                IF Steps[5].Duration > LTIME#5000ms THEN
                    _blinker.Restore();
                    THIS.MoveNext();
                END_IF;
            END_IF;

            THIS.Close(Steps[6]);
        END_METHOD
    END_CLASS

END_NAMESPACE
