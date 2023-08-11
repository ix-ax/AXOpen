USING AXOpen.Core;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoInsightTrigger EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  System.Timer.OnDelay;
            _errorTimer :  System.Timer.OnDelay;
        END_VAR

        VAR PRIVATE 
            _infoTime : LTIME := LT#2S;
            _errorTime : LTIME := LT#5S;
            _Status     :   REF_TO  AxoInsight_Status;	
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  AxoInsight_AcquisitionControl;
                refAcquisitionStatus   :   REF_TO  AxoInsight_AcquisitionStatus;
                refInspectionControl   :   REF_TO  AxoInsight_InspectionControl;
                refInspectionStatus    :   REF_TO  AxoInsight_InspectionStatus;
                refCommandControl      :   REF_TO  AxoInsight_CommandControl;
                refConfig              :   REF_TO  AxoInsight_Config;
                refStatus              :   REF_TO  AxoInsight_Status;	
                refResults             :   REF_TO  AxoInsight_Results;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR          

            VAR 
                _index : INT;
                _inspectionCompleted : BOOL;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _Status := refStatus;
        
            IF THIS.Execute() THEN
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#305;
                    refStatus^.Error.Id := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;

                IF _progress = 1 THEN
                    refAcquisitionControl^.TriggerEnable  := TRUE;
                    refAcquisitionControl^.Trigger := FALSE;
                    refAcquisitionControl^.ClearExposureComplete := refAcquisitionStatus^.ExposureComplete;
                    refAcquisitionControl^.SetOffline := FALSE;
                
                    refInspectionControl^.EnableResultsBuffering := FALSE; 
                    refInspectionControl^.AcknowledgeInspectionResults := refInspectionStatus^.ResultsValid;
                    refInspectionControl^.ExtendedUserDataSet := FALSE;
                    refInspectionControl^.ExecuteCommand := FALSE;
                    refInspectionControl^.ClearError := refInspectionStatus^.Error;
    
                    refCommandControl^.Command:= UINT#0;
                    _progress := _progress + 1;
                END_IF;

                IF _progress = 2 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#600;
                    END_IF;

                    IF NOT refAcquisitionStatus^.ExposureComplete THEN
                        refAcquisitionControl^.ClearExposureComplete := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#601;
                    END_IF;

                    IF NOT refInspectionStatus^.ResultsValid THEN
                        refInspectionControl^.AcknowledgeInspectionResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#602;
                    END_IF;

                    IF NOT refInspectionStatus^.Error THEN
                        refInspectionControl^.ClearError := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#603;
                    END_IF;

                    _inspectionCompleted := refInspectionStatus^.InspectionCompleted;
                    IF refAcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 6 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#604;
                    END_IF;

                    refAcquisitionControl^.Trigger := TRUE;
                    IF refAcquisitionStatus^.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 7 THEN	
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#605;
                    END_IF;

                    refAcquisitionControl^.Trigger := FALSE;
                    IF _inspectionCompleted <> refInspectionStatus^.InspectionCompleted THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
            
                IF _progress = 8 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#606;
                    END_IF;

                    IF refInspectionStatus^.ResultsValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 9 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#607;
                    END_IF;

                    // refResults^.InspectionId := refResultsData.InspectionID;
                    // refResults^.ResultCode := THIS^.inoIoData.ResultsData.ResultCode;
                   
                    // _size := THIS^.inoConfig.ResultDataSize;
                    // IF  Tc2_System.MEMCPY(srcAddr := ADR(THIS^.inoIoData.ResultsData.InspectionResults) , destAddr:= ADR(THIS^.inoResults.InspectionResults) ,  n:= _size) > 0 AND 
                    //     Tc2_System.MEMSET(destAddr:= ADR(THIS^.inoResults.InspectionResults) + _size, fillByte:= 0 , n:= SIZEOF(THIS^.inoResults.InspectionResults) - _size)>0 THEN
                    //     THIS.CallTimers(FALSE);
                    //     _progress := _progress + 1;
                    // END_IF;
                    FOR _index := 0 TO (TO_INT(refStatus^.ResultDataSize) - INT#1) DO
                        refResults^.InspectionResults.Data[_index] := refResultData^[_index + 4];
                    END_FOR;
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 10 THEN
                    refAcquisitionControl^.Trigger := FALSE;
                    refInspectionControl^.EnableResultsBuffering := FALSE;
                    refInspectionControl^.AcknowledgeInspectionResults := TRUE;
                    THIS.ThrowWhen(refInspectionStatus^.Error);
                    THIS.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;               


                THIS.CallTimers(TRUE);
                
                THIS.ThrowWhen(_errorTimer.output);
            END_IF;
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer(signal , _infoTime);
            _errorTimer(signal , _errorTime );
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            _Status^.Action.Id := UINT#309;
            _Status^.Error.Id  := UINT#0;
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#601;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#306;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#701;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#304;
            END_IF;
        END_METHOD
    END_CLASS    
END_NAMESPACE