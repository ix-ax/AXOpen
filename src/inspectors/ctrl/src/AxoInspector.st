USING AXOpen.Core;
USING System.Strings;

NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// AxoInspector base class with implemented evaluation methods.
    /// Provides methods for checking conditions and invoking inspection tasks.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS AxoInspector EXTENDS AXOpen.Core.AxoObject IMPLEMENTS IInspector, IOnFail
        VAR PROTECTED
            {#ix-attr:[CompilerOmits("POCO")]} //-"No params" Will skip the emission for all output types                        
            _inspectorTask: AxoInspectorTask;
            _coordinator: IAxoCoordinator;
            _isOverInspected: BOOL;
            _busy : BOOL;
            _commonData: REF_TO AxoInspectorData;
            _originalOverallResult : IAxoComprehensiveResult;             
        END_VAR
    
        VAR PUBLIC
            {#ix-attr:[CompilerOmits("POCO")]} //-"No params" Will skip the emission for all output types                        
            _DL :  AXOpen.Inspectors.AxoInspectorDialog;
        END_VAR    
      
        /// <summary>
        /// Check if the inspection data indicates that the maximum number of retries has been reached.
        /// Returns TRUE if overinspected.
        /// </summary>
        METHOD PUBLIC CheckOverInspection : BOOL
            //check if reference is valid
            IF _inspectorTask.InspectionData() <> NULL THEN
                CheckOverInspection := (_inspectorTask.InspectionData()^.RetryAttemptsCount >= _inspectorTask.InspectionData()^.NumberOfAllowedRetries) 
                AND (_inspectorTask.InspectionData()^.NumberOfAllowedRetries <> UINT#0);
            END_IF;
        END_METHOD
    
        /// <summary>
        /// Calls CheckOverInspection and, if TRUE, invokes the inspection task.
        /// Updates internal flag _isOverInspected.
        /// </summary>
        METHOD PROTECTED IsOverInspected : BOOL
            // Documentation: Evaluate if inspection should be terminated due to excessive retries.
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
        /// Sets the coordinator instance required by the inspector.
        /// </summary>
        METHOD PUBLIC WithCoordinator : IInspector
            VAR_INPUT
                inCoordinator : IAxoCoordinator;
            END_VAR
            // Documentation: Assign the provided coordinator and return the current instance.            
            _coordinator := inCoordinator;
            WithCoordinator := THIS;
        END_METHOD

        ///<summary>
        /// Returns this object defined by IOnFail interface.
        /// </summary>
        METHOD PUBLIC OnFail : IOnFail
            // Documentation: If no coordinator is set, the caller is advised to use WithCoordinator.
            OnFail:= THIS;
        END_METHOD

        ///<summary>
        /// Calls the inspector dialog with specified retry and terminate steps.
        /// </summary>
        METHOD PUBLIC Dialog : BOOL
            VAR_INPUT
                inRetryStep: IAxoStep;
                inTerminateStep: IAxoStep;
            END_VAR
            // Documentation: Ensure the coordinator is set before showing the dialog.
            _DL.SetSuspendCyclicExecuteIsNotCalledCheck(TRUE);
            _DL.SetSuspendMultipleExecuteCallCheck(TRUE);
            _DL.Show(REF(THIS), inRetryStep, inTerminateStep);
        END_METHOD

        ///<summary>
        /// If inspection has failed, retries the inspection with the provided step.
        /// </summary>
        METHOD PUBLIC RetryWithStep : BOOL
            VAR_INPUT
                inRetryStep : IAxoStep;
            END_VAR
            // Documentation: Check for coordinator existence. If failed, request the retry step.
            IF(_coordinator = NULL) THEN
                RETURN;
            END_IF;
            IF(THIS.Done()) THEN
                IF(THIS.Result() = eInspectorResult#Failed) THEN
                    IF(inRetryStep <> NULL) THEN
                        _coordinator.RequestStep(inRetryStep);
                        THIS.RestoreInspectorTask();
                    END_IF;	
                ELSE
                    _coordinator.MoveNext();
                    THIS.Restore();
                END_IF;	
                RetryWithStep:= TRUE;
            END_IF;	           
        END_METHOD

        METHOD PUBLIC Restore
            _inspectorTask.Restore();
        END_METHOD

        ///<summary>
        /// Continues to the next step when the inspection is completed.
        /// </summary>
        METHOD PUBLIC CarryOn : BOOL
            // Documentation: Verify that the coordinator is set and then move to the next step.
            IF(_coordinator = NULL) THEN
                RETURN;			
            END_IF;
            IF(THIS.Done()) THEN
                _coordinator.MoveNext();
                THIS.Restore();
                CarryOn := TRUE;
            END_IF;	            
        END_METHOD

        ///<summary>
        /// Terminates the coordination sequence with the provided step when the inspection fails.
        /// </summary>
        METHOD PUBLIC TerminateWithStep : BOOL
            VAR_INPUT
                inTerminateStep : AXOpen.Core.IAxoStep;
            END_VAR
            // Documentation: Terminate by requesting the terminate step or moving on based on inspection result.
            IF(_coordinator = NULL) THEN
                RETURN;			
            END_IF;
            IF(THIS.Done()) THEN
                IF(THIS.Result() = eInspectorResult#Failed) THEN
                    IF(inTerminateStep <> NULL) THEN
                        _coordinator.RequestStep(inTerminateStep);
                        THIS.RestoreInspectorTask();
                    END_IF;	
                ELSE
                    _coordinator.MoveNext();                    
                    THIS.Restore();
                END_IF;	
                TerminateWithStep := TRUE;
            END_IF;	            
        END_METHOD

        ///<summary>        
        /// Updates comprehensive result. The comprehensive result is set to `Failed` when any inspection fails or is inconclusive.
        /// Any bypassed or excluded inspections are not taken into account.	
        ///</summary>
        METHOD PUBLIC UpdateComprehensiveResult : IInspector
            VAR_IN_OUT
                inoResult : AxoComprehensiveResult;
            END_VAR
            // Documentation: Set overall result to Failed if any inspection fails or is inconclusive.
            UpdateComprehensiveResult := THIS;
            IF(_inspectorTask.InspectionData() = NULL ) THEN
                inoResult.SetResult(eOveralLResult#NoAction);
                RETURN;
            END_IF;
            CASE _inspectorTask.InspectionData()^.Result OF

                eInspectorResult#Failed:
                    inoResult.SetResult(eOverallResult#Failed);
                    //TODO here I should update descriptions
                    //UpdateDescriptions(inoResult);		       			
                eInspectorResult#Inconclusive:
                    inoResult.SetResult(eOverallResult#Failed);
                    // TODO: Consider updating detailed descriptions here.
            ELSE
                ;
            END_CASE;
        END_METHOD

        ///<summary>
        /// Restores the state of the inspector task.
        /// </summary>
        METHOD PUBLIC RestoreInspectorTask : BOOL
            _inspectorTask.Restore();
        END_METHOD

        ///<summary>
        /// Indicates if the inspector task is currently busy.
        /// </summary>
        METHOD PUBLIC Busy : BOOL
            Busy := _inspectorTask.IsBusy();
        END_METHOD

        ///<summary>
        /// Returns the common data associated with this inspector.
        /// </summary>
        METHOD PUBLIC CommonData : REF_TO AXOpen.Inspectors.AxoInspectorData
            CommonData := _commonData;
        END_METHOD

        ///<summary>
        /// Returns the current coordinator.
        /// </summary>
        METHOD PUBLIC Coordinator : IAxoCoordinator
            Coordinator := _coordinator;
        END_METHOD

        ///<summary>
        /// Checks if the inspection task has been completed.
        /// </summary>
        METHOD PUBLIC Done : BOOL
            Done := _inspectorTask.IsDone();
        END_METHOD

        ///<summary>
        /// Returns the result of the inspection.
        /// </summary>
        METHOD PUBLIC Result : eInspectorResult
            Result := _inspectorTask.InspectionData()^.Result;	
        END_METHOD
          
        METHOD PRIVATE UpdateDialogInfo
            VAR
                _step : REF_TO AxoStep;
            END_VAR    
            IF(_coordinator <> NULL) THEN
                _step ?= _coordinator.GetCurrentStep();
                IF(_step <> NULL) THEN
                    _DL._inspectionDetails := _step^.StepDescription;
                END_IF;    
            END_IF;   
        END_METHOD            

        /// <summary>
        /// Implements the analog inspection logic.
        /// </summary>
        METHOD PUBLIC Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoAnalogueInspectorData;
                Status : LREAL;
            END_VAR

            VAR
                tmpResult : BOOL;
                _minimum : LREAL;
                _value : LREAL;
                _maximum : LREAL;	
                _lastOutValue : LREAL;
                _step : REF_TO AxoStep;
            END_VAR
            VAR CONSTANT
                epsilon : REAL := 10000;
            END_VAR
                         
            _DL._inspectorType := eInspectorType#Analogue;
            _DL._analogInspectorData := inData^;
           
            // Documentation: Initialize the parent context and the associated inspector task.
            THIS.Run(inParent);
            _inspectorTask.SetSuspendMultipleExecuteCallCheck(TRUE);
            _inspectorTask.SetSuspendCyclicExecuteIsNotCalledCheck(TRUE);
            _inspectorTask.Run(inParent);            
                       
            Inspect := THIS;
            _inspectorTask.SetInspectionData(inData);
            IF(THIS.IsOverInspected())THEN
                RETURN;
            END_IF;
            _inspectorTask.Invoke();
            IF (_inspectorTask.Execute()) THEN
                IF (inData^.IsByPassed) THEN
                    inData^.Result    := eInspectorResult#Bypassed;
                    inData^.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
                    _inspectorTask.DoneWhen(TRUE);
                    RETURN;
                END_IF;
                inData^.Result := eInspectorResult#Running;
                _minimum := (inData^.RequiredMin * epsilon);
                _value := (Status * epsilon);
                _maximum := (inData^.RequiredMax * epsilon);
                inData^.DetectedStatus := Status;
                tmpResult := (_minimum <= _value) AND (_maximum >= _value);
                IF(NOT tmpResult) THEN
                    _lastOutValue := Status;
                END_IF;
                _inspectorTask._failTimer.OnDelay(THIS.GetContext(), TRUE, inData^.FailTime);
                _inspectorTask._passTimer.OnDelay(THIS.GetContext(), tmpResult, inData^.PassTime);
                IF(_inspectorTask._passTimer.output OR _inspectorTask._failTimer.output) THEN
                    _inspectorTask.DoneWhen(TRUE);
                    IF (inData^.Result = eInspectorResult#Failed) THEN
                        inData^.DetectedStatus := _lastOutValue;
                        _DL._inspectionDetails := System.Strings.Concat('min:', ToString(inData^.RequiredMin), ' max: ', ToString(inData^.RequiredMax));
                        _DL._inspectionDetails := System.Strings.Concat(_DL._inspectionDetails, ' but was: ', ToString(inData^.DetectedStatus));                        
                    END_IF;
                    THIS.OnDone();
                    THIS.UpdateDialogInfo();
                END_IF;	
            END_IF;
        END_METHOD
    
        /// <summary>
        /// Implements the string-based inspection logic.
        /// </summary>    
        METHOD PUBLIC Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoDataInspectorData;
                Status : STRING;
            END_VAR

            VAR
                tmpResult : BOOL;
                charIndex: DINT;
                charRequired : CHAR;
                charAcquired : CHAR;	
                _lastOutValue : STRING;
            END_VAR

            VAR CONSTANT
                epsilon : REAL := 1;
            END_VAR
            
            _DL._inspectorType := eInspectorType#Data;
            _DL._dataInspectorData := inData^;
            
            THIS.Run(inParent);
            _inspectorTask.SetSuspendMultipleExecuteCallCheck(TRUE);
            _inspectorTask.SetSuspendCyclicExecuteIsNotCalledCheck(TRUE);
            _inspectorTask.Run(inParent);
        
            
            Inspect := THIS;
            _inspectorTask.SetInspectionData(inData);
            IF(THIS.IsOverInspected())THEN
                RETURN;
            END_IF;
            _inspectorTask.Invoke();
            IF (_inspectorTask.Execute()) THEN
                IF (inData^.IsByPassed) THEN
                    inData^.Result    := eInspectorResult#Bypassed;
                    inData^.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
                    _inspectorTask.DoneWhen(TRUE);
                    RETURN;
                END_IF;
            
                inData^.Result := eInspectorResult#Running;
                inData^.DetectedStatus := Status;
                IF(inData^.StarNotationEnabled) THEN
                    tmpResult := TRUE;
                    // iterate throug the string
                    FOR charIndex := DINT#1 TO LengthOf(inData^.RequiredStatus) DO
                        charRequired := inData^.RequiredStatus[charIndex];
                        IF(LengthOf(inData^.DetectedStatus) >= charIndex) THEN
                            charAcquired :=  inData^.DetectedStatus[charIndex];
                        END_IF;	
                        IF(charRequired <> '*' AND charRequired <> '#') THEN
                            tmpResult := charRequired = charAcquired;
                        ELSIF(charRequired = '#') THEN
                            tmpResult := THIS.IsCharNumber(charAcquired);            	
                        END_IF;
                        IF(NOT tmpResult) THEN
                            EXIT;
                        END_IF;			
                    END_FOR;
                ELSE
                    //TODO what about spaces at the beginning and the end?
                    tmpResult := inData^.DetectedStatus = inData^.RequiredStatus;	
                END_IF;
                    
                IF(NOT tmpResult) THEN
                    _lastOutValue := Status;
                END_IF;

                _inspectorTask._failTimer.OnDelay(THIS.GetContext(), TRUE, inData^.FailTime);
                _inspectorTask._passTimer.OnDelay(THIS.GetContext(), tmpResult, inData^.PassTime);

                IF(_inspectorTask._passTimer.output OR _inspectorTask._failTimer.output) THEN
                    _inspectorTask.DoneWhen(TRUE);
                    IF (inData^.Result = eInspectorResult#Failed) THEN
                        inData^.DetectedStatus := _lastOutValue;
                        _DL._inspectionDetails := System.Strings.Concat('Req: ', inData^.RequiredStatus);
                        _DL._inspectionDetails := System.Strings.Concat(_DL._inspectionDetails, 'Actual: ', inData^.RequiredStatus); 
                    END_IF;
                    THIS.OnDone();
                    THIS.UpdateDialogInfo();
                END_IF;	
            END_IF;
        END_METHOD

        /// <summary>
        /// Implements the digital inspection logic.
        /// </summary>  
        METHOD PUBLIC Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoDigitalInspectorData;
                Status : BOOL;
            END_VAR      

            _DL._inspectorType := eInspectorType#Analogue;
            _DL._digitalInspectorData := inData^;

            THIS.Run(inParent);
            _inspectorTask.SetSuspendMultipleExecuteCallCheck(TRUE);
            _inspectorTask.SetSuspendCyclicExecuteIsNotCalledCheck(TRUE);
            _inspectorTask.Run(inParent);
            

            Inspect := THIS;
            _inspectorTask.SetInspectionData(inData);
            IF(THIS.IsOverInspected()) THEN
                RETURN;
            END_IF;
            _inspectorTask.Invoke();
            IF (_inspectorTask.Execute()) THEN
                IF (inData^.IsByPassed) THEN
            
                    inData^.Result    := eInspectorResult#Bypassed;
                
                    inData^.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
                
                    _inspectorTask.DoneWhen(TRUE);
                    RETURN;
                END_IF;
                inData^.Result := eInspectorResult#Running;
                _inspectorTask._failTimer.OnDelay(THIS.GetContext(), TRUE, inData^.FailTime);
                _inspectorTask._passTimer.OnDelay(THIS.GetContext(), Status = inData^.RequiredStatus, inData^.PassTime);
                inData^.DetectedStatus := Status; 
                IF(_inspectorTask._failTimer.output OR _inspectorTask._passTimer.output) THEN	  
                    _inspectorTask.DoneWhen(TRUE);
                    IF (inData^.Result = eInspectorResult#Failed) THEN
                        inData^.DetectedStatus := NOT inData^.RequiredStatus;
                        _DL._inspectionDetails := System.Strings.Concat('Req: ', ToString(inData^.RequiredStatus));
                        _DL._inspectionDetails := System.Strings.Concat(_DL._inspectionDetails, 'Actual: ', ToString(inData^.RequiredStatus)); 
                    END_IF;
                    THIS.OnDone();
                    THIS.UpdateDialogInfo();
                END_IF;	
            END_IF;
        END_METHOD
    
        ///<summary>
        /// Called when an inspection is completed.
        /// </summary>
        METHOD OnDone 
            ;
        END_METHOD

        ///<summary>
        /// Determines if the provided character is numeric.
        /// </summary>
        METHOD IsCharNumber : BOOL

            VAR_INPUT
                inCharacter: CHAR;
            END_VAR
            IF (inCharacter = '0'
                OR  inCharacter = '1'
                OR  inCharacter = '2'
                OR  inCharacter = '3'
                OR  inCharacter = '4'
                OR  inCharacter = '5'
                OR  inCharacter = '6'
                OR  inCharacter = '7'
                OR  inCharacter = '8'
                OR  inCharacter = '9') 
                THEN
                    IsCharNumber := TRUE;
                    RETURN;
                END_IF;
            IsCharNumber := FALSE;
        END_METHOD
    END_CLASS

END_NAMESPACE