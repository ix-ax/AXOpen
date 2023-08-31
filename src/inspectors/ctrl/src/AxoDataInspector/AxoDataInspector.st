USING System.Strings;

NAMESPACE AXOpen.Inspectors

    /// <summary>
    /// Class representing inspection of string value with support of star notation.
    /// </summary>
    CLASS AxoDataInspector EXTENDS AxoInspector IMPLEMENTS IAxoDataInspector
    
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Inspector data#>"}
            _data : AxoDataInspectorData;
            // result data of inspection
            {#ix-attr:[RenderIgnore()]}   
            _lastOutValue : STRING;
        END_VAR
    
    
    /// <summary>
    /// Inspection method, which contains main logic of inspection.
    /// </summary>    
    METHOD PUBLIC Inspect : IInspector
        VAR_INPUT
            _parent : AXOpen.Core.IAxoObject;
            Status : STRING;
            
        END_VAR

        VAR
            tmpResult : BOOL;
            charIndex: DINT;
            charRequired : CHAR;
            charAcquired : CHAR;	
        END_VAR

        VAR CONSTANT
            epsilon : REAL := 1;
        END_VAR

        THIS.Initialize(_parent);
        _inspectorTask.Initialize(_parent);

        //return this instance
        Inspect := THIS;

        // pass address of data to set an inspection data
        _inspectorTask.SetInspectionData(REF(_data));
        
        //check for overinspection
        IF(THIS.IsOverInspected())THEN
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

            _data.DetectedStatus := Status;
            
            // if star notation is enabled, comparison by chars is needed
            IF(_data.StarNotationEnabled) THEN
                tmpResult := TRUE;
                // iterate throug the string
                FOR charIndex := DINT#1 TO LengthOf(_data.RequiredStatus) DO

                    //get char from required string
                    charRequired := _data.RequiredStatus[charIndex];
                    

                    //get char from detected string, only if is within a range
                    IF(LengthOf(_data.DetectedStatus) >= charIndex) THEN
                        charAcquired :=  _data.DetectedStatus[charIndex];
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
                tmpResult := _data.DetectedStatus = _data.RequiredStatus;	
            END_IF;
                
            IF(NOT tmpResult) THEN
                _lastOutValue := Status;
            END_IF;

            _inspectorTask._failTimer.OnDelay(THIS,TRUE, _data.FailTime);
            _inspectorTask._passTimer.OnDelay(THIS, tmpResult, _data.PassTime);

            IF(_inspectorTask._passTimer.output OR _inspectorTask._failTimer.output) THEN
                _inspectorTask.DoneWhen(TRUE);
            THIS.OnDone();
            END_IF;	
        END_IF;
    END_METHOD

    ///<summary>
    /// Set coordinator to this instance
    ///</summary>
    METHOD PUBLIC WithCoordinator : IAxoDataInspector
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

    ///<summary>
    /// Set coordinator to this instance
    ///</summary>
    METHOD PUBLIC Data : REF_TO AxoDataInspectorData

        Data := REF(_data);
    END_METHOD


    
END_CLASS 
    
    END_NAMESPACE