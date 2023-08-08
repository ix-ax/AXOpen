USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// AxoInspector base class with implemented evaluation methods
    /// Evaluation methods need IAxoCoordinator instance
    ///</summary>
    CLASS AxoInspectorDialog EXTENDS AXOpen.Core.AxoDialogBase

        VAR PUBLIC
            _isOverInspected : BOOL;
            _dialogueRetry : BOOL;	
            _dialogueTerminate : BOOL;	
            _dialogueOverride : BOOL;
        END_VAR

        VAR PRIVATE
            _lastCall : ULINT;
        END_VAR    

        VAR
            
            _isActive : BOOL;
            _dialogIsClosed : BOOL;
            _isAnswerProvided : BOOL;
            //_refInspector : REF_TO AxoInspector;
            
        END_VAR

     

        METHOD PUBLIC Show
            VAR_INPUT
                _refInspector : REF_TO AxoInspector;
                inRetryStep : IAxoStep;
            END_VAR
            VAR
                callCounter : ULINT;
            END_VAR   
              
           //Restores when not called for 2+ consecutive cycles of the context.
           callCounter := THIS.GetParent().GetContext().OpenCycleCount();
           IF(callCounter > _lastCall + ULINT#1) THEN
               THIS.Restore();
           END_IF;                
           _lastCall := callCounter;

         
            IF(_refInspector = NULL) THEN
                RETURN;
            END_IF;

            THIS.Initialize(_refInspector^);

            // IF (THIS.Status = eAxoTaskState#Ready) THEN
            //     _isAnswerProvided := FALSE;
            // END_IF;
            _isOverInspected := _refInspector^.CheckOverInspection();


            IF(_refInspector^.Done()) THEN	

                IF(_refInspector^.Result() = eInspectorResult#Failed) THEN

                    THIS.Invoke();
                    SUPER.Execute();

    
                    IF(_dialogueRetry) THEN
                        _refInspector^.Retry(inRetryStep);
                        _isAnswerProvided := TRUE;
                        
                    END_IF;
                    
                    IF(_dialogueTerminate) THEN
                        _refInspector^.Terminate();
                        _isAnswerProvided := TRUE;
                       
                    END_IF;
                    
                    IF(_dialogueOverride) THEN
                        _refInspector^.CarryOn();
                        _isAnswerProvided := TRUE;
                       
                    END_IF;

                    // //after task is done and some answer is provided, restore this task
                    // IF (THIS.Status = eAxoTaskState#Done && _isAnswerProvided) THEN
                    //     _isAnswerProvided := FALSE;
                    //     THIS.Restore();   
                            
                    // END_IF;
            
                ELSE

                    IF(_refInspector^.Coordinator() <> NULL) THEN
                        _refInspector^.Coordinator().MoveNext();
                    END_IF;	

                END_IF;	

                // //restore this task, when answer is provided and task is done
                IF _isAnswerProvided THEN
                    THIS.Restore();  
                    _isAnswerProvided := FALSE;
                END_IF;
   
                
                    
 
            END_IF;	
        END_METHOD


        METHOD Restore 

            SUPER.Restore();
            _dialogueRetry := FALSE;	
            _dialogueTerminate := FALSE;	
            _dialogueOverride := FALSE;
            _dialogIsClosed := FALSE;

        END_METHOD

      

END_CLASS





END_NAMESPACE