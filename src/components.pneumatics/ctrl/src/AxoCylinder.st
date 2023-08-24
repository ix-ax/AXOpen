USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;


NAMESPACE AXOpen.Components.Pneumatics
    CLASS AxoCylinder EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Move to work#>"}
            _MoveToWorkTask : AxoTask;            
            {#ix-attr:[ComponentHeader()]}            
            {#ix-set:AttributeName = "<#Move to home#>"}
            _MoveToHomeTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop#>"}
            _StopTask : AxoTask;

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

            {#ix-set:MessageText = "<#Movement to work position is temporarily suspended.#>"}
            {#ix-set:Help = "<#Check the blocking condition.#>"}
            _MoveToWorkSuspended : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Movement to home position is temporarily suspended.#>"}
            {#ix-set:Help = "<#Check the blocking condition.#>"}
            _MoveToHomeSuspended : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Movement to work position is aborted.#>"}
            {#ix-set:Help = "<#Check the blocking condition.#>"}
            _MoveToWorkAborted : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Movement to home position is aborted.#>"}
            {#ix-set:Help = "<#Check the blocking condition.#>"}
            _MoveToHomeAborted : AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        VAR PRIVATE
            _MoveToWorkIsSuspended : BOOL;
            _MoveToHomeIsSuspended : BOOL;
        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                homeSensor : BOOL;
                workSensor : BOOL;    
            END_VAR
            VAR_OUTPUT
                moveHomeSignal : BOOL;
                moveWorkSignal : BOOL;
            END_VAR
            IF (parent = NULL) THEN RETURN; END_IF;
            THIS.Initialize(parent);    
            THIS.Run(parent.GetContext(), homeSensor, workSensor, moveHomeSignal, moveWorkSignal);           
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                context : IAxoContext;
                homeSensor : BOOL;
                workSensor : BOOL;    
            END_VAR
            VAR_OUTPUT
                moveHomeSignal : BOOL;
                moveWorkSignal : BOOL;
            END_VAR

            THIS.Initialize(context);
            _MoveToWorkTask.Initialize(THIS);
            _MoveToHomeTask.Initialize(THIS);
            _StopTask.Initialize(THIS);

            THIS.Open();

            _MoveToWorkNotReached.Serve(THIS);
            _MoveToHomeNotReached.Serve(THIS);
            _MoveToWorkSuspended.Serve(THIS);
            _MoveToHomeSuspended.Serve(THIS);
            _MoveToWorkAborted.Serve(THIS);
            _MoveToHomeAborted.Serve(THIS);

            IF(_StopTask.Execute()) THEN
                moveHomeSignal := FALSE;
                moveWorkSignal := FALSE;
                _MoveToHomeTask.Restore();
                _MoveToWorkTask.Restore();                
                _StopTask.DoneWhen(TRUE);
            END_IF;    

            IF(_MoveToWorkTask.Execute()) THEN                
                moveHomeSignal := FALSE;
                moveWorkSignal := TRUE;                
                _MoveToWorkTask.DoneWhen(workSensor);
                _MoveToHomeTask.Restore();
        
                _MoveToWorkNotReached.ActivateOnCondition(_MoveToWorkTask.Duration >= T#10S, eAxoMessageCategory#Error);            
            END_IF;        

            IF(_MoveToHomeTask.Execute()) THEN                
                moveHomeSignal := TRUE;
                moveWorkSignal := FALSE;
                _MoveToHomeTask.DoneWhen(homeSensor);
                _MoveToWorkTask.Restore();
                _MoveToHomeNotReached.ActivateOnCondition(_MoveToHomeTask.Duration >= T#10S, eAxoMessageCategory#Error); 
            END_IF; 
            
            IF _MoveToWorkIsSuspended THEN
                moveWorkSignal := FALSE;
            END_IF;
            
            IF _MoveToHomeIsSuspended THEN
                moveHomeSignal := FALSE;
            END_IF;

            _HomeSensor := homeSensor;
            _WorkSensor := workSensor; 

            _MoveHomeSignal := moveHomeSignal;
            _MoveWorkSignal := moveWorkSignal;      

            THIS.Close();                      
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PROTECTED OVERRIDE Restore : IAxoTask
            _MoveToWorkTask.Restore();
            _MoveToHomeTask.Restore();
            _StopTask.Restore();
        END_METHOD        

        ///<summary>
		/// Invokes the movement to the work position and returns the task state. 	
        ///</summary>       
        METHOD PUBLIC MoveToWork : IAxoTaskState
            MoveToWork := _MoveToWorkTask.Invoke();
        END_METHOD

        ///<summary>
		/// Invokes the movement to the home position and returns the task state. 	
        ///</summary>       
        METHOD PUBLIC MoveToHome : IAxoTaskState
            MoveToHome := _MoveToHomeTask.Invoke();
        END_METHOD

        ///<summary>
		/// Stops any movement. 	
        ///</summary>       
        METHOD PUBLIC Stop : IAxoTaskState
            Stop := _StopTask.Invoke();
        END_METHOD

        ///<summary>
        /// Suspends the movement to the work position while the condition is 'true'. Task remains still executing.
        ///</summary>
        METHOD PUBLIC SuspendMoveToWorkWhile 
            VAR_INPUT
                Condition : BOOL;
            END_VAR

            IF(Condition) THEN                        
                _moveWorkSignal := FALSE;   
                _MoveToWorkSuspended.Activate(eAxoMessageCategory#Info);
            END_IF;    
            _MoveToWorkIsSuspended := Condition;
        END_METHOD        

        ///<summary>
        /// Suspends the movement to the home position while the condition is 'true'. Task remains still executing.
        ///</summary>
        METHOD PUBLIC SuspendMoveToHomeWhile 
            VAR_INPUT
                Condition : BOOL;
            END_VAR

            IF(Condition) THEN                        
                _moveHomeSignal := FALSE;   
                _MoveToHomeSuspended.Activate(eAxoMessageCategory#Info);
            END_IF;    
            _MoveToHomeIsSuspended := Condition;
        END_METHOD    
        
        ///<summary>
        /// Aborts the movement to the work position when the condition is 'true' and restores the respective task.
        ///</summary>
        METHOD PUBLIC AbortMoveToWorkWhen 
            VAR_INPUT
                Condition : BOOL;
            END_VAR

            IF(Condition) THEN                        
                _moveWorkSignal := FALSE;   
                _MoveToWorkAborted.Activate(eAxoMessageCategory#Info);
            END_IF;    
                _MoveToWorkTask.IsDisabled := Condition;
        END_METHOD        

        ///<summary>
        /// Aborts the movement to the home position when the condition is 'true' and restores the respective task.
        ///</summary>
        METHOD PUBLIC AbortMoveToHomeWhen 
            VAR_INPUT
                Condition : BOOL;
            END_VAR

            IF(Condition) THEN                        
                _moveHomeSignal := FALSE;   
                _MoveToHomeAborted.Activate(eAxoMessageCategory#Info);
            END_IF;    
            _MoveToHomeTask.IsDisabled := Condition;
        END_METHOD        
    END_CLASS
END_NAMESPACE