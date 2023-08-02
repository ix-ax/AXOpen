// USING AXOpen.Core;

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
                AcquisitionControl  :   REF_TO  AxoDataman_AcquisitionControl;
                AcquisitionStatus   :   REF_TO  AxoDataman_AcquisitionStatus;
                ResultsControl      :   REF_TO  AxoDataman_ResultsControl;
                ResultsStatus       :   REF_TO  AxoDataman_ResultsStatus;
                Config              :   REF_TO  AxoDataman_Config;
                Status              :   REF_TO  AxoDataman_Status;	
                Results             :   REF_TO  AxoDataman_Results;
                ResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR          

            VAR
                _index : INT;
            END_VAR          

            _infoTime := Config^.InfoTime;
            _errorTime := Config^.ErrorTime;
            _Status := Status;
        
            IF THIS.Execute() THEN
                IF _progress = 0 THEN
                    Status^.ActionId := UINT#305;
                    Status^.Action.Id := UINT#305;
                    THIS.CallTimers(FALSE);
                    IF ResultsStatus^.ErrorDetected THEN
                        _progress := 20;
                    ELSE
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 1 THEN
                    AcquisitionControl^.TriggerEnable := TRUE;
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.EnableResultBuffering := FALSE;
                    ResultsControl^.ResultsAcknowledge := ResultsStatus^.ResultsAvailable;
                    IF _infoTimer.output THEN
                        Status^.ErrorId := UINT#600;
                        Status^.Error.Id := UINT#600;
                    END_IF;
                    IF NOT ResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 2 THEN
                    IF _infoTimer.output THEN
                        Status^.ErrorId := UINT#601;
                        Status^.Error.Id := UINT#601;
                    END_IF;
                    IF AcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    AcquisitionControl^.Trigger := TRUE;
                    IF _infoTimer.output THEN
                        Status^.ErrorId := UINT#602;
                        Status^.Error.Id := UINT#602;
                    END_IF;
                    IF AcquisitionStatus^.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    IF _infoTimer.output THEN
                        Status^.ErrorId := UINT#603;
                        Status^.Error.Id := UINT#603;
                    END_IF;
                    IF ResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    THIS.ThrowWhen(Results^.Code = UINT#0 OR Results^.Length=UINT#0 OR Results^.Length > TO_UINT(Status^.ResultDataSize));
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 6 THEN
                    System.SerDe.Deserialize(UINT#7, ResultData^, Results^.Data);
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.EnableResultBuffering := FALSE;
                    ResultsControl^.ResultsAcknowledge := TRUE;
                    THIS.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                
                IF _progress = 20 THEN
                    AcquisitionControl^.TriggerEnable :=FALSE;
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.EnableResultBuffering := FALSE;
                    ResultsControl^.ResultsAcknowledge := FALSE;
                    IF NOT AcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 21 THEN
                    AcquisitionControl^.TriggerEnable :=TRUE;
                    IF NOT ResultsStatus^.ErrorDetected THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 22 THEN
                    AcquisitionControl^.TriggerEnable :=FALSE;
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
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _Status <> NULL THEN
                _Status^.ActionId := UINT#601;
                _Status^.Action.Id := UINT#601;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _Status <> NULL THEN
                _Status^.ActionId := UINT#306;
                _Status^.Action.Id := UINT#306;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _Status <> NULL THEN
                _Status^.ActionId := UINT#701;
                _Status^.Action.Id := UINT#701;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _Status <> NULL THEN
                _Status^.ActionId := UINT#304;
                _Status^.Action.Id := UINT#304;
            END_IF;
        END_METHOD
    END_CLASS    
END_NAMESPACE