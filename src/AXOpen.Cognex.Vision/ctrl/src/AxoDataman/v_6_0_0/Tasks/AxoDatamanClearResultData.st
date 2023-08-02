USING AXOpen.Core;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoDatamanClearResultData EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  System.Timer.OnDelay;
            _errorTimer :  System.Timer.OnDelay;
        END_VAR

        VAR PRIVATE 
            _infoTime   :   LTIME := LT#2S;
            _errorTime  :   LTIME := LT#5S;
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
                    Status^.Action.Id := UINT#302;
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 1 THEN
                    AcquisitionControl^.TriggerEnable := FALSE;
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.ResultsAcknowledge := TRUE;
                    Results^.Id := UINT#0; 
                    Results^.Code := UINT#0; 
                    Results^.Extended := UINT#0; 
                    Results^.Length := UINT#0; 

                    Results^.Data := '';
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 2 THEN
                    IF _infoTimer.output THEN
                        Status^.Error.Id := UINT#600;
                    END_IF;
                    IF NOT ResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    ResultsControl^.ResultsAcknowledge := FALSE;
                    THIS.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
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
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#600;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#303;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#700;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _Status <> NULL THEN
                _Status^.Action.Id := UINT#301;
            END_IF;
        END_METHOD
    END_CLASS     
END_NAMESPACE