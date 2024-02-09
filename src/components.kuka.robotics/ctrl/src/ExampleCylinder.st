USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;


NAMESPACE AXOpen.Components.Kuka.Robotics.Example
    {S7.extern=ReadWrite}
    CLASS ExampleCylinder EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            MoveToWork : AxoTask;            
            {#ix-attr:[ComponentHeader()]}            
            MoveToHome : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            Stop : AxoTask;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Home sensor#>"}
            _HomeSensor : BOOL;
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Work sensor#>"}
            _WorkSensor : BOOL;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move home signal#>"}
            _MoveHomeSignal : BOOL;
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move work signal#>"}
            _MoveWorkSignal : BOOL;

            {#ix-set:MessageText = "<#Movement to work position did not succeed.#>"}
            {#ix-set:Help = "<#Check the cyclinder that it is free to move, air pressure input and extremity sensor.#>"}
            _MoveToWorkNotReached : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Movement to home position did not succeed.#>"}
            {#ix-set:Help = "<#Check the cyclinder that it is free to move, air pressure input and extremity sensor.#>"}
            _MoveToHomeNotReached : AXOpen.Messaging.Static.AxoMessenger;            
        END_VAR
               
        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                homeSensor : REF_TO BOOL;
                workSensor : REF_TO BOOL;    
                 moveHomeSignal : REF_TO BOOL;
                moveWorkSignal : REF_TO BOOL;
            END_VAR
            IF (parent = NULL) THEN RETURN; END_IF;
            THIS.Initialize(parent);    
            THIS.Run(parent.GetContext(), homeSensor, workSensor, moveHomeSignal, moveWorkSignal);           
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                context : IAxoContext;
                homeSensor : REF_TO BOOL;
                workSensor : REF_TO BOOL;    
                moveHomeSignal : REF_TO BOOL;
                moveWorkSignal : REF_TO BOOL;
            END_VAR

            THIS.Open();
            
            THIS.Initialize(context);
            MoveToWork.Initialize(THIS);
            MoveToHome.Initialize(THIS);
            Stop.Initialize(THIS);

            _MoveToWorkNotReached.Serve(THIS);
            _MoveToHomeNotReached.Serve(THIS);

            IF(Stop.Execute()) THEN
                moveHomeSignal^ := FALSE;
                moveWorkSignal^ := FALSE;
                MoveToHome.Restore();
                MoveToWork.Restore();                
                Stop.DoneWhen(TRUE);
                Stop.Restore();
            END_IF;    

            IF(MoveToWork.Execute()) THEN                
                moveHomeSignal^ := FALSE;
                moveWorkSignal^ := TRUE;                
                MoveToWork.DoneWhen(workSensor^);
                MoveToHome.Restore();
        
                _MoveToWorkNotReached.ActivateOnCondition(MoveToWork.Duration >= T#10S, eAxoMessageCategory#Error);            
            END_IF;        

            IF(MoveToHome.Execute()) THEN                
                moveHomeSignal^ := TRUE;
                moveWorkSignal^ := FALSE;
                MoveToHome.DoneWhen(homeSensor^);
                MoveToWork.Restore();
                _MoveToHomeNotReached.ActivateOnCondition(MoveToHome.Duration >= T#10S, eAxoMessageCategory#Error); 
            END_IF; 
            
            _HomeSensor := homeSensor^;
            _WorkSensor := workSensor^; 

            _MoveHomeSignal := moveHomeSignal^;
            _MoveWorkSignal := moveWorkSignal^;      

            THIS.Close();                      
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            MoveToWork.Restore();
            MoveToWork.Restore();
            Stop.Restore();
        END_METHOD        
    END_CLASS
END_NAMESPACE
