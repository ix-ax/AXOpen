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
            _Messenger : AXOpen.Messaging.Static.AxoMessenger;
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

            _Messenger.Serve(THIS);

            _Messenger.ActivateOnCondition(UINT#3, workSensor AND homeSensor, eAxoMessageCategory#Error);

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
                _Messenger.ActivateOnCondition(UINT#1, NOT _MoveToWorkIsSuspended AND _MoveToWorkTask.Duration >= T#10S, eAxoMessageCategory#Info);
            END_IF;        

            IF(_MoveToHomeTask.Execute()) THEN                
                moveHomeSignal := TRUE;
                moveWorkSignal := FALSE;
                _MoveToHomeTask.DoneWhen(homeSensor);
                _MoveToWorkTask.Restore();
                _Messenger.ActivateOnCondition(UINT#2, NOT _MoveToHomeIsSuspended AND _MoveToHomeTask.Duration >= T#10S, eAxoMessageCategory#Info);
            END_IF; 

            IF _MoveToWorkIsSuspended THEN
                moveWorkSignal := FALSE;
            END_IF;

            _Messenger.ActivateOnCondition(UINT#4, _MoveToWorkIsSuspended AND _MoveToWorkTask.IsBusy(), eAxoMessageCategory#Info);

            
            IF _MoveToHomeIsSuspended THEN
                moveHomeSignal := FALSE;
            END_IF;

            _Messenger.ActivateOnCondition(UINT#5, _MoveToHomeIsSuspended AND _MoveToHomeTask.IsBusy(), eAxoMessageCategory#Info);

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
            END_IF;   
            _Messenger.ActivateOnCondition(UINT#4, Condition AND _MoveToWorkTask.IsBusy(), eAxoMessageCategory#Info);
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
            END_IF;    
            _Messenger.ActivateOnCondition(UINT#5, Condition AND _MoveToHomeTask.IsBusy(), eAxoMessageCategory#Info);
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
            END_IF;    
            _Messenger.ActivateOnCondition(UINT#6, Condition, eAxoMessageCategory#Info);
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
            END_IF;    
            _Messenger.ActivateOnCondition(UINT#7, Condition, eAxoMessageCategory#Info);
            _MoveToHomeTask.IsDisabled := Condition;
        END_METHOD        
    END_CLASS
END_NAMESPACE