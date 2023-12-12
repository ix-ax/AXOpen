USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;


NAMESPACE AXOpen.Pneumatics
    {S7.extern=ReadWrite}
    CLASS Cylinder EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            MoveToWork : AxoTask;
            {#ix-attr:[ComponentHeader()]}            
            Stop : AxoTask;
            {#ix-attr:[ComponentHeader()]}            
            MoveToHome : AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Home sensor#>"}
            _HomeSensor : BOOL;
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Work sensor#>"}
            _WorkSensor : BOOL;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move home signal#>"}
            _MoveHomeSignal : BOOL;
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move work signal#>"}
            _MoveWorkSignal : BOOL;

            {#ix-set:MessageText = "<#Move to work position did not succeed.#>"}
            {#ix-set:Help = "<#Check the cyclinder that it is free to move, check that the air pressure reaches... and extremity sensor.#>"}
            _MoveToWorkNotReached : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Move to home position did not succeed.#>"}
            {#ix-set:Help = "<#Check the cyclinder that it is free to move, check that the air pressure reaches... and extremity sensor.#>"}
            _MoveToHomeNotReached : AXOpen.Messaging.Static.AxoMessenger;            
        END_VAR
               
        METHOD PUBLIC Update 
            VAR_INPUT
                parent : IAxoObject;
                homeSensor : BOOL;
                workSensor : BOOL;    
            END_VAR
            VAR_OUTPUT
                moveHomeSignal : BOOL;
                moveWorkSignal : BOOL;
            END_VAR

            THIS._isManuallyControllable := FALSE;
            
            THIS.Initialize(parent);
            MoveToWork.Initialize(THIS);
            MoveToHome.Initialize(THIS);
            Stop.Initialize(THIS);

            _MoveToWorkNotReached.Serve(THIS);
            _MoveToHomeNotReached.Serve(THIS);

            IF(Stop.Execute()) THEN
                moveHomeSignal := FALSE;
                moveWorkSignal := FALSE;
                MoveToHome.Restore();
                MoveToWork.Restore();                
                Stop.DoneWhen(TRUE);
                Stop.Restore();
            END_IF;    

            IF(MoveToWork.Execute()) THEN                
                moveHomeSignal := FALSE;
                moveWorkSignal := TRUE;                
                MoveToWork.DoneWhen(workSensor);
                MoveToHome.Restore();
        
                _MoveToWorkNotReached.ActivateOnCondition(MoveToWork.Duration >= T#10S, eAxoMessageCategory#Error);            
            END_IF;        

            IF(MoveToHome.Execute()) THEN                
                moveHomeSignal := TRUE;
                moveWorkSignal := FALSE;
                MoveToHome.DoneWhen(homeSensor);
                MoveToWork.Restore();
                _MoveToHomeNotReached.ActivateOnCondition(MoveToHome.Duration >= T#10S, eAxoMessageCategory#Error); 
            END_IF; 
            
            _HomeSensor := homeSensor;
            _WorkSensor := workSensor; 

            _MoveHomeSignal := moveHomeSignal;
            _MoveWorkSignal := moveWorkSignal;            
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD

        
        METHOD PUBLIC OVERRIDE Restore 
            MoveToWork.Restore();
            MoveToWork.Restore();
            Stop.Restore();
        END_METHOD
        
    END_CLASS
END_NAMESPACE
