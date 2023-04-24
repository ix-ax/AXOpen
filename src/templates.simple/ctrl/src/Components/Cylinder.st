USING AXOpen.Core;

NAMESPACE AXOpen.Pneumatics
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
            END_IF;        

            IF(MoveToHome.Execute()) THEN                
                moveHomeSignal := TRUE;
                moveWorkSignal := FALSE;
                MoveToHome.DoneWhen(homeSensor);
                MoveToWork.Restore();
            END_IF; 
            
            _HomeSensor := homeSensor;
            _WorkSensor := workSensor; 

            _MoveHomeSignal := moveHomeSignal;
            _MoveWorkSignal := moveWorkSignal;            
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD

        
        METHOD PROTECTED OVERRIDE Restore : IAxoTask
            MoveToWork.Restore();
            MoveToWork.Restore();
            Stop.Restore();
        END_METHOD
        
    END_CLASS
END_NAMESPACE