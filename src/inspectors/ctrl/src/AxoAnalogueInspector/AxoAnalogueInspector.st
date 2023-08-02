NAMESPACE AXOpen.Inspectors


    CLASS AxoAnalogueInspector EXTENDS AxoInspector IMPLEMENTS IAxoAnalogueInspector
    
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Inspector data#>"}
            _data : AxoAnalogueInspectorData;
            // result data of inspection
            _lastOutValue : LREAL;
        END_VAR
    
    

    METHOD PUBLIC Inspect : IInspector
        VAR_INPUT
            _parent : AXOpen.Core.IAxoObject;
            Status : LREAL;
            
        END_VAR

        VAR
            tmpResult : BOOL;
            _minimum : LREAL;
            _value : LREAL;
            _maximum : LREAL;	
        END_VAR

        VAR CONSTANT
            epsilon : REAL := 10000;
        END_VAR

        THIS.Initialize(_parent);
        _inspectorTask.Initialize(_parent);

        //return this instance
        Inspect := THIS;

        // pass address of data to set an inspection data
        _inspectorTask.SetInspectionData(REF(_data));
        
        //check for overinspection
        IF(THIS.CheckOverInspection())THEN
            RETURN;
        END_IF;

        //initialize and invoke inspector task
        _inspectorTask.Invoke();


        //do inspection
        IF (_inspectorTask.Execute()) THEN
            IF (_data.IsByPassed) THEN
                _data.Result    := eInspectorResult#Bypassed;
                _data.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
                _inspectorTask.DoneWhen(TRUE);
                RETURN;
            END_IF;
        
            _data.Result := eInspectorResult#Running;
            
            _minimum := (_data.RequiredMin * epsilon);
            _value := (Status * epsilon);
            _maximum := (_data.RequiredMax * epsilon);
            
            _data.DetectedStatus := Status;
            
             tmpResult := (_minimum <= _value) AND (_maximum >= _value);
                
             IF(NOT tmpResult) THEN
                _lastOutValue := Status;
             END_IF;
                
   
             IF(_inspectorTask._passTimer.Delay(THIS, tmpResult, _data.PassTime ) OR _inspectorTask._failTimer.Delay(THIS, TRUE, _data.FailTime)) THEN
                 _inspectorTask.DoneWhen(TRUE);
                THIS.OnDone();
             END_IF;	
        END_IF;
    END_METHOD

    ///<summary>
    /// Set coordinator to this instance
    ///</summary>
    METHOD PUBLIC WithCoordinator : IAxoAnalogueInspector
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
        IF (_data.Result = eInspectorResult#Failed) THEN
            _data.DetectedStatus := _lastOutValue;
       END_IF;
    END_METHOD

END_CLASS 
    
    END_NAMESPACE