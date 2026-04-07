USING AXOpen.Core;

// Showcase examples for AXOpen.Probers — demonstrates AxoProberWithCounterBase
// and AxoProberWithCompletedCondition usage patterns.
NAMESPACE AXOpen.Showcase.Probers

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _probersDoc : ProbersDoc;
            _startExample : BOOL := FALSE;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _probersDoc.Run(_rootObject);
        END_METHOD
    END_CLASS

    // Demonstrates concrete prober implementations.
    {S7.extern=ReadWrite}
    CLASS PUBLIC ProbersDoc EXTENDS AXOpen.Core.AxoObject
        //<ProberDeclarations>
        VAR PUBLIC
            _counterProber : CounterProberExample;
            _conditionProber : ConditionProberExample;
            _testValue : LREAL := 0.0;
            _targetValue : LREAL := 100.0;
        END_VAR
        //</ProberDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<ProberUsage>
            // Counter-based prober: runs Test() for a fixed number of cycles.
            _counterProber.Run(inParent);

            // Condition-based prober: runs Test() until condition returns TRUE.
            _conditionProber.Run(inParent);
            //</ProberUsage>
        END_METHOD
    END_CLASS

    // Example: Prober that runs a test for a specified number of cycles.
    //<CounterProberExample>
    {S7.extern=ReadWrite}
    CLASS PUBLIC CounterProberExample EXTENDS AXOpen.Probers.AxoProberWithCounterBase
        VAR PUBLIC
            _cycleCounter : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE Test
            // Increment counter each cycle — represents a cyclic test action
            _cycleCounter := _cycleCounter + ULINT#1;
        END_METHOD
    END_CLASS
    //</CounterProberExample>

    // Example: Prober that runs until a condition is met.
    //<ConditionProberExample>
    {S7.extern=ReadWrite}
    CLASS PUBLIC ConditionProberExample EXTENDS AXOpen.Probers.AxoProberWithCompletedCondition
        VAR PUBLIC
            _accumulatedValue : LREAL;
            _threshold : LREAL := 50.0;
        END_VAR

        METHOD PROTECTED OVERRIDE Test : BOOL
            // Accumulate a value each cycle; return TRUE when threshold reached
            _accumulatedValue := _accumulatedValue + 0.5;
            Test := _accumulatedValue >= _threshold;
        END_METHOD
    END_CLASS
    //</ConditionProberExample>

END_NAMESPACE
