USING AXOpen.Core;

NAMESPACE AxoToggleTaskExamples
    CLASS AxoToggleTaskDocuExample EXTENDS  AXOpen.Core.AxoContext         
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Toggle task example#>"}
            {#ix-set:AttributeStateOnDesc = "<#SwitchedOn#>"}
            {#ix-set:AttributeStateOffDesc = "<#SwitchedOff#>"}
            _myToggleTask : AxoToggleTask;
            _myCounter : ULINT;
        END_VAR

        METHOD PUBLIC Initialize
            // Initialization of the context needs to be called first
            // It does not need to be called cyclically, just once
            _myToggleTask.Initialize(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
            // Cyclicall call of the Run method
            _myToggleTask.Initialize(THIS);
            _myToggleTask.Run();
        END_METHOD

        METHOD Examples
        //<AxoToggleTaskSwitchOn>
        IF _myToggleTask.SwitchOn() THEN
            ; // do something on rising edge
        END_IF;
        //</AxoToggleTaskSwitchOn>

        //<AxoToggleTaskSwitchOff>
        IF _myToggleTask.SwitchOff()THEN
            ; // do something on falling edge
        END_IF;
        //</AxoToggleTaskSwitchOff>

        //<AxoToggleTaskToggle>
        IF _myToggleTask.Toggle()THEN
            ; // do something on state change
        END_IF;
        //</AxoToggleTaskToggle>

        //<AxoToggleTaskIsSwitchedOn>
        IF _myToggleTask.IsSwitchedOn() THEN
            ; // do something 
        END_IF;
        //</AxoToggleTaskIsSwitchedOn>

        //<AxoToggleTaskIsSwitchedOff>
        IF _myToggleTask.IsSwitchedOff() THEN
            ; // do something 
        END_IF;
        //</AxoToggleTaskIsSwitchedOff>
        END_METHOD
    END_CLASS  

    //<AxoToggleTaskEventLikeMethods>
    CLASS MyToogleTaskExample Extends AxoToggleTask
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
    //</AxoToggleTaskEventLikeMethods>
END_NAMESPACE