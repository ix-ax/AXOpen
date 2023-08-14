NAMESPACE AXOpen.Inspectors

/// <summary>
/// Class representing inspection of bool value.
/// </summary>
CLASS AxoDigitalInspector EXTENDS AxoInspector IMPLEMENTS IAxoDigitalInspector

    VAR PUBLIC
        {#ix-set:AttributeName = "<#Inspector data#>"}
        _data : AxoDigitalInspectorData;
    END_VAR

    /// <summary>
    /// Inspection method, which contains main logic of inspection.
    /// </summary>  
    METHOD PUBLIC Inspect : IInspector
        VAR_INPUT
            _parent: AXOpen.Core.IAxoObject;
            Status : BOOL;
        END_VAR

        THIS.Initialize(_parent);
        _inspectorTask.Initialize(_parent);
        
        //return this instance
        Inspect := THIS;

       
        // set task inspection data, pass a reference (an address)
        // REF(_data) will get a reference of _data variable (like & in C)
        _inspectorTask.SetInspectionData(REF(_data));

        
        //here i should check, if data are overinspected
        IF(THIS.CheckOverInspection()) THEN
            RETURN;
        END_IF;

        //invoke inspection task
        _inspectorTask.Invoke();
  
        //execute inspection task
        IF (_inspectorTask.Execute()) THEN

            // if data are bypassed, skip inspection
            IF (_data.IsByPassed) THEN
           
                _data.Result    := eInspectorResult#Bypassed;
              
                _data.TimeStamp := THIS.GetContext().GetRtc().NowUTC();
               
                _inspectorTask.DoneWhen(TRUE);
                RETURN;
            END_IF;
        
     
            //set timers
            _data.Result := eInspectorResult#Running;
            _inspectorTask._failTimer(TRUE, _data.FailTime);
            _inspectorTask._passTimer(Status = _data.RequiredStatus, _data.PassTime);
            
            _data.DetectedStatus := Status; 
            
            // if any timer is satisfied, end inspection
            IF(_inspectorTask._failTimer.output OR _inspectorTask._passTimer.output) THEN	  
                _inspectorTask.DoneWhen(TRUE);
                THIS.OnDone();
              
            END_IF;	
        END_IF;


    END_METHOD

    ///<summary>
    /// If inspection fails, set result to data
    ///</summary>
    METHOD OnDone 
        IF (_data.Result = eInspectorResult#Failed) THEN
            _data.DetectedStatus := NOT _data.RequiredStatus;
       END_IF;
    END_METHOD

    ///<summary>
    /// Set coordinator to this instance
    ///</summary>
    METHOD PUBLIC WithCoordinator : IAxoDigitalInspector
        VAR_INPUT
            inCoordinator : AXOpen.Core.IAxoCoordinator;
        END_VAR

        _coordinator := inCoordinator;
        THIS._WithCoordinator(inCoordinator);

        WithCoordinator := THIS;
    END_METHOD


    ///<summary>
    /// Set coordinator to this instance
    ///</summary>
    METHOD PUBLIC Data : REF_TO AxoDigitalInspectorData

        Data := REF(_data);
    END_METHOD

   
END_CLASS 

END_NAMESPACE