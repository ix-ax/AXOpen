USING AXOpen.Core;

NAMESPACE AxoMomentaryTaskExamples

    CLASS PUBLIC AxoMomentaryTaskExample EXTENDS AXOpen.Core.AxoMomentaryTask
        VAR PUBLIC
            {#ix-set:AttributeName = "Disabled"}
            Disabled : BOOL;
            {#ix-set:AttributeName = "OnSwitchedOn counter"}
            OnSwitchedOnCounter : ULINT;
            {#ix-set:AttributeName = "OnSwitchedOff counter"}
            OnSwitchedOffCounter : ULINT;
            {#ix-set:AttributeName = "OnStateChanged counter"}
            OnStateChangedCounter : ULINT;
            {#ix-set:AttributeName = "While SwitchedOn counter"}
            SwitchOnExecutionCounter : ULINT;
            {#ix-set:AttributeName = "While SwitchedOff counter"}
            SwitchOffExecutionCounter : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE OnSwitchedOn 
            OnSwitchedOnCounter := OnSwitchedOnCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnSwitchedOff 
            OnSwitchedOffCounter := OnSwitchedOffCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnStateChanged 
            OnStateChangedCounter := OnStateChangedCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE SwitchedOn 
            SwitchOnExecutionCounter := SwitchOnExecutionCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE SwitchedOff 
            SwitchOffExecutionCounter := SwitchOffExecutionCounter + ULINT#1;
        END_METHOD
    END_CLASS

    CLASS Tasks EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Momentary task example"}
            MomentaryTaskExample :AxoMomentaryTaskExample;
       END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            MomentaryTaskExample.Initialize(THIS);    
            MomentaryTaskExample.SetIsDisabled(MomentaryTaskExample.Disabled);
            MomentaryTaskExample.Run();
        
        END_METHOD
    END_CLASS    
END_NAMESPACE
