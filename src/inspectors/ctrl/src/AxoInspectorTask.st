USING AXOpen.Core;
USING AXOpen.Inspectors;
USING AXOpen.Core;



NAMESPACE AXOpen.Inspectors

    {S7.extern=ReadWrite}
    CLASS AxoInspectorTask EXTENDS AxoTask
        VAR
            _onDoneFlag: BOOL;
            _inspectionData: REF_TO AxoInspectorData;

        END_VAR

        VAR INTERNAL
            _passTimer : AXOpen.Timers.OnDelayTimer;
            _failTimer : AXOpen.Timers.OnDelayTimer;
        END_VAR

        
        //getter
        METHOD PUBLIC InspectionData : REF_TO AxoInspectorData
            InspectionData := _inspectionData;
        END_METHOD

        //setter
        METHOD INTERNAL SetInspectionData : REF_TO AxoInspectorData
            VAR_INPUT
                inInspectionData: REF_TO AxoInspectorData;
            END_VAR
            _inspectionData := inInspectionData;
        END_METHOD
        

        METHOD PUBLIC OnDoneFlag : BOOL
            OnDoneFlag := _onDoneFlag;
        END_METHOD


        ///<summary>
        /// Execute inspection task.
        ///</summary>
        METHOD PUBLIC OVERRIDE Execute : BOOL
            
            _onDoneFlag := FALSE;
            Execute := SUPER.Execute();
        END_METHOD

        ////<summary>
        /// Executes once when inspection starts.
        ///</summary>
        METHOD PROTECTED OVERRIDE OnStart 
            SUPER.OnStart();
 
            // set default values for passtime and failtime if no values were provided
            IF (_inspectionData^.PassTime = T#0S) THEN
                _inspectionData^.PassTime := T#50MS;
            END_IF;
            
            IF (_inspectionData^.FailTime = T#0S) THEN
                _inspectionData^.FailTime := T#100MS;
            END_IF;
            
            _inspectionData^.Result := eInspectorResult#NoAction;

            _passTimer.Restore();
            _failTimer.Restore();
        END_METHOD

       
        METHOD PUBLIC Restore 
            SUPER.Restore();
            _onDoneFlag := FALSE;
        END_METHOD

        ////<summary>
        /// When inspection Task is done, evaluate inspection result and write to inspection data.
        ///</summary>
        METHOD PROTECTED OVERRIDE OnDone 
            SUPER.OnDone();

            // iterate number of retries
            _inspectionData^.RetryAttemptsCount := _inspectionData^.RetryAttemptsCount + UINT#1;

            // if inspection is set to be bypassed, skip evalution of result
            IF (_inspectionData^.Result = eInspectorResult#Bypassed) THEN
                RETURN;
            END_IF;

            _inspectionData^.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
            _inspectionData^.Result    := eInspectorResult#Failed;
           
            // if fail timer was not satisfied and pass timer passed, set inspector result to passed
            IF (NOT _failTimer.output AND _passTimer.output) THEN
                _inspectionData^.Result := eInspectorResult#Passed;
            END_IF;
            
            // if inspector was excluded, set result to excluded
            IF (_inspectionData^.IsExcluded) THEN
                _inspectionData^.Result := eInspectorResult#Excluded;
            END_IF;

            _onDoneFlag := TRUE;
        END_METHOD

    END_CLASS



 




END_NAMESPACE
