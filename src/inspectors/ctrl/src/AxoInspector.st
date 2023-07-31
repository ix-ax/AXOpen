USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// AxoInspector base class with implemented evaluation methods
    /// Evaluation methods need IAxoCoordinator instance
    ///</summary>
    CLASS AxoInspector EXTENDS AXOpen.Core.AxoObject IMPLEMENTS IInspector, IOnFail

        
     
        VAR
            _inspectorTask: AxoInspectorTask;
            _coordinator: IAxoCoordinator;
            _isOverInspected: BOOL;
            _busy : BOOL;
            _commonData: REF_TO AxoInspectorData;
            //tier?
            _originalOverallResult : IAxoComprehensiveResult;
            //_refOverallResult: REF_TO AxoComprehensiveResult; //within group inspectors

   
        END_VAR


        /// GETTERS START
      
    
    

    
        METHOD PUBLIC Busy : BOOL
            Busy := _inspectorTask.IsBusy();
        END_METHOD
    
        METHOD PUBLIC CommonData : REF_TO AXOpen.Inspectors.AxoInspectorData
            ;
        END_METHOD
    
        METHOD PUBLIC Coordinator : IAxoCoordinator
            Coordinator := _coordinator;
        END_METHOD
    
        METHOD PUBLIC Done : BOOL
            Done := _inspectorTask.IsDone();
        END_METHOD

        METHOD PUBLIC Result : eInspectorResult
            Result := _inspectorTask.InspectionData()^.Result;	
        END_METHOD

    
        /// <summary>
        /// Check, if data are overinspected (attempts of inspections is larger than maximum number of allowed retries)
        /// </summary>
        METHOD PUBLIC CheckOverInspection : BOOL
            //check if reference is valid
            IF _inspectorTask.InspectionData() <> NULL THEN
                CheckOverInspection := (_inspectorTask.InspectionData()^.RetryAttemptsCount >= _inspectorTask.InspectionData()^.NumberOfAllowedRetries) 
                AND (_inspectorTask.InspectionData()^.NumberOfAllowedRetries <> UINT#0);
            END_IF;
        END_METHOD
    

        /// <summary>
        /// Gets `true` when this inspection overruns max number of inspections.
        /// </summary>
        METHOD PROTECTED IsOverInspected : BOOL

            _isOverInspected := THIS.CheckOverInspection();
            IF(THIS.CheckOverInspection()) THEN			
                _inspectorTask.Invoke();
                IF(_inspectorTask.Execute()) THEN		
                    _inspectorTask.InspectionData()^.Result := eInspectorResult#Failed;
                    _inspectorTask.DoneWhen(TRUE);	
                END_IF;
            END_IF;
            
            IsOverinspected := THIS.CheckOverInspection();
            
        END_METHOD
    
    
    ///<summary>
    /// Set passed instance of iAxoCoordinator to this inspector.
    /// This method can be called only in derived classes.
    ///</summary>
    METHOD PROTECTED _WithCoordinator : IInspector
        VAR_INPUT
            inCoordinator : IAxoCoordinator;
        END_VAR

        _coordinator := inCoordinator;


        // TODO: probably restore is missing here
        // IF(_coordinator.GetCoordinatorState() = AXOpen.Core.AxoCoordinatorStates#Idle) THEN
        //     _inspectorTask.Restore();
        //     // _tcoInspectorDialogue.Restore();
        // END_IF;
        
        _WithCoordinator := THIS;
        
    END_METHOD

    /// EVALUATION METHODS
    METHOD PUBLIC OnFail : IOnFail

        // IF(_coordinator = NULL) THEN
        //     // here is coordinator missing, it should provide message to call it with WithCoordinator method
        // END_IF

        OnFail:= THIS;
        
    END_METHOD

    METHOD PUBLIC Retry : BOOL
    
        VAR_INPUT
            /// State from which the inspection will restart.	
            inAxoStep : IAxoStep;
        END_VAR

        IF(_coordinator = NULL) THEN
           RETURN;
        END_IF;

        IF(THIS.Done()) THEN
            IF(THIS.Result() = eInspectorResult#Failed) THEN
                // IF(__ISVALIDREF(_refOverallResult)) THEN
                //     _refOverallResult := _originalOverallResult;
                // END_IF
                //_coordinator;
                _coordinator.Retry(inAxoStep);
            ELSE
                _coordinator.MoveNext();
            END_IF;	
        END_IF;	


        Retry:= THIS.Done();
        
    END_METHOD



    ///<summary>
    /// When inspection is done, continue to next step.
    ///</summary>
    METHOD PUBLIC CarryOn : BOOL

        IF(_coordinator = NULL) THEN
            RETURN;			
        END_IF;
        
        IF(THIS.Done()) THEN
            _coordinator.MoveNext();
        END_IF;	
            
        CarryOn := THIS.Done();
    END_METHOD

     ///<summary>
    /// When inspection is done, continue to next step.
    ///</summary>
    METHOD PUBLIC Terminate : BOOL

        IF(_coordinator = NULL) THEN
            RETURN;			
        END_IF;
        
        
        IF(THIS.Done()) THEN
            IF(THIS.Result() = eInspectorResult#Failed) THEN
                _coordinator.Terminate();
            ELSE
                _coordinator.MoveNext();
            END_IF;	
        END_IF;	
        
        Terminate := THIS.Done();
    END_METHOD


    METHOD PUBLIC TerminateWithOriginStep : BOOL
    
        VAR_INPUT
            /// State from which the inspection will restart.	
            inAxoStep : IAxoStep;
        END_VAR

        IF(_coordinator = NULL) THEN
           RETURN;
        END_IF;

        IF(THIS.Done()) THEN
            IF(THIS.Result() = eInspectorResult#Failed) THEN
                // IF(__ISVALIDREF(_refOverallResult)) THEN
                //     _refOverallResult := _originalOverallResult;
                // END_IF
                //_coordinator;
                _coordinator.Retry(inAxoStep);
            ELSE
                _coordinator.MoveNext();
            END_IF;	
        END_IF;	


        TerminateWithOriginStep:= THIS.Done();
        
    END_METHOD

    ///<summary>
    /// Update commmon comprehensive result, which can be used across multiple inspectors
    /// Updates comprehensive result. The comprehensive result is set to `Failed` when any inspection fails or is inconclusive.
    /// Any bypassed or excluded inspections are not taken into account.	
    ///</summary>

    METHOD PUBLIC UpdateComprehensiveResult : IInspector
        VAR_IN_OUT
            inoResult : AxoComprehensiveResult;
        END_VAR
    

        UpdateComprehensiveResult := THIS;

        // if inspection data are not provided, set default result
        IF(_inspectorTask.InspectionData() = NULL ) THEN
            inoResult.SetResult(eOveralLResult#NoAction);
            RETURN;
        END_IF;

        // set result to comprehensive data only when inspection fails
        CASE _inspectorTask.InspectionData()^.Result OF

            eInspectorResult#Failed:
                inoResult.SetResult(eOverallResult#Failed);
                //TODO here I should update descriptions
                //UpdateDescriptions(inoResult);		       			
            eInspectorResult#Inconclusive:
                inoResult.SetResult(eOverallResult#Failed);
                //TODO here I should update descriptions
                //UpdateDescriptions(inoResult);	
        ELSE
            ;
        END_CASE;


    END_METHOD
    


END_CLASS





END_NAMESPACE