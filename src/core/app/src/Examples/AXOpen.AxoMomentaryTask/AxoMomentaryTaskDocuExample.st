USING AXOpen.Core;

NAMESPACE AxoMomentaryTaskExamples
    {S7.extern=ReadWrite}
    CLASS AxoMomentaryTaskDocuExample EXTENDS  AXOpen.Core.AxoContext         
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Momentary task example#>"}
            {#ix-set:AttributeStateOnDesc = "<#Currently On#>"}
            {#ix-set:AttributeStateOffDesc = "<#Currently Off#>"}
            _myMomentaryTask : AxoMomentaryTask;
        END_VAR

        METHOD PUBLIC Initialize
            // Initialization of the context needs to be called first
            // It does not need to be called cyclically, just once
            _myMomentaryTask.Initialize(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
            // Cyclicall call of the Run method
            _myMomentaryTask.Initialize(THIS);
            _myMomentaryTask.Run();
        END_METHOD

        METHOD Examples

        //<AxoMomentaryTaskIsSwitchedOn>
        IF _myMomentaryTask.IsSwitchedOn() THEN
            ; // do something 
        END_IF;
        //</AxoMomentaryTaskIsSwitchedOn>

        //<AxoMomentaryTaskIsSwitchedOff>
        IF _myMomentaryTask.IsSwitchedOff() THEN
            ; // do something 
        END_IF;
        //</AxoMomentaryTaskIsSwitchedOff>
        END_METHOD
    END_CLASS  

    //<AxoMomentaryTaskEventLikeMethods>
    {S7.extern=ReadWrite}
    CLASS MyMomentaryTaskExample Extends AxoMomentaryTask
        VAR
            OnSwitchedOnCounter : ULINT;
            OnSwitchedOffCounter : ULINT;
            OnStateChangedCounter : ULINT;
            SwitchOnExecutionCounter : ULINT;
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
    //</AxoMomentaryTaskEventLikeMethods>
END_NAMESPACE
