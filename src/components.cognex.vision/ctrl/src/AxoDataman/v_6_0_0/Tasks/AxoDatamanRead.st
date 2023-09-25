USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoDatamanRead EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
        END_VAR

        VAR PRIVATE 
            _infoTime       :   LTIME := LT#2S;
            _errorTime      :   LTIME := LT#5S;
            _refStatus         :   REF_TO  AxoDataman_Status;	
            _refMessenger   :   REF_TO  AxoMessenger;	
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  AxoDataman_AcquisitionControl;
                refAcquisitionStatus   :   REF_TO  AxoDataman_AcquisitionStatus;
                refResultsControl      :   REF_TO  AxoDataman_ResultsControl;
                refResultsStatus       :   REF_TO  AxoDataman_ResultsStatus;
                refConfig              :   REF_TO  AxoDataman_Config;
                refStatus              :   REF_TO  AxoDataman_Status;	
                refResults             :   REF_TO  AxoDataman_Results;
                refResultData          :   REF_TO  AxoDataman_ResultData;
                refResultDataHW        :   REF_TO  ARRAY[*] OF BYTE;
                refMessenger           :   REF_TO  AxoMessenger;
            END_VAR          

            VAR
                _index : INT;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _refStatus := refStatus;
            _refMessenger := refMessenger;

            IF THIS.Execute() THEN
                refMessenger^.Serve(THIS);
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#305;
                    refStatus^.Error.Id := UINT#0;
                    refMessenger^.Restore();
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
                    refMessenger^.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#601;
                    END_IF;
                    IF refAcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    refMessenger^.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
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
                    refMessenger^.ActivateOnCondition(ULINT#603, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#603;
                    END_IF;
                    IF refResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    refMessenger^.ActivateOnCondition(ULINT#713, refResults^.Length > TO_UINT(refStatus^.ResultDataSize), eAxoMessageCategory#Error);
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
                    refMessenger^.ActivateOnCondition(ULINT#604, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#604;
                    END_IF;

                    FOR _index := 0 TO (TO_INT(refResults^.Length) - INT#1) DO
                        refResultData^.Data[_index] := refResultDataHW^[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(refResults^.Length) TO 245 DO
                        refResultData^.Data[_index] := BYTE#0;
                    END_FOR;
                    refResultData^.DataChanged := NOT refResultData^.DataChanged ;
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 7 THEN
                    refAcquisitionControl^.Trigger := FALSE;
                    refResultsControl^.EnableResultBuffering := FALSE;
                    refResultsControl^.ResultsAcknowledge := TRUE;
                    THIS.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                
                IF _progress = 20 THEN
                    refMessenger^.ActivateOnCondition(ULINT#605, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#605;
                    END_IF;
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
                    refMessenger^.ActivateOnCondition(ULINT#606, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#606;
                    END_IF;
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
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            _refStatus^.Action.Id := UINT#309;
            _refStatus^.Error.Id  := UINT#0;
            _refMessenger^.Restore();
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#601;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#306;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#701;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#304;
            END_IF;
        END_METHOD
    END_CLASS    
END_NAMESPACE