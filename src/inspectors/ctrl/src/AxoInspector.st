USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// AxoInspector base class with implemented evaluation methods
    /// Evaluation methods need IAxoCoordinator instance
    ///</summary>
    CLASS AxoInspector EXTENDS AXOpen.Core.AxoObject IMPLEMENTS IInspector, IOnFail
        VAR PROTECTED
            _inspectorTask: AxoInspectorTask;
            _coordinator: IAxoCoordinator;
            _isOverInspected: BOOL;
            _busy : BOOL;
            _commonData: REF_TO AxoInspectorData;
            _originalOverallResult : IAxoComprehensiveResult;   
        END_VAR
    
      
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
            _WithCoordinator := THIS;
            
        END_METHOD

        ///<summary>
        /// Returns this object defined by IOnFail interface
        ///</summary>
        METHOD PUBLIC OnFail : IOnFail

            // here if is coordinator missing, it should provide message to call it with WithCoordinator method
            OnFail:= THIS;
            
        END_METHOD

        ///<summary>
        /// Calls inspector dialog with required input
        ///</summary>
        METHOD PUBLIC Dialog : BOOL
            VAR_INPUT
                inRetryStep: IAxoStep;
                inTerminateStep: IAxoStep;
            END_VAR
            
            VAR_IN_OUT
                inoDialog : AxoInspectorDialog;
            END_VAR

            // here if is coordinator missing, it should provide message to call it with WithCoordinator method
            inoDialog.Show(REF(THIS), inRetryStep, inTerminateStep);

        END_METHOD


        ///<summary>
        /// When inspection is done, retry provided step
        ///</summary>
        METHOD PUBLIC RetryWithStep : BOOL
        
            VAR_INPUT
                /// State from which the inspection will restart.	
                inRetryStep : IAxoStep;
            END_VAR

            IF(_coordinator = NULL) THEN
            RETURN;
            END_IF;

            IF(THIS.Done()) THEN
                IF(THIS.Result() = eInspectorResult#Failed) THEN
    
                    IF(inRetryStep <> NULL) THEN

                        _coordinator.RequestStep(inRetryStep);
                    END_IF;	
                ELSE
                    _coordinator.MoveNext();
                END_IF;	
            END_IF;	


            RetryWithStep:= THIS.Done();
            
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
        /// When inspection is done, terminate provided step
        ///</summary>
        METHOD PUBLIC TerminateWithStep : BOOL
            VAR_INPUT
                inTerminateStep : AXOpen.Core.IAxoStep;
            END_VAR
            IF(_coordinator = NULL) THEN
                RETURN;			
            END_IF;
            
            
            IF(THIS.Done()) THEN
                IF(THIS.Result() = eInspectorResult#Failed) THEN
    
                    IF(inTerminateStep <> NULL) THEN

                        _coordinator.RequestStep(inTerminateStep);
                
                    END_IF;	
                ELSE
                    _coordinator.MoveNext();
                END_IF;	
            END_IF;	
            
            TerminateWithStep := THIS.Done();
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

        ///<summary>
        /// Restores inspector task
        ///</summary>
        METHOD PUBLIC RestoreInspectorTask : BOOL
            _inspectorTask.Restore();
        END_METHOD

        ///<summary>
        /// Check, if inspector task is busy
        ///</summary>
        METHOD PUBLIC Busy : BOOL
            Busy := _inspectorTask.IsBusy();
        END_METHOD

        ///<summary>
        /// Returns AxoInspectorData
        ///</summary>
        METHOD PUBLIC CommonData : REF_TO AXOpen.Inspectors.AxoInspectorData
            CommonData := _commonData;
        END_METHOD

        ///<summary>
        /// Returns current coordinator
        ///</summary>
        METHOD PUBLIC Coordinator : IAxoCoordinator
            Coordinator := _coordinator;
        END_METHOD

        ///<summary>
        /// Check, if inspection task is done
        ///</summary>
        METHOD PUBLIC Done : BOOL
            Done := _inspectorTask.IsDone();
        END_METHOD

        ///<summary>
        /// Returns inspection result
        ///</summary>
        METHOD PUBLIC Result : eInspectorResult
            Result := _inspectorTask.InspectionData()^.Result;	
        END_METHOD
    
    END_CLASS

END_NAMESPACE