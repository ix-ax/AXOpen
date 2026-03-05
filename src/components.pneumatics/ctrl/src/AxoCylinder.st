USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;


NAMESPACE AXOpen.Components.Pneumatics
    //<summary>
    /// Represents a pneumatic cylinder with two positions: in and out. It provides tasks to move the cylinder in and out, as well as to stop its movement.
    /// The component also includes sensors to detect the cylinder's position and signals to control its movement
    /// </summary>
    {S7.extern=ReadWrite}
    {#ix-prop:public string InLabel}
    {#ix-prop:public string OutLabel}
    {#ix-set:InLabel = "<#In#>"}
    {#ix-set:OutLabel = "<#Out#>"}
    CLASS AxoCylinder EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Move in#>"}
            _MoveInTask : AxoTask; 

            {#ix-attr:[ComponentHeader()]}            
            {#ix-set:AttributeName = "<#Move out#>"}
            _MoveOutTask : AxoTask;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#In sensor#>"}
            InSensor : BOOL;

            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Out sensor#>"}
            OutSensor : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move in signal#>"}
            MoveInSignal : BOOL;

            {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move out signal#>"}
            MoveOutSignal : BOOL;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop#>"}
            _StopTask : AxoTask;           
            _Messenger : AXOpen.Messaging.Static.AxoMessenger;
        END_VAR
        
        VAR PRIVATE            
            _InSensor : BOOL;            
            _OutSensor : BOOL;            
            _MoveInSignal : BOOL;            
            _MoveOutSignal : BOOL;
        END_VAR    
        VAR PRIVATE
            _MoveToOutIsSuspended : BOOL;
            _MoveToInIsSuspended : BOOL;

            _MoveToOutIsBusy : BOOL;
            _MoveToInIsBusy : BOOL;

            _context : IAxoContext;
        END_VAR


        ///<summary>
        /// Returns 'true' if the movement to the extended position is currently suspended.
        ///</summary>
        METHOD PUBLIC IsMoveToOutSuspended : BOOL
            IsMoveToOutSuspended := _MoveToOutIsSuspended;
        END_METHOD

        ///<summary>
        /// Returns 'true' if the movement to the retracted position is currently suspended.
        /// </summary>
        METHOD PUBLIC IsMoveToInSuspended : BOOL
            IsMoveToInSuspended := _MoveToInIsSuspended;
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                inParent : IAxoObject;
                inInSensor : BOOL;
                inOutSensor : BOOL;    
            END_VAR
            VAR_OUTPUT
                outMoveInSignal : BOOL;
                outMoveOutSignal : BOOL;
            END_VAR

            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;
            
            IF _context = NULL THEN
                SUPER.Run(inParent);
                _context := THIS.GetContext();
            END_IF;

            SUPER.Run(inParent);
          
            _InSensor := inInSensor;
            _OutSensor := inOutSensor;


            _Messenger.Serve(THIS);

            _Messenger.ActivateOnCondition(UINT#3, _OutSensor AND _InSensor, eAxoMessageCategory#Error);

            IF(_StopTask.Execute(THIS)) THEN
                _MoveInSignal := FALSE;
                _MoveOutSignal := FALSE;
                _MoveInTask.Restore();
                _MoveOutTask.Restore();                
                _StopTask.DoneWhen(TRUE);
            END_IF;    

            IF(_MoveOutTask.Execute(THIS)) THEN  
                IF(_MoveOutTask.IsFirstExecutionCycle()) THEN
                    _MoveInTask.Restore(); 
                END_IF;                 
                _MoveInSignal := FALSE;
                _MoveOutSignal := TRUE;                
                _MoveOutTask.DoneWhen(_OutSensor);                               
            END_IF;        

            _MoveToOutIsBusy := _MoveOutTask.IsBusy();

           _Messenger.ActivateOnCondition(UINT#1, (_MoveToOutIsBusy AND NOT _MoveToOutIsSuspended AND _MoveOutTask.Duration >= T#10S), eAxoMessageCategory#Error);   
           _Messenger.ActivateOnCondition(UINT#9, (_MoveOutTask.IsDone() AND NOT _OutSensor), eAxoMessageCategory#Warning); 
            

            IF(_MoveInTask.Execute(THIS)) THEN    
                IF(_MoveInTask.IsFirstExecutionCycle()) THEN
                    _MoveOutTask.Restore();
                END_IF;
                _MoveInSignal := TRUE;
                _MoveOutSignal := FALSE;
                _MoveInTask.DoneWhen(_InSensor);                           
            END_IF; 

            _MoveToInIsBusy := _MoveInTask.IsBusy();

            _Messenger.ActivateOnCondition(UINT#2, (_MoveToInIsBusy AND NOT _MoveToInIsSuspended AND _MoveInTask.Duration >= T#10S), eAxoMessageCategory#Error);
            _Messenger.ActivateOnCondition(UINT#8, (_MoveInTask.IsDone() AND NOT _InSensor), eAxoMessageCategory#Warning);


            outMoveInSignal := _MoveInSignal AND NOT _MoveToInIsSuspended;
            outMoveOutSignal := _MoveOutSignal AND NOT _MoveToOutIsSuspended;

            _MoveToInIsSuspended := FALSE;
            _MoveToOutIsSuspended := FALSE;

            InSensor := inInSensor;
            OutSensor := inOutSensor;
            MoveInSignal := outMoveInSignal;
            MoveOutSignal := outMoveOutSignal;
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore 
            _MoveOutTask.Restore();
            _MoveInTask.Restore();
            _StopTask.Restore();
        END_METHOD        

        ///<summary>
		/// Invokes the movement to the extended position and returns the task state. 	
        ///</summary>       
        METHOD PUBLIC MoveOut : IAxoTaskState
            MoveOut := _MoveOutTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Invokes the movement to the retracted position and returns the task state. 	
        ///</summary>       
        METHOD PUBLIC MoveIn : IAxoTaskState
            MoveIn := _MoveInTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Stops any movement. 	
        ///</summary>       
        METHOD PUBLIC Stop : IAxoTaskState
            Stop := _StopTask.Invoke(THIS);
        END_METHOD
     
        ///<summary>
        /// Suspends the movement to the extended position while the condition is 'true'. Task remains still executing.
        ///</summary>
        METHOD PUBLIC SuspendMoveToOutWhile 
            VAR_INPUT
                inCondition : BOOL;
                inMessage : STRING := ''; 
                inLevel :  eAxoMessageCategory := eAxoMessageCategory#Info;
            END_VAR
            VAR
                _suspendCondition : BOOL;
                _messageCondition : BOOL;
            END_VAR

            _suspendCondition := NOT _OutSensor && inCondition;
            _messageCondition := _suspendCondition && _MoveOutTask.IsEngaged();

            IF(_messageCondition) THEN
                IF inMessage = '' THEN
                    _Messenger.Activate(UINT#4, eAxoMessageCategory#Info);
                ELSE             
                    _Messenger.Post(THIS, inMessage, inLevel);             
                END_IF;
            END_IF;  
              
            IF(_suspendCondition) THEN
                _MoveOutSignal := FALSE;  
                _MoveToOutIsSuspended := TRUE;
            END_IF;
        END_METHOD        

        ///<summary>
        /// Suspends the movement to the retracted position while the condition is 'true'. Task remains still executing.
        ///</summary>
        METHOD PUBLIC SuspendMoveToInWhile 
            VAR_INPUT
                inCondition : BOOL;
                inMessage : STRING := '';
                inLevel :  eAxoMessageCategory := eAxoMessageCategory#Info;
            END_VAR
            VAR
                _suspendCondition : BOOL;
                _messageCondition : BOOL;
            END_VAR

            _suspendCondition := NOT _InSensor && inCondition;
            _messageCondition := _suspendCondition && _MoveInTask.IsEngaged();

            IF(_messageCondition) THEN
                IF inMessage = '' THEN
                    _Messenger.Activate(UINT#5, eAxoMessageCategory#Info);
                ELSE             
                    _Messenger.Post(THIS, inMessage, inLevel);             
                END_IF;
            END_IF;  
              
            IF(_suspendCondition) THEN
                _MoveInSignal := FALSE;  
                _MoveToInIsSuspended := TRUE;
            END_IF;
        END_METHOD   

        ///<summary>
        /// Aborts the movement to the extended position when the condition is 'true' and restores the respective task.
        ///</summary>
        METHOD PUBLIC AbortMoveToWorkWhen 
            VAR_INPUT
                Condition : BOOL;
            END_VAR

            IF(Condition) THEN                        
                _MoveOutSignal := FALSE;   
                _MoveOutTask.Abort();
                _Messenger.Activate(UINT#6, eAxoMessageCategory#Info);
            END_IF;    
            _MoveOutTask.SetIsDisabled(Condition);
        END_METHOD        

        ///<summary>
        /// Aborts the movement to the retracted position when the condition is 'true' and restores the respective task.
        ///</summary>
        METHOD PUBLIC AbortMoveToHomeWhen 
            VAR_INPUT
                Condition : BOOL;
            END_VAR

            IF(Condition) THEN                        
                _MoveInSignal := FALSE;   
                _Messenger.Activate(UINT#7, eAxoMessageCategory#Info);
                _MoveInTask.Abort();
            END_IF;    
            _MoveInTask.SetIsDisabled(Condition);
        END_METHOD  
    END_CLASS
END_NAMESPACE
