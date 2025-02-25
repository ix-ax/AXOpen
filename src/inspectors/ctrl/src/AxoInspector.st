USING AXOpen.Core;
USING System.Strings;

NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// AxoInspector base class with implemented evaluation methods
    /// Evaluation methods need IAxoCoordinator instance
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
                                  
            // here if is coordinator missing, it should provide message to call it with WithCoordinator method
            _DL.Show(REF(THIS), inRetryStep, inTerminateStep);

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
    
         ///<summary>
        /// Set coordinator to this instance
        ///</summary>
        METHOD PUBLIC WithCoordinator : IInspector
            VAR_INPUT
                inCoordinator : AXOpen.Core.IAxoCoordinator;
            END_VAR

            _coordinator := inCoordinator;
            THIS._WithCoordinator(inCoordinator);

            WithCoordinator := THIS;
        END_METHOD

        ///<summary>
        /// If inspection fails, set result to data
        ///</summary>
        METHOD OnDone 
            ;
        END_METHOD

        ///<summary>
        /// Check, if character is a number
        ///</summary>
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

        /// <summary>
        /// Inspection method, which contains main logic of inspection.
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
            END_VAR

            VAR CONSTANT
                epsilon : REAL := 10000;
            END_VAR
                       
            THIS.Initialize(inParent);
            _inspectorTask.Initialize(inParent);

            //return this instance
            Inspect := THIS;

            // pass address of data to set an inspection data
            _inspectorTask.SetInspectionData(inData);
            
            //check for overinspection
            IF(THIS.IsOverInspected())THEN
                RETURN;
            END_IF;

            //initialize and invoke inspector task
            _inspectorTask.Invoke();

            //do inspection
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
                    END_IF;
                    THIS.OnDone();
                END_IF;	
            END_IF;
        END_METHOD


        /// <summary>
        /// Inspection method, which contains main logic of inspection.
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

            

            THIS.Initialize(inParent);
            _inspectorTask.Initialize(inParent);

            //return this instance
            Inspect := THIS;

            // pass address of data to set an inspection data
            _inspectorTask.SetInspectionData(inData);
            
            //check for overinspection
            IF(THIS.IsOverInspected())THEN
                RETURN;
            END_IF;

            //initialize and invoke inspector task
            _inspectorTask.Invoke();


            //do inspection
            IF (_inspectorTask.Execute()) THEN
                IF (inData^.IsByPassed) THEN
                    inData^.Result    := eInspectorResult#Bypassed;
                    inData^.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
                    _inspectorTask.DoneWhen(TRUE);
                    RETURN;
                END_IF;
            
                inData^.Result := eInspectorResult#Running;

                inData^.DetectedStatus := Status;
                
                // if star notation is enabled, comparison by chars is needed
                IF(inData^.StarNotationEnabled) THEN
                    tmpResult := TRUE;
                    // iterate throug the string
                    FOR charIndex := DINT#1 TO LengthOf(inData^.RequiredStatus) DO

                        //get char from required string
                        charRequired := inData^.RequiredStatus[charIndex];
                        
                        //get char from detected string, only if is within a range
                        IF(LengthOf(inData^.DetectedStatus) >= charIndex) THEN
                            charAcquired :=  inData^.DetectedStatus[charIndex];
                        END_IF;	
                        
                        //if it's not wild card, compare chars
                        IF(charRequired <> '*' AND charRequired <> '#') THEN
                            tmpResult := charRequired = charAcquired;
                        ELSIF(charRequired = '#') THEN
                            // if is # wildcard, check for number
                            tmpResult := THIS.IsCharNumber(charAcquired);            	
                        END_IF;

                        // if tmpResult is false, we know that string are not the same, therefore exit
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
                    END_IF;
                    THIS.OnDone();
                END_IF;	
            END_IF;
        END_METHOD

        /// <summary>
        /// Inspection method, which contains main logic of inspection.
        /// </summary>  
        METHOD PUBLIC Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoDigitalInspectorData;
                Status : BOOL;
            END_VAR

           

            THIS.Initialize(inParent);
            _inspectorTask.Initialize(inParent);
            
            //return this instance
            Inspect := THIS;

            // set task inspection data, pass a reference (an address)
            // REF(_data) will get a reference of _data variable (like & in C)
            _inspectorTask.SetInspectionData(inData);
            
            //here i should check, if data are overinspected
            IF(THIS.IsOverInspected()) THEN
                RETURN;
            END_IF;

            //invoke inspection task
            _inspectorTask.Invoke();

            //execute inspection task
            IF (_inspectorTask.Execute()) THEN
                // if data are bypassed, skip inspection
                IF (inData^.IsByPassed) THEN
            
                    inData^.Result    := eInspectorResult#Bypassed;
                
                    inData^.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
                
                    _inspectorTask.DoneWhen(TRUE);
                    RETURN;
                END_IF;
            
        
                //set timers
                inData^.Result := eInspectorResult#Running;
                _inspectorTask._failTimer.OnDelay(THIS.GetContext(), TRUE, inData^.FailTime);
                _inspectorTask._passTimer.OnDelay(THIS.GetContext(), Status = inData^.RequiredStatus, inData^.PassTime);
                
                inData^.DetectedStatus := Status; 
                
                // if any timer is satisfied, end inspection
                IF(_inspectorTask._failTimer.output OR _inspectorTask._passTimer.output) THEN	  
                    _inspectorTask.DoneWhen(TRUE);
                    IF (inData^.Result = eInspectorResult#Failed) THEN
                        inData^.DetectedStatus := NOT inData^.RequiredStatus;
                    END_IF;
                    THIS.OnDone();
                END_IF;	
            END_IF;
        END_METHOD


    END_CLASS

END_NAMESPACE
