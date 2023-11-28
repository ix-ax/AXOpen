USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// AxoInspector base class with implemented evaluation methods
    /// Evaluation methods need IAxoCoordinator instance
    ///</summary>
    {S7.extern=ReadWrite}
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
            
        END_VAR

     
        ///<summary>
        /// Method for showing inspector dialog and handling interaction
        ///</summary>
        METHOD PUBLIC Show
            VAR_INPUT
                _parentInspectorRef : REF_TO AxoInspector;
                inRetryStep : IAxoStep;
                inTerminateStep : IAxoStep;
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

         
            IF(_parentInspectorRef = NULL) THEN
                RETURN;
            END_IF;

            
            _isOverInspected := _parentInspectorRef^.CheckOverInspection();


            IF(_parentInspectorRef^.Done()) THEN	

                IF(_parentInspectorRef^.Result() = eInspectorResult#Failed) THEN
                    THIS.Initialize(_parentInspectorRef^);
                    THIS.Invoke();
                    SUPER.Execute();

    
                    IF(_dialogueRetry) THEN
                        _parentInspectorRef^.RetryWithStep(inRetryStep);
                        _isAnswerProvided := TRUE;
                        
                    END_IF;
                    
                    IF(_dialogueTerminate) THEN
                        _parentInspectorRef^.TerminateWithStep(inTerminateStep);
                        _isAnswerProvided := TRUE;
                       
                    END_IF;
                    
                    IF(_dialogueOverride) THEN
                        _parentInspectorRef^.CarryOn();
                        _isAnswerProvided := TRUE;
                       
                    END_IF;

            
                ELSE

                    IF(_parentInspectorRef^.Coordinator() <> NULL) THEN
                        _parentInspectorRef^.Coordinator().MoveNext();
                    END_IF;	

                END_IF;	

                // restore this task, when answer is provided and task is done
                IF _isAnswerProvided THEN
                    THIS.Restore();  
                    _parentInspectorRef^.RestoreInspectorTask();
                    _isAnswerProvided := FALSE;
                END_IF;
   

            END_IF;	
        END_METHOD

        ///<summary>
        /// Restores dialogue
        ///</summary>
        METHOD PUBLIC Restore 

            SUPER.Restore();
            _dialogueRetry := FALSE;	
            _dialogueTerminate := FALSE;	
            _dialogueOverride := FALSE;
            _dialogIsClosed := FALSE;

        END_METHOD

      

    END_CLASS





END_NAMESPACE
