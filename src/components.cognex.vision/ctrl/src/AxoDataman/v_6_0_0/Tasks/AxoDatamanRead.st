USING AXOpen.Core;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoDatamanRead EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  System.Timer.OnDelay;
            _errorTimer :  System.Timer.OnDelay;
        END_VAR

        VAR PRIVATE 
            _infoTime : LTIME := LT#2S;
            _errorTime : LTIME := LT#5S;
            _Status     :   REF_TO  AxoDataman_Status;	
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  AxoDataman_AcquisitionControl;
                refAcquisitionStatus   :   REF_TO  AxoDataman_AcquisitionStatus;
                refResultsControl      :   REF_TO  AxoDataman_ResultsControl;
                refResultsStatus       :   REF_TO  AxoDataman_ResultsStatus;
                refConfig              :   REF_TO  AxoDataman_Config;
                refStatus              :   REF_TO  AxoDataman_Status;	
                refResults             :   REF_TO  AxoDataman_Results;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR          

            VAR
                _index : INT;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _Status := refStatus;
        
            IF THIS.Execute() THEN
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#305;
                    refStatus^.Error.Id := UINT#0;
                    THIS.CallTimers(FALSE);
                    IF refResultsStatus^.ErrorDetected THEN
                        _progress := 20;
                    ELSE
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 1 THEN
                    refAcquisitionControl^.TriggerEnable := TRUE;
                    refAcquisitionControl^.Trigger := FALSE;
                    refResultsControl^.EnableResultBuffering := FALSE;
                    refResultsControl^.ResultsAcknowledge := refResultsStatus^.ResultsAvailable;
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#600;
                    END_IF;
                    IF NOT refResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 2 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#601;
                    END_IF;
                    IF refAcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    refAcquisitionControl^.Trigger := TRUE;
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#602;
                    END_IF;
                    IF refAcquisitionStatus^.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#603;
                    END_IF;
                    IF refResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    IF refResults^.Code = UINT#0 OR refResults^.Length=UINT#0 OR refResults^.Length > TO_UINT(refStatus^.ResultDataSize) THEN
                        THIS.ThrowWhen(TRUE);
                        IF refResults^.Length > TO_UINT(refStatus^.ResultDataSize) THEN
                            refStatus^.Error.Id := UINT#713;
                        END_IF;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 6 THEN
                    System.SerDe.Deserialize(UINT#7, refResultData^, refResults^.Data);
                    refAcquisitionControl^.Trigger := FALSE;
                    refResultsControl^.EnableResultBuffering := FALSE;
                    refResultsControl^.ResultsAcknowledge := TRUE;
                    THIS.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                
                IF _progress = 20 THEN
                    refAcquisitionControl^.TriggerEnable :=FALSE;
                    refAcquisitionControl^.Trigger := FALSE;
                    refResultsControl^.EnableResultBuffering := FALSE;
                    refResultsControl^.ResultsAcknowledge := FALSE;
                    IF NOT refAcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 21 THEN
                    refAcquisitionControl^.TriggerEnable :=TRUE;
                    IF NOT refResultsStatus^.ErrorDetected THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 22 THEN
                    refAcquisitionControl^.TriggerEnable :=FALSE;
                    IF _infoTimer.elapsedTime >= T#1s THEN
                        THIS.CallTimers(FALSE);
                        _progress :=  1;
                    END_IF;
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